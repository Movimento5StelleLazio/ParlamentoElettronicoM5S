--[[--
trace.enter_view{
  module = module, 
  view   = view
}

This function is used by execute.view and logs the call of a view.

--]]--

function trace.enter_view(args)
  if not trace._disabled then
    local module = args.module
    local view   = args.view
    if type(module) ~= "string" then
      error("No module passed to trace.enter_view{...}.")
    end
    if type(view) ~= "string" then
      error("No view passed to trace.enter_view{...}.")
    end
    trace._open_section{ type = "view", module = module, view = view }
  end
end
