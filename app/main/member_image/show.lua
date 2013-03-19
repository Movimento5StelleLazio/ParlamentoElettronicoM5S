local image_type = param.get("image_type")
local record = MemberImage:by_pk(param.get_id(), image_type, true)

print('Cache-Control: max-age=300'); -- let the client cache the image for 5 minutes

if record == nil then
  local default_file = ({ avatar = "avatar.jpg", photo = nil })[image_type]
  if default_file then
    print('Location: ' .. encode.url{ static = default_file } .. '\n\n')
  else
    print('Location: ' .. encode.url{ static = 'icons/16/lightning.png' } .. '\n\n')
  end
  exit()
end

assert(record.content_type, "No content-type set for image.")

slot.set_layout(nil, record.content_type)

if record then
  slot.put_into("data", record.data)
end
