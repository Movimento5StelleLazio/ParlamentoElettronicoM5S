local initiator = Initiator:by_pk(param.get_id(), app.session.member.id)

if not initiator then
  slot.put_into("error", _"Sorry, but you are currently not invited")
  return
end

-- TODO important m1 selectors returning result _SET_!
local issue = initiator.initiative:get_reference_selector("issue"):for_share():single_object_mode():exec()

if issue.closed then
  slot.put_into("error", _"This issue is already closed.")
  return false
elseif issue.half_frozen then 
  slot.put_into("error", _"This issue is already frozen.")
  return false
end

if initiator.initiative.revoked then
  slot.put_into("error", _"This initiative is revoked")
  return false
end

if initiator.accepted then
  slot.put_into("error", _"You are already initiator")
  return
end

initiator.accepted = true
initiator:save()

slot.put_into("notice", _"You are now initiator of this initiative")
