local alphabet = {
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
  "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
  "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
  "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/"
}

function encode.mime.base64(str)
  local parts = {}
  local pos = 1
  local block_count = 0
  while pos <= #str do
    local s = string.sub(str, pos, pos + 2)
    local n = 0
    for i = 1, 3 do
      n = n * 256
      if i <= #s then
        n = n + string.byte(string.sub(s, i, i))
      end
    end
    parts[#parts+1] = alphabet[math.floor(n / 262144) + 1]
    parts[#parts+1] = alphabet[math.floor(n / 4096) % 64 + 1]
    if #s > 1 then
      parts[#parts+1] = alphabet[math.floor(n / 64) % 64 + 1]
    else
      parts[#parts+1] = "="
    end
    if #s > 2 then
      parts[#parts+1] = alphabet[n % 64 + 1]
    else
      parts[#parts+1] = "="
    end
    block_count = block_count + 1
    if block_count == 19 then
      parts[#parts+1] = "\r\n"
      block_count = 0
    end
    pos = pos + #s
  end
  if block_count > 0 then
    parts[#parts+1] = "\r\n"
  end
  return table.concat(parts)
end
