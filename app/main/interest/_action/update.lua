local issue_id = assert(param.get("issue_id", atom.integer), "no issue id given")

local interest = Interest:by_pk(issue_id, app.session.member.id)

local issue = Issue:new_selector():add_where{ "id = ?", issue_id }:for_share():single_object_mode():exec()

if issue.closed then
  slot.put_into("error", _"This issue is already closed.")
  return false
elseif issue.fully_frozen then 
  slot.put_into("error", _"Voting for this issue has already begun.")
  return false
elseif 
  (issue.half_frozen and issue.phase_finished) or
  (not issue.accepted and issue.phase_finished) 
then
  slot.put_into("error", _"Current phase is already closed.")
  return false
end

if param.get("delete", atom.boolean) then
  if interest then
    interest:destroy()
    --slot.put_into("notice", _"Interest removed")
  else
    --slot.put_into("notice", _"Interest not existent")
  end
  return
end

if not app.session.member:has_voting_right_for_unit_id(issue.area.unit_id) then
  error("access denied")
end

if not interest then
  interest = Interest:new()
  interest.issue_id   = issue_id
  interest.member_id  = app.session.member_id
end

interest:save()

--slot.put_into("notice", _"Interest updated")
