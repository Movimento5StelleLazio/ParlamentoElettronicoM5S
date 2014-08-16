local scan_type = param.get("scan_type")
local record = IdcardScan:by_pk(param.get_id(), scan_type)

print('Cache-Control: no-cache'); -- let the client cache the image for 5 minutes

if record == nil then
    print('Location: ' .. encode.url { static = 'icons/16/lightning.png' } .. '\n\n')
    exit()
end

slot.set_layout(nil, 'image/jpeg')

if record then
    slot.put_into("data", record.data)
end
