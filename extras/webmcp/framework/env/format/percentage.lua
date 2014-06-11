--[[--
text =                             -- text with the value formatted as a percentage
format.percentage(
  value,                           -- a number, a fraction or nil
  {
    nil_as        = nil_text       -- text to be returned for a nil value
    digits        = digits,        -- digits before decimal point (of the percentage value)
    precision     = precision,     -- digits after decimal point (of the percentage value)
    decimal_shift = decimal_shift  -- divide the value by 10^decimal_shift (setting true uses precision + 2)
  }
)

Formats a number or fraction as a percentage.

--]]--

function format.percentage(value, options)
  local options = table.new(options)
  local f
  if value == nil then
    return options.nil_as or ""
  elseif atom.has_type(value, atom.number) then
    f = value
  elseif atom.has_type(value, atom.fraction) then
    f = value.float
  else
    error("Value passed to format.percentage(...) is neither a number nor a fraction nor nil.")
  end
  options.precision = options.precision or 0
  if options.decimal_shift == true then
    options.decimal_shift = options.precision + 2
  end
  local suffix = options.hide_unit and "" or " %"
  return format.decimal(f * 100, options) .. suffix
end
