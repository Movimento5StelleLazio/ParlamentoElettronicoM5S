--[[--
app_name =
request.get_app_name()

Returns the application name set by the environment variable 'WEBMCP_APP_NAME', or "main" as default application name, if the environment variable is unset.

--]]--

function request.get_app_name()
  return os.getenv("WEBMCP_APP_NAME") or 'main'
end
