local function extract_numbers(str)
  local result = {}
  for char in string.gmatch(str, "[0-9]") do
    result[#result+1] = char
  end
  return table.concat(result)
end

function parse.currency(str, dest_type, options)
  local str = parse._pre_fold(str)
  local dest_type = dest_type or atom.number
  local options = options or {}
  local currency_decimal_point = locale.get("currency_decimal_point")
  local decimal_point = locale.get("decimal_point") or "."
  local pos1, pos2
  if currency_decimal_point then
    pos1, pos2 = string.find(str, currency_decimal_point, 1, true)
  end
  if not pos1 then
    pos1, pos2 = string.find(str, decimal_point, 1, true)
  end
  if pos1 then
    local p1 = extract_numbers(string.sub(str, 1, pos1 - 1))
    local p2 = extract_numbers(string.sub(str, pos2 + 1, #str))
    return parse.decimal(p1 .. decimal_point .. p2, dest_type, options)
  else
    return parse.decimal(extract_numbers(str), dest_type, options)
  end
end
