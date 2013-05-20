--[[--
request.force_absolute_baseurl()

Calling this function causes subsequent calls of request.get_relative_baseurl() to return absolute URLs instead.

--]]--

function request.force_absolute_baseurl()
  request._force_absolute_baseurl = true
end
