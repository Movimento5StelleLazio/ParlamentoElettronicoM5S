--[[--
execute.config(
  name           -- name of the configuration to be loaded
)

Executes a configuration file of the application.
This function is only used by by the webmcp.lua file in the cgi-bin/ directory.

--]]--

function execute.config(name)
  trace.enter_config{ name = name }
  execute.file_path{
    file_path = encode.file_path(
      request.get_app_basepath(), 'config', name .. '.lua'
    )
  }
  trace.execution_return()
end
