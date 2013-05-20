--[[--
key =            -- key to be used with tempstore.pop(...) to regain the stored string
tempstore.save(
  blob           -- string to be stored
)

This function stores data temporarily. It is used to restore slot information after a 303 HTTP redirect. It returns a key, which can be passed to tempstore.pop(...) to regain the stored data.

--]]--

function tempstore.save(blob)
  local key = multirand.string(26, "123456789bcdfghjklmnpqrstvwxyz");
  local filename = encode.file_path(
    request.get_app_basepath(), 'tmp', "tempstore-" .. key .. ".tmp"
  )
  local file = assert(io.open(filename, "w"))
  file:write(blob)
  io.close(file)
  return key
end