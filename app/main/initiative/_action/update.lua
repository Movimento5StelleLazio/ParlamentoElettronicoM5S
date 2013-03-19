local initiative = Initiative:by_id(param.get_id())

local initiator = Initiator:by_pk(initiative.id, app.session.member.id)
if not initiator or not initiator.accepted then
  error("access denied")
end

-- TODO important m1 selectors returning result _SET_!
local issue = initiative:get_reference_selector("issue"):for_share():single_object_mode():exec()

if issue.closed then
  slot.put_into("error", _"This issue is already closed.")
  return false
elseif issue.half_frozen then 
  slot.put_into("error", _"This issue is already frozen.")
  return false
end

if initiative.revoked then
  slot.put_into("error", _"This initiative is revoked")
  return false
end

param.update(initiative, "discussion_url")
initiative:save()

slot.put_into("notice", _"Initiative successfully updated")

