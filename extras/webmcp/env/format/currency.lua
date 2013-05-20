--[[--
text =
format.currency(
  value,
  {
    nil_as                 = nil_text,                -- text to be returned for a nil value
    digits                 = digits,                  -- number of digits before the decimal point
    currency_precision     = currency_precision,      -- number of digits after decimal point
    currency_prefix        = currency_prefix,         -- prefix string, i.e. "$ "
    currency_decimal_point = currency_decimal_point,  -- string to be used as decimal point
    currency_suffix        = currency_suffix,         -- suffix string, i.e. " EUR"
    hide_unit              = hide_unit,               -- hide the currency unit, if true
    decimal_point          = decimal_point            -- used instead of 'currency_decimal_point', if 'hide_unit' is true
  }
)

Formats a (floating point) number or a fraction as a decimal number. If a 'digits' option is set, the number of digits before the decimal point is increased up to the given count by preceding it with zeros. The digits after the decimal point are adjusted by the 'precision' parameter. The 'decimal_shift' parameter is useful, when fixed precision decimal numbers are stored as integers, as the given value will be divided by 10 to the power of the 'decimal_shift' value prior to formatting. Setting 'decimal_shift' to true will use the 'precision' value as 'decimal_shift'.

--]]--

function format.currency(value, options)
  local options = table.new(options)
  local prefix
  local suffix
  if options.hide_unit then
    prefix = ""
    suffix = ""
    options.decimal_point =
      options.decimal_point or locale.get("decimal_point")
    options.precision =
      options.currency_precision or locale.get("currency_precision") or 2
  elseif
    options.currency_prefix or options.currency_suffix or
    options.currency_precision or options.currency_decimal_point
  then
    prefix                = options.currency_prefix or ''
    suffix                = options.currency_suffix or ''
    options.decimal_point = options.currency_decimal_point
    options.precision     = options.currency_precision or 2
  else
    prefix                = locale.get("currency_prefix") or ''
    suffix                = locale.get("currency_suffix") or ''
    options.decimal_point = locale.get("currency_decimal_point")
    options.precision     = locale.get("currency_precision") or 2
  end
  if value == nil then
    return options.nil_as or ''
  end
  return prefix .. format.decimal(value, options) .. suffix
end
