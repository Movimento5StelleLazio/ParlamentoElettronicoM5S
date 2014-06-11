--[[--
trace.enter_action{
  module = module, 
  action = action
}

This function is used by execute.action and logs the call of an action.

--]]--

function trace.enter_action(args)
  if not trace._disabled then
    local module = args.module
    local action = args.action
    if type(module) ~= "string" then
      error("No module string passed to trace.enter_action{...}.")
    end
    if type(action) ~= "string" then
      error("No action string passed to trace.enter_action{...}.")
    end
    trace._open_section{ type = "action", module = module, action = action }
  end
end
