--[[--
status_string =
request.get_status()

Returns a HTTP status previously set with request.set_status(...).

--]]--

function request.get_status()
  return request._status
end
