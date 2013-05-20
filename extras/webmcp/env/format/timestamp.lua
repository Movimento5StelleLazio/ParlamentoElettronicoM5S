--[[--
text =                 -- text with the given timestamp value formatted according to the locale settings
format.timestamp(
  value,               -- a timestamp or nil
  {
    nil_as = nil_text  -- text to be returned for a nil value
  }
)

Formats a timestamp according to the locale settings.

--]]--

function format.timestamp(value, options)
  if value == nil then
    return options.nil_as or ""
  end
  return format.date(value, options) .. " " .. format.time(value, options)
end
