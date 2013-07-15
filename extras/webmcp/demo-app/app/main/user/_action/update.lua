local user
local id = param.get_id()
if id then
  user = User:by_id(id)
else
  user = User:new()
end

if param.get("delete", atom.boolean) then
  local name = user.name
  user:destroy()
  slot.put_into("notice", _("User '#{name}' deleted", {name = name}))
  return
end

param.update(user, "ident", "password", "name", "write_priv", "admin")

user:save()

if id then
  slot.put_into("notice", _("User '#{name}' updated", {name = user.name}))
else
  slot.put_into("notice", _("User '#{name}' created", {name = user.name}))
end
