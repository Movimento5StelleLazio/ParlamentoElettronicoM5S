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

if initiative.revoked then
  slot.put_into("error", _"This initiative is revoked")
  return false
end

local initiator_todelete = Initiator:by_pk(initiative.id, param.get("member_id", atom.integer))

if not (initiator and initiator.accepted) and not (initiator.member_id == initiator_todelete.member_id) then
  error("access denied")
end

if initiator_todelete.accepted == false and initiator.member_id ~= initiator_todelete.member_id then
  error("access denied")
end

local initiators = initiative
  :get_reference_selector("initiators")
  :add_where("accepted")
  :for_update()
  :exec()

if #initiators > 1 or initiator_todelete.accepted ~= true then
  initiator_todelete:destroy()
--  slot.put_into("notice", _"Member has been removed from initiators")
else
  slot.put_into("error", _"Can't remove last initiator")
  return false
end


