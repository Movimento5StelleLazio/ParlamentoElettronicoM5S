--[[--
blob =          -- loaded string
tempstore.pop(
  key           -- key as returned by tempstore.save(...)
)

This function restores data, which had been stored temporarily by tempstore.save(...). After loading the data, it is deleted from the tempstore automatically.

--]]--

function tempstore.pop(key)
  local filename = encode.file_path(
    request.get_app_basepath(), 'tmp', "tempstore-" .. key .. ".tmp"
  )
  local file = io.open(filename, "r")
  if not file then return nil end
  local blob = file:read("*a")
  io.close(file)
  os.remove(filename)
  return blob
end
