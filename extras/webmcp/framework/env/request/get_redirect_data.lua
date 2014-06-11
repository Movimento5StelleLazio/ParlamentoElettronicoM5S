--[[--
redirect_data =
request.get_redirect_data()

This function returns redirect information from a previous call of request.redirect{...}, or nil if no redirect was requested.

--]]--

function request.get_redirect_data()
  return request._redirect
end
