--[[--
route_info =             -- table with 'module' and 'view' field
request.get_404_route()

Returns the data passed to a previous call of request.set_404_route{...}, or nil.

--]]--

function request.get_404_route()
  return request._404_route
end
