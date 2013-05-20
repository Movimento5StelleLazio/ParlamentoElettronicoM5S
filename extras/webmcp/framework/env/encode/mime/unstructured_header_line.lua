function encode.mime.unstructured_header_line(key, value)
  if not value then
    return ""
  end
  local charset = "UTF-8"  -- TODO: support other charsets
  local key_length = #key + #(": ")
  if string.find(value, "^[\t -~]*$") then
    local need_encoding = false
    local parts = { key, ": " }
    local line_length = key_length
    local first_line = true
    for spaced_word in string.gmatch(value, "[\t ]*[^\t ]*") do
      if #spaced_word + line_length > 76 then
        if first_line or #spaced_word > 76 then
          need_encoding = true
          break
        end
        parts[#parts+1] = "\r\n"
        line_length = 0
      end
      parts[#parts+1] = spaced_word
      line_length = line_length + #spaced_word
      first_line = false
    end
    if not need_encoding then
      parts[#parts+1] = "\r\n"
      return table.concat(parts)
    end
    charset = "US-ASCII"
  end
  local parts = { key, ": " }
  local line_length
  local opening = "=?" .. charset .. "?Q?"
  local closing = "?="
  local indentation = ""
  for i = 1, key_length do
    indentation = indentation .. " "
  end
  local open = false
  for char in string.gmatch(value, ".") do
    local encoded_char
    if string.find(char, "^[0-9A-Za-z%.%-]$") then
      encoded_char = char
    else
      local byte = string.byte(char)
      if byte == 32 then
        encoded_char = "_"
      else
        encoded_char = string.format("=%02X", byte)
      end
    end
    if open and line_length + #encoded_char > 76 then
      parts[#parts+1] = closing
      parts[#parts+1] = "\r\n"
      parts[#parts+1] = indentation
      open = false
    end
    if not open then
      parts[#parts+1] = opening
      line_length = key_length + #opening + #closing
      open = true
    end
    parts[#parts+1] = encoded_char
    line_length = line_length + #encoded_char
  end
  if open then
    parts[#parts+1] = "?="
  end
  parts[#parts+1] = "\r\n"
  return table.concat(parts)
end
