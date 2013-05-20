--[[--
text =                 -- text with the value formatted as a time, according to the locale settings
format.time(
  value,               -- a time, a timestamp or nil
  {
    nil_as = nil_text  -- text to be returned for a nil value
  }
)

Formats a time or timestamp as a time, according to the locale settings.

--]]--

function format.time(value, options)
  local options = options or {}
  if value == nil then
    return options.nil_as or ""
  end
  if not (
    atom.has_type(value, atom.time) or
    atom.has_type(value, atom.timestamp)
  ) then
    error("Value passed to format.time(...) is neither a time, a timestamp, nor nil.")
  end
  if value.invalid then
    return "invalid"
  end
  local result = locale.get("time_format") or "HH:MM{:SS}"
  if options.hide_seconds then
    result = string.gsub(result, "{[^{|}]*}", "")
  else
    result = string.gsub(result, "{([^|]*)}", "%1")
  end
  local am_pm
  local hour = value.hour
  result = string.gsub(result, "{([^{}]*)|([^{}]*)}", function(am, pm)
    if hour > 12 then
      am_pm = pm
    else
      am_pm = am
    end
    return "{|}"
  end)
  if am_pm and hour > 12 then
    hour = hour - 12
  end
  result = string.gsub(result, "HH", function()
    return format.decimal(hour, { digits = 2 })
  end)
  result = string.gsub(result, "MM", function()
    return format.decimal(value.minute, { digits = 2 })
  end)
  result = string.gsub(result, "SS", function()
    return format.decimal(value.second, { digits = 2 })
  end)
  if am_pm then
    result = string.gsub(result, "{|}", am_pm)
  end
  return result
end
