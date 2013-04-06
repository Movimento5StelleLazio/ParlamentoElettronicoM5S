local initiative = Initiative:new_selector():add_where{ "id = ?", param.get_id()}:single_object_mode():exec()

-- TODO important m1 selectors returning result _SET_!
local issue = initiative:get_reference_selector("issue"):for_share():single_object_mode():exec()

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

local member = app.session.member

local supporter = Supporter:by_pk(initiative.id, member.id)

if supporter then  
  supporter:destroy()
--  slot.put_into("notice", _"Your support has been removed from this initiative")
else
--  slot.put_into("notice", _"You are already not supporting this initiative")
end