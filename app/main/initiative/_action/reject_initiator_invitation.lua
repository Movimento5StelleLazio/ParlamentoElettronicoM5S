local initiative = Initiative:by_id(param.get("initiative_id"))
local initiator = Initiator:by_pk(initiative.id, app.session.member.id)

-- TODO important m1 selectors returning result _SET_!
local issue = initiative:get_reference_selector("issue"):for_share():single_object_mode():exec()

if issue.closed then
  slot.put_into("error", _"This issue is already closed.")
  return false
elseif issue.half_frozen then 
  slot.put_into("error", _"This issue is already frozen.")
  return false
end

if initiator.accepted ~= nil then
  error("access denied")
end

initiator.accepted = false
initiator:save()

--slot.put_into("notice", _"Invitation has been refused")


