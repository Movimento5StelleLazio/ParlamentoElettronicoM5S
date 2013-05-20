local genre
local id = param.get_id()
if id then
  genre = Genre:by_id(id)
else
  genre = Genre:new()
end

if param.get("delete", atom.boolean) then
  local name = genre.name
  genre:destroy()
  slot.put_into("notice", _("Genre '#{name}' deleted", {name = name}))
  return
end

param.update(genre, "name", "description")

genre:save()

if id then
  slot.put_into("notice", _("Genre '#{name}' updated", {name = genre.name}))
else
  slot.put_into("notice", _("Genre '#{name}' created", {name = genre.name}))
end
