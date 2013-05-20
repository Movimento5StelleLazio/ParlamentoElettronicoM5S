local function map_2digit_year(y2)
  local current_year = atom.date:get_current().year
  local guess2 = math.floor(current_year / 100) * 100 + tonumber(y2)
  local guess1 = guess2 - 100
  local guess3 = guess2 + 100
  if guess1 >= current_year - 80 and guess1 <= current_year + 10 then
    return guess1
  elseif guess2 >= current_year - 80 and guess2 <= current_year + 10 then
    return guess2
  elseif guess3 >= current_year - 80 and guess3 <= current_year + 10 then
    return guess3
  end
end

function parse.date(str, dest_type, options)
  if dest_type ~= atom.date then
    error("parse.date(...) can only return dates, but a different destination type than atom.date was given.")
  end
  local date_format = locale.get("date_format")
  if date_format and string.find(date_format, "Y+%-D+%-M+") then
    error("Date format collision with ISO standard.")
  end
  if string.match(str, "^%s*$") then
    return nil
  end
  -- first try ISO format
  local year, month, day = string.match(
    str, "^%s*([0-9][0-9][0-9][0-9])%-([0-9][0-9])%-([0-9][0-9])%s*$"
  )
  if year then
    return atom.date{
      year = tonumber(year),
      month = tonumber(month),
      day = tonumber(day)
    }
  end
  if not date_format then
    return atom.date.invalid
  end
  local format_parts = {}
  local numeric_parts = {}
  for part in string.gmatch(date_format, "[YMD]+") do
    format_parts[#format_parts+1] = part
  end
  for part in string.gmatch(str, "[0-9]+") do
    numeric_parts[#numeric_parts+1] = part
  end
  if #format_parts ~= #numeric_parts then
    return atom.date.invalid
  end
  local year, month, day
  local function process_part(format_part, numeric_part)
    if string.find(format_part, "^Y+$") then
      if #numeric_part == 4 then
        year = tonumber(numeric_part)
      elseif #numeric_part == 2 then
        year = map_2digit_year(numeric_part)
      else
        return atom.date.invalid
      end
    elseif string.find(format_part, "^M+$") then
      month = tonumber(numeric_part)
    elseif string.find(format_part, "^D+$") then
      day = tonumber(numeric_part)
    else
      if not #format_part == #numeric_part then
        return atom.date.invalid
      end
      local year_str  = ""
      local month_str = ""
      local day_str   = ""
      for i = 1, #format_part do
        local format_char = string.sub(format_part, i, i)
        local number_char = string.sub(numeric_part, i, i)
        if format_char == "Y" then
          year_str = year_str .. number_char
        elseif format_char == "M" then
          month_str = month_str .. number_char
        elseif format_char == "D" then
          day_str = day_str .. number_char
        else
          error("Assertion failed.")
        end
      end
      if #year_str == 2 then
        year = map_2digit_year(year_str)
      else
        year = tonumber(year_str)
      end
      month = tonumber(month_str)
      day = tonumber(day_str)
    end
  end
  for i = 1, #format_parts do
    process_part(format_parts[i], numeric_parts[i])
  end
  if not year or not month or not day then
    error("Date parser did not determine year, month and day. Maybe the 'date_format' locale is erroneous?")
  end
  return atom.date{ year = year, month = month, day = day }
end
