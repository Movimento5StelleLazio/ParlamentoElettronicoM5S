--[[--
id_string =
request.get_id_string()

Returns the requested id for a view as a string (unprocessed). Use param.get_id(...) to get a processed version.

--]]--

function request.get_id_string()
  return request._id
end
