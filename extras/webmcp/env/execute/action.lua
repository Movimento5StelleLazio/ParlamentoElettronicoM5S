--[[--
action_status =     -- status code returned by the action (a string)
execute.action{
  module = module,  -- module name of the action to be executed
  action = action,  -- name of the action to be executed
  id     = id,      -- id to be returned by param.get_id(...) during execution
  params = params   -- parameters to be returned by param.get(...) during execution
}

Executes an action without associated filters.
This function is only used by execute.filtered_action{...}, which itself is only used by the webmcp.lua file in the cgi-bin/ directory.

--]]--

function execute.action(args)
  local module = args.module
  local action = args.action
  trace.enter_action{ module = module, action = action }
  local action_status = execute.file_path{
    file_path = encode.file_path(
      request.get_app_basepath(),
      'app', request.get_app_name(), module, '_action', action .. '.lua'
    ),
    id     = args.id,
    params = args.params
  }
  trace.execution_return{ status = action_status }
  return action_status
end
