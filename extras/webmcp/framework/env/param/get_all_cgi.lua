--[[--
params =
param.get_all_cgi()

Deprecated. Alias for request.get_param_strings().

--]]--

-- TODO: Remove this function.

function param.get_all_cgi()
  return request.get_param_strings()
end
