--[[--
config_name =
request.get_config_name()

Returns the name of the configuration selected by the environment variable 'WEBMCP_CONFIG_NAME', or nil if the environment variable is not set.

--]]--

function request.get_config_name()
  return os.getenv("WEBMCP_CONFIG_NAME")
end