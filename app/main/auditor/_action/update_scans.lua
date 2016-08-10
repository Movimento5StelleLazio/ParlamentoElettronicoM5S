local member_id = param.get("member_id", atom.integer)

local member = Member:by_id(member_id)

if not member then
    slot.put_into("error", _ "User does not exists")
    return false
end

if member and member.certifier_id ~= app.session.member_id then
    slot.put_into("error", _ "You cannot modify an user not created by you!")
    return false
end

local deleted = 0
local updated = 0

for i, scan_type in ipairs { 'id_front', 'id_rear', 'id_picture', 'nin', 'health_insurance' } do

    local image = IdcardScan:by_pk(member_id, scan_type)

    if param.get(scan_type .. "_delete", atom.boolean) then
        if image then
            image:destroy()
        end
        deleted = deleted + 1
    else

        local data = param.get(scan_type)
        if data and #data > 0 and #data < 1024 * 1024 * 2 then
            --[[
            local convert_func = config.member_image_convert_func[scan_type]
            local data_scaled, err, status = convert_func(data)
            if status ~= 0 or data_scaled == nil then
              slot.put_into("error", _"Error while converting image. Please note, that only JPG files are supported!")
              return false
            end
            --]]
            if not image then
                image = IdcardScan:new()
                image.member_id = member_id
                image.scan_type = scan_type
                --        image.content_type = cgi.post_types[image_type] or nil
                image.data = ""
                image:save()
            end

            if data and #data > 0 then
                db:query { "UPDATE idcard_scan SET data = $ WHERE member_id = ? AND scan_type='" .. scan_type .. "'", { db:quote_binary(data) }, member_id }
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
