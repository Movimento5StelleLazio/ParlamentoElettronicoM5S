--[[--
value =       -- value of the parameter casted to the chosen param_type
param.get(
  key,        -- name of the parameter
  param_type  -- desired type of the returned value
)

Either a GET or POST request parameter is returned by this function, or if param.exchange(...) was called before, one of the exchanged parameters is returned. You can specify which type the returned value shall have. If an external request parameter was used and there is another GET or POST parameter with the same name but a "__format" suffix, the parser with the name of the specified format will be automatically used to parse and convert the input value.

--]]--

function param.get(key, param_type)
  local param_type = param_type or atom.string
  if param._exchanged then
    local value = param._exchanged.params[key]
    if value ~= nil and not atom.has_type(value, param_type) then
      error("Parameter has unexpected type.")
    end
    return value
  else
    local str         = cgi.params[key]
    local format_info = cgi.params[key .. "__format"]
    if not str then
      if not format_info then
        return nil
      end
      str = ""
    end
    return param._get_parser(format_info, param_type)(str)
  end
end
