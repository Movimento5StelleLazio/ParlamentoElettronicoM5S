--[[--
baseurl =
request.get_absolute_baseurl()

This function returns the absolute base URL of the application, as set by request.set_absolute_baseurl(...).

--]]--

function request.get_absolute_baseurl()
  if request._absolute_baseurl then
    return request._absolute_baseurl
  else
    error("Absolute base URL is unknown. It should be set in the configuration by calling request.set_absolute_baseurl(...).")
  end
end
