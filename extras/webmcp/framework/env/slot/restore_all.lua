--[[--
slot.restore_all(
  blob             -- string as returned by slot.dump_all()
)

Restores all slots using a string created by slot.dump_all().

--]]--

local function decode(str)
  return (
    string.gsub(
      str,
      "%[[a-z]+%]",
      function(char)
        if char == "[eq]" then return "="
        elseif char == "[s]" then return ";"
        elseif char == "[o]" then return "["
        elseif char == "[c]" then return "]"
        else end
      end
    )
  )
end

function slot.restore_all(blob)
  slot.reset_all()
  for encoded_key, encoded_value in string.gmatch(blob, "([^=;]*)=([^=;]*)") do
    local key, value = decode(encoded_key), decode(encoded_value)
    slot._data[key].string_fragments = { value }
  end
end
