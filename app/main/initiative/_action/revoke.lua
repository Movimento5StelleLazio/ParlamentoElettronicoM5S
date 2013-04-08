local initiative = Initiative:by_id(param.get_id())

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
elseif not issue.accepted and issue.phase_finished then
  slot.put_into("error", _"Current phase is already closed.")
  return false
end

if initiative.revoked then
  slot.put_into("error", _"This initiative is already revoked")
  return false
end

local suggested_initiative_id = param.get("suggested_initiative_id", atom.integer)

if suggested_initiative_id ~= -1 then
  local suggested_initiative = Initiative:by_id(suggested_initiative_id)
  if not suggested_initiative then
    error("object not found")
  end
  if initiative.id == suggested_initiative.id then
    slot.put_into("error", _"You can't suggest the initiative you are revoking")
    return false
  end
  initiative.suggested_initiative_id = suggested_initiative.id
end

if not param.get("are_you_sure", atom.boolean) then
  slot.put_into("error", _"You have to mark 'Are you sure' to revoke!")
  return false
end

initiative.revoked_by_member_id = app.session.member_id
initiative.revoked = "now"
initiative:save()

slot.put_into("notice", _"Initiative is revoked now")

