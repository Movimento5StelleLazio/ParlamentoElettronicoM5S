local member = app.session.member
local other_member = Member:by_id(param.get_id())

local ignore_member = IgnoredMember:by_pk(member.id, other_member.id)

if param.get("delete", atom.boolean) then
  if ignore_member then
    ignore_member:destroy()
  end
  return
end

if not ignore_member then
  ignore_member = IgnoredMember:new()
  ignore_member.member_id = member.id
  ignore_member.other_member_id = other_member.id
  ignore_member:save()
end


