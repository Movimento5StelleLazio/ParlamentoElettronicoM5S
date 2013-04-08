local initiative = Initiative:by_id(param.get("initiative_id"))
local member = Member:by_id(param.get("member_id"))

if not member then
  slot.put_into("error", _"Please choose a member")
  return false
end

local initiator = Initiator:by_pk(initiative.id, app.session.member.id)
if not initiator or initiator.accepted ~= true then
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

local initiator = Initiator:by_pk(initiative.id, member.id)
if initiator then
  if initiator.accepted == true then
    slot.put_into("error", _"This member is already initiator of this initiative")
  elseif initiator.accepted == false then
    slot.put_into("error", _"This member has rejected to become initiator of this initiative")
  elseif initiator.accepted == nil then
    slot.put_into("error", _"This member is already invited to become initiator of this initiative")
  end
  return false
end

local initiator = Initiator:new()
initiator.initiative_id = initiative.id
initiator.member_id = member.id
initiator.accepted = nil
initiator:save()

--slot.put_into("notice", _"Member is now invited to be initiator")

