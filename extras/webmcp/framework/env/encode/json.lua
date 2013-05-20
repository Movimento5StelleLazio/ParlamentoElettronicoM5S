--[[--
json_string =  -- JavaScript code representing the given datum (with quotes, if needed)
encode.json(
  obj          -- true, false, nil or a number or string
)

This function encodes any native datatype or atom in JavaScript object notation (JSON). It ensures that the returned string can be safely included in inline scripts both in HTML and XHTML (within CDATA section).

TODO: can't distinguish unambiguously between empty object and empty list!

--]]--

-- TODO: check if numeric representations are JSON compatible

function encode.json(obj)
  if obj == nil then
    return "null";
  elseif atom.has_type(obj, atom.boolean) then
    return tostring(obj)
  elseif atom.has_type(obj, atom.number) then
    return tostring(obj)
  elseif type(obj) == "table" then
    local parts = {}
    local first = true
    if #obj > 0 then
      parts[#parts+1] = "["
      for idx, value in ipairs(obj) do
        if first then
          first = false
        else
          parts[#parts+1] = ","
        end
        parts[#parts+1] = tostring(value)
      end
      parts[#parts+1] = "]"
    else
      parts[#parts+1] = "{"
      for key, value in pairs(obj) do
        if first then
          first = false
        else
          parts[#parts+1] = ","
        end
        parts[#parts+1] = encode.json(key)
        parts[#parts+1] = ":"
        parts[#parts+1] = encode.json(value)
      end
      parts[#parts+1] = "}"
    end
    return table.concat(parts)
  else
    local str = atom.dump(obj)
    str = string.gsub(str, ".",
      function (char)
        if char == '\r' then return '\\r'  end
        if char == '\n' then return '\\n'  end
        if char == '\\' then return '\\\\' end
        if char == '"'  then return '\\"'  end
        local byte = string.byte(char)
        if byte < 32 then return string.format("\\u%04x", byte) end
      end
    )
    str = string.gsub(str, "</", "<\\/")
    str = string.gsub(str, "<!%[CDATA%[", "\\u003c![CDATA[")
    str = string.gsub(str, "]]>", "]]\\u003e")
    return '"' .. str .. '"'
  end
end
