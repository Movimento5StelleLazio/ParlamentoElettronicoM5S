--[[--
values =         -- list of values casted to the chosen param_type
param.get_list(
  key,           -- name of the parameter without "[]" suffix
  param_type,    -- desired type of the returned values
)

Same as param.get(...), but used for parameters which contain a list of values. For external GET/POST parameters the parameter name gets suffixed with "[]".

--]]--

function param.get_list(key, param_type)
  local param_type = param_type or atom.string
  if param._exchanged then
    local values = param._exchanged.params[key] or {}
    if type(values) ~= "table" then
      error("Parameter has unexpected type.")
    end
    for idx, value in ipairs(values) do
      if not atom.has_type(value, param_type) then
        error("Element of parameter list has unexpected type.")
      end
    end
    return values
  else
    local format_info = cgi.params[key .. "__format"]
    local parser = param._get_parser(format_info, param_type)
    local raw_values = cgi.params[key .. "[]"]
    local values = {}
    if raw_values then
      for idx, value in ipairs(raw_values) do
        values[idx] = parser(raw_values[idx])
      end
    end
    return values
  end
end
