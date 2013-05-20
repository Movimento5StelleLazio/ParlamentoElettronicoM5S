--[[--
request.set_404_route{
  module = module,  -- module name
  view   = view     -- view name
}

In case a view or action is not found, the given module and view will be used to display an error page.

--]]--

function request.set_404_route(tbl)
  request._404_route = tbl
end
