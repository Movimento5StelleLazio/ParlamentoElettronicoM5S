--[[--
blob =           -- string for later usage with slot.restore_all(...)
slot.dump_all()

Returns a single string, containing all slot contents. The result of this function can be used to restore all slots after a 303 redirect. This is done automatically by the WebMCP using slot.restore_all(...). If the result of this function is an empty string, then all slots are empty.

--]]--

local function encode(str)
  return (
    string.gsub(
      str,
      "[=;%[%]]",
      function(char)
        if char == "=" then return "[eq]"
        elseif char == ";" then return "[s]"
        elseif char == "[" then return "[o]"
        elseif char == "]" then return "[c]"
        else end
      end
    )
  )
end

function slot.dump_all()
  local blob_parts = {}
  for key in pairs(slot._data) do
    if type(key) == "string" then
      local value = slot.get_content(key)
      if value ~= "" then
        blob_parts[#blob_parts + 1] = encode(key) .. "=" .. encode(value)
      end
    end
  end
  return table.concat(blob_parts, ";")
end
