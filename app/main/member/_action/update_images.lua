local member_id = app.session.member_id

local deleted = 0
local updated = 0

for i, image_type in ipairs{"avatar", "photo"} do

  local member_image = MemberImage:by_pk(member_id, image_type, false)
  local member_image_scaled = MemberImage:by_pk(member_id, image_type, true)

  if param.get(image_type .. "_delete", atom.boolean) then
    if member_image then
      member_image:destroy()
    end
    if member_image_scaled then
      member_image_scaled:destroy()
    end
    deleted = deleted + 1
  else

    local data = param.get(image_type)
    if data and #data > 0 and #data < 1024*1024 then
      local convert_func = config.member_image_convert_func[image_type]
      local data_scaled, err, status = convert_func(data)
      if status ~= 0 or data_scaled == nil then
        slot.put_into("error", _"Error while converting image. Please note, that only JPG files are supported!")
        return false
      end

      if not member_image then
        member_image = MemberImage:new()
        member_image.member_id = member_id
        member_image.image_type = image_type
        member_image.scaled = false
        member_image.content_type = cgi.post_types[image_type] or nil
        member_image.data = ""
        member_image:save()
      end

      if not member_image_scaled then
        member_image_scaled = MemberImage:new()
        member_image_scaled.member_id = member_id
        member_image_scaled.image_type = image_type
        member_image_scaled.scaled = true
        member_image_scaled.content_type = config.member_image_content_type
        member_image_scaled.data = ""
        member_image_scaled:save()
      end

      if data and #data > 0 then
        db:query{ "UPDATE member_image SET data = $ WHERE member_id = ? AND image_type='" .. image_type .. "' AND scaled=FALSE", { db:quote_binary(data) }, app.session.member.id }
      end

      if data_scaled and #data_scaled > 0 then
        db:query{ "UPDATE member_image SET data = $ WHERE member_id = ? AND image_type='" .. image_type .. "' AND scaled=TRUE", { db:quote_binary(data_scaled) }, app.session.member.id }
      end

      updated = updated + 1
    end
  end
end

if updated > 0 then
  slot.put_into("notice", _("#{number} Image(s) has been updated", { number = updated }))
end
if updated > 0 and deleted > 0 then
  slot.put_into("notice", " &middot; ")
end
if deleted > 0 then
  slot.put_into("notice", _("#{number} Image(s) has been deleted", { number = deleted }))
end

if updated == 0 and deleted == 0 then
  slot.put_into("warning", _("No changes to your images were made"))
end