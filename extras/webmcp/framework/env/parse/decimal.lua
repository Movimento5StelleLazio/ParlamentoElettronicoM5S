local digit_set = {
  ["0"] = true, ["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true,
  ["5"] = true, ["6"] = true, ["7"] = true, ["8"] = true, ["9"] = true
}

function parse.decimal(str, dest_type, options)
  local str = parse._pre_fold(str)
  local dest_type = dest_type or atom.number
  local options = options or {}
  if str == "" then
    return nil
  else
    local decimal_shift = options.decimal_shift or 0
    if decimal_shift == true then
      decimal_shift = options.precision
    end
    local decimal_point = locale.get("decimal_point") or "."
    local negative    = nil
    local int         = 0
    local frac        = 0
    local precision   = 0
    local after_point = false
    for char in string.gmatch(str, ".") do
      local skip = false
      if negative == nil then
        if char == "+" then
          negative = false
          skip = true
        elseif char == "-" then  -- real minus sign already replaced by _pre_fold
          negative = true
          skip = true
        end
      end
      if not skip then
        if digit_set[char] then
          if after_point then
            if decimal_shift > 0 then
              int = 10 * int + tonumber(char)
              decimal_shift = decimal_shift - 1
            else
              frac = 10 * frac + tonumber(char)
              precision = precision + 1
            end
          else
            int = 10 * int + tonumber(char)
          end
        elseif char == decimal_point then
          if after_point then
            return dest_type.invalid
          else
            after_point = true
          end
        elseif char ~= " " then  -- TODO: ignore thousand seperator too, when supported by format.decimal
          return dest_type.invalid
        end
      end
    end
    int = int * 10 ^ decimal_shift
    if dest_type == atom.number or dest_type == atom.integer then
      if dest_type == atom.integer and frac ~= 0 then
        return atom.not_a_number
      else
        local f = int + frac / 10 ^ precision
        if negative then
          f = -f
        end
        return f
      end
    elseif dest_type == atom.fraction then
      return atom.fraction(int * 10 ^ precision + frac, 10 ^ precision)
    else
      error("Missing or invalid destination type for parsing.")
    end
  end
end
