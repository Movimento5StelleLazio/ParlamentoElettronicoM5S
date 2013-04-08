local truster_id = app.session.member.id

local trustee_id = param.get("trustee_id", atom.integer)

local unit_id = param.get("unit_id", atom.integer)

local area_id = param.get("area_id", atom.integer)

local issue_id = param.get("issue_id", atom.integer)

local initiative_id = param.get("initiative_id", atom.integer)

if issue_id then 
  area_id = nil
end

local preview = param.get("preview") 

if preview == "1" then
  request.redirect{ module = "delegation", view = "show", params = {
    unit_id = unit_id, area_id = area_id, issue_id = issue_id, initiative_id = initiative_id, preview_trustee_id = trustee_id
  } }
  return
end

local delegation = Delegation:by_pk(truster_id, unit_id, area_id, issue_id)


if param.get("delete") or trustee_id == -1 then

  if delegation then
    delegation:destroy()
  end

else
  
  local trustee
  
  if trustee_id then
    trustee = Member:by_id(trustee_id)
  end

  local check_unit_id
  if unit_id then
    check_unit_id = unit_id
  elseif area_id then
    local area = Area:by_id(area_id)
    check_unit_id = area.unit_id
  else
    local issue = Issue:by_id(issue_id)
    local area = Area:by_id(issue.area_id)
    check_unit_id = area.unit_id
  end
  
  if trustee and not trustee:has_voting_right_for_unit_id(check_unit_id) then
    slot.put_into("error", _"Trustee has no voting right in this unit")
    return false
  end

  if not app.session.member:has_voting_right_for_unit_id(check_unit_id) then
    error("access denied")
  end

  if not delegation then
    delegation = Delegation:new()
    delegation.truster_id = truster_id
    delegation.unit_id    = unit_id
    delegation.area_id    = area_id
    delegation.issue_id   = issue_id
    if issue_id then
      delegation.scope = "issue"
    elseif area_id then
      delegation.scope = "area"
    elseif unit_id then
      delegation.scope = "unit"
    end
  end
  if trustee_id == 0 then
    delegation.trustee_id = nil
  else
    delegation.trustee_id = trustee_id
  end

  delegation:save()

end

