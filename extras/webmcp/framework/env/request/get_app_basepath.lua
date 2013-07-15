--[[--
path =                      -- path to directory of application with trailing slash
request.get_app_basepath()

This function returns the path to the base directory of the application. A trailing slash is always included.

--]]--

function request.get_app_basepath()
  return request._app_basepath
end
