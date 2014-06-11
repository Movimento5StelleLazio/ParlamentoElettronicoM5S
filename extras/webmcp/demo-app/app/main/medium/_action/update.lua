local medium
local id = param.get_id()
if id then
  medium = Medium:by_id(id)
else
  medium = Medium:new()
end

if param.get("delete", atom.boolean) then
  local name = medium.name
  medium:destroy()
  slot.put_into("notice", _("Medium '#{name}' deleted", {name = name}))
  return
end

param.update(medium, "media_type_id", "name", "copyprotected")

medium:save()

param.update_relationship{
  param_name        = "genres",
  id                = medium.id,
  connecting_model  = Classification,
  own_reference     = "medium_id",
  foreign_reference = "genre_id"
}

for index, prefix in param.iterate("tracks") do
  local id = param.get(prefix .. "id", atom.integer)
  local track
  if id then
    track = Track:by_id(id)
  elseif #param.get(prefix .. "name") > 0 then
    track = Track:new()
    track.medium_id = medium.id
  else
    break
  end
  track.position    = param.get(prefix .. "position", atom.integer)
  track.name        = param.get(prefix .. "name")
  track.description = param.get(prefix .. "description")
  track.duration    = param.get(prefix .. "duration")
  track:save()
end


if id then
  slot.put_into("notice", _("Medium '#{name}' updated", {name = medium.name}))
else
  slot.put_into("notice", _("Medium '#{name}' created", {name = medium.name}))
end
