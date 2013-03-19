local member = app.session.member
local initiative = Initiative:by_id(param.get_id())

local ignore_initiative = IgnoredInitiative:by_pk(member.id, initiative.id)

if param.get("delete", atom.boolean) then
  if ignore_initiative then
    ignore_initiative:destroy()
  end
  return
end

if not ignore_initiative then
  ignore_initiative = IgnoredInitiative:new()
  ignore_initiative.member_id = member.id
  ignore_initiative.initiative_id = initiative.id
  ignore_initiative:save()
end


