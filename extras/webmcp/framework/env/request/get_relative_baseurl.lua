--[[--
baseurl =
request.get_relative_baseurl()

This function returns a relative base URL of the application. If request.force_absolute_baseurl() has been called before, an absolute URL is returned.

--]]--

function request.get_relative_baseurl()
  if request._force_absolute_baseurl then
    return (request.get_absolute_baseurl())
  else
    return request._relative_baseurl
  end
end
