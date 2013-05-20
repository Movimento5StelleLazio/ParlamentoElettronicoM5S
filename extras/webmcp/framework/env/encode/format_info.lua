--[[--
string =             -- string to be used as __format information
encode.format_info(
  format,            -- name of format function
  params             -- arguments for format function
)

The string returned by the function can be used as value in a hidden form field with a "__format" suffix. It will be used by the param.* functions to parse a string.

--]]--

function encode.format_info(format, params)
  return format .. encode.format_options(params)
end
