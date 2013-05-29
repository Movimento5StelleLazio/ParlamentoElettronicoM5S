function encode.mime.quoted_printable_text_content(str)
  local parts = {}
  for str_part in string.gmatch(str, "[^\r\n]+[\r\n]*") do
    local line, extra_gap = string.match(str_part, "^([^\r\n]+)\r?\n?(.*)$")
    local line_length = 0
    for char in string.gmatch(line, ".") do
      if string.find(char, "^[\t -<>-~]$") then
        if line_length + 1 > 75 then
          parts[#parts+1] = "=\r\n"
          line_length = 0
        end
        parts[#parts+1] = char
        line_length = line_length + 1
      else
        if line_length + 3 > 75 then
          parts[#parts+1] = "=\r\n"
          line_length = 0
        end
        parts[#parts+1] = string.format("=%02X", string.byte(char))
        line_length = line_length + 3
      end
    end
    for i = 1, #extra_gap do
      if string.sub(extra_gap, i, i) == "\n" then
        parts[#parts+1] = "\r\n"
      end
    end
    parts[#parts+1] = "\r\n"
  end
  return table.concat(parts)
end
