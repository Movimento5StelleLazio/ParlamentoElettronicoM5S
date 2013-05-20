--[[--
text =                 -- text with the value formatted as a date, according to the locale settings
format.date(
  value,               -- a date, a timestamp or nil
  {
    nil_as = nil_text  -- text to be returned for a nil value
  }
)

Formats a date or timestamp as a date, according to the locale settings.

--]]--

function format.date(value, options)
  local options = options or {}
  if value == nil then
    return options.nil_as or ""
  end
  if not (
    atom.has_type(value, atom.date) or
    atom.has_type(value, atom.timestamp)
  ) then
    error("Value passed to format.date(...) is neither a date, a timestamp, nor nil.")
  end
  if value.invalid then
    return "invalid"
  end
  local result = locale.get("date_format") or "YYYY-MM-DD"
  result = string.gsub(result, "YYYY", function()
    return format.decimal(value.year, { digits = 4 })
  end)
  result = string.gsub(result, "YY", function()
    return format.decimal(value.year % 100, { digits = 2 })
  end)
  result = string.gsub(result, "Y", function()
    return format.decimal(value.year)
  end)
  result = string.gsub(result, "MM", function()
    return format.decimal(value.month, { digits = 2 })
  end)
  result = string.gsub(result, "M", function()
    return format.decimal(value.month)
  end)
  result = string.gsub(result, "DD", function()
    return format.decimal(value.day, { digits = 2 })
  end)
  result = string.gsub(result, "D", function()
    return format.decimal(value.day)
  end)
  return result
end
