local media_type
local id = param.get_id()
if id then
  media_type = MediaType:by_id(id)
else
  media_type = MediaType:new()
end

if param.get("delete", atom.boolean) then
  local name = media_type.name
  media_type:destroy()
  slot.put_into("notice", _("Media type '#{name}' deleted", {name = name}))
  return
end

param.update(media_type, "name", "description")

media_type:save()

if id then
  slot.put_into("notice", _("Media type '#{name}' updated", {name = media_type.name}))
else
  slot.put_into("notice", _("Media type '#{name}' created", {name = media_type.name}))
end
