--[[--
text =                 -- a string
format.string(
  value,               -- any value where tostring(value) gives a reasonable result
  {
    nil_as = nil_text  -- text to be returned for a nil value
  }
)

Formats a value as a text by calling tostring(...), unless the value is nil, in which case the text returned is chosen by the 'nil_as' option.

--]]--

function format.string(str, options)
  local options = options or {}
  if str == nil then
    return options.nil_as or ""
  else
    return tostring(str)
  end
end
