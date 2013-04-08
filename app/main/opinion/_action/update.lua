local member_id = app.session.member.id

local suggestion_id = param.get("suggestion_id", atom.integer)

local opinion = Opinion:by_pk(member_id, suggestion_id)

local suggestion = Suggestion:by_id(suggestion_id)

if not suggestion then
  slot.put_into("error", _"This suggestion has been meanwhile deleted")
  return false
end

-- TODO important m1 selectors returning result _SET_!
local issue = suggestion.initiative:get_reference_selector("issue"):for_share():single_object_mode():exec()

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

if param.get("delete") then
  if opinion then
    opinion:destroy()
  end
  --slot.put_into("notice", _"Your rating has been deleted")
  return
end

local degree = param.get("degree", atom.number)
local fulfilled = param.get("fulfilled", atom.boolean)

if degree ~= 0 and not app.session.member:has_voting_right_for_unit_id(suggestion.initiative.issue.area.unit_id) then
  error("access denied")
end

if not opinion then
  opinion = Opinion:new()
  opinion.member_id     = member_id
  opinion.suggestion_id = suggestion_id
  opinion.fulfilled     = false
end


if degree ~= nil then
  opinion.degree = degree
end

if fulfilled ~= nil then
  opinion.fulfilled = fulfilled
end

opinion:save()

--slot.put_into("notice", _"Your rating has been updated")
