--[[--
value =             -- id as string (or other type after if params.exchange(...) has been used), or nil
param.get_id_cgi()

Deprecated. Alias for request.get_id_string().

--]]--

-- TODO: Remove this function.

function param.get_id_cgi()
  return request.get_id_string()
end
