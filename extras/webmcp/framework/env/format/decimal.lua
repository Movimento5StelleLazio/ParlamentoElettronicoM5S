--[[--
text =                             -- text with the value formatted as decimal number
format.decimal(
  value,                           -- a number, a fraction or nil
  {
    nil_as        = nil_text,      -- text to be returned for a nil value
    digits        = digits,        -- digits before decimal point
    precision     = precision,     -- digits after decimal point
    decimal_shift = decimal_shift  -- divide the value by 10^decimal_shift (setting true uses precision)
  }
)

Formats a (floating point) number or a fraction as a decimal number. If a 'digits' option is set, the number of digits before the decimal point is increased up to the given count by preceding it with zeros. The digits after the decimal point are adjusted by the 'precision' parameter. The 'decimal_shift' parameter is useful, when fixed precision decimal numbers are stored as integers, as the given value will be divided by 10 to the power of the 'decimal_shift' value prior to formatting. Setting 'decimal_shift' to true will copy the value for 'precision'.

--]]--

function format.decimal(value, options)
  -- TODO: more features
  local options = options or {}
  local special_chars = charset.get_data().special_chars
  local f
  if value == nil then
    return options.nil_as or ""
  elseif atom.has_type(value, atom.number) then
    f = value
  elseif atom.has_type(value, atom.fraction) then
    f = value.float
  else
    error("Value passed to format.decimal(...) is neither a number nor a fraction nor nil.")
  end
  local digits = options.digits
  local precision = options.precision or 0
  local decimal_shift = options.decimal_shift or 0
  if decimal_shift == true then
    decimal_shift = precision
  end
  f = f / 10 ^ decimal_shift
  local negative
  local absolute
  if f < 0 then
    absolute = -f
    negative = true
  else
    absolute = f
    negative = false
  end
  absolute = absolute + 0.5 / 10 ^ precision
  local int = math.floor(absolute)
  if not atom.is_integer(int) then
    if f > 0 then
      return "+" .. special_chars.inf_sign
    elseif f < 0 then
      return minus_sign .. special_chars.inf_sign
    else
      return "NaN"
    end
  end
  local int_str = tostring(int)
  if digits then
    while #int_str < digits do
      int_str = "0" .. int_str
    end
  end
  if precision > 0 then
    local decimal_point =
      options.decimal_point or
      locale.get('decimal_point') or '.'
    local frac_str = tostring(math.floor((absolute - int) * 10 ^ precision))
    while #frac_str < precision do
      frac_str = "0" .. frac_str
    end
    assert(#frac_str == precision, "Assertion failed in format.float(...).")  -- should not happen
    if negative then
      return special_chars.minus_sign .. int_str .. decimal_point .. frac_str
    elseif options.show_plus then
      return "+" .. int_str .. decimal_point .. frac_str
    else
      return int_str .. decimal_point .. frac_str
    end
  else
    if negative then
      return special_chars.minus_sign .. int
    elseif options.show_plus then
      return "+" .. int_str
    else
      return int_str
    end
  end
end
