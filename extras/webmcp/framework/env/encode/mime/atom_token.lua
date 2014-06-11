function encode.mime.atom_token(str)
  local charset = "UTF-8"  -- TODO: support other charsets via locale system
  if
    string.find(str, "^[0-9A-Za-z!#%$%%&'%*%+%-/=%?%^_`{|}~]+$")
  then
    return str
  elseif
    string.find(str, "^[\t 0-9A-Za-z!#%$%%&'%*%+%-/=%?%^_`{|}~]+$")
  then
    return '"' .. str .. '"'
  elseif
    string.find(str, "^[\t -~]*$")
  then
    local parts = { '"' }
    for char in string.gmatch(str, ".") do
      if char == '"' or char == "\\" then
        parts[#parts+1] = "\\"
      end
      parts[#parts+1] = char
    end
    parts[#parts+1] = '"'
    return table.concat(parts)
  else
    local parts = { "=?", charset, "?Q?" }
    for char in string.gmatch(str, ".") do
      local byte = string.byte(char)
      if string.find(char, "^[0-9A-Za-z%.%-]$") then
        parts[#parts+1] = char
      else
        local byte = string.byte(char)
        if byte == 32 then
          parts[#parts+1] = "_"
        else
          parts[#parts+1] = string.format("=%02X", byte)
        end
      end
    end
    parts[#parts+1] = "?="
    return table.concat(parts)
  end
end