--[[--
params =
param.get_param_strings()

This function returns a table with all raw GET/POST parameters as strings or list of strings (except internal parameters like "_webmcp_path" or "_webmcp_id"). Modifications of the returned table have no side effects.

--]]--

function request.get_param_strings()
  local t = {}
  for key, value in pairs(request._params) do
    if type(value) == 'table' then
      t[key] = table.new(value)
    else
      t[key] = value
    end
  end
  return t
end
