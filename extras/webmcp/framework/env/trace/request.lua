--[[--
trace.request{
  module = module,
  view   = view,
  action = action
}

This function is called automatically to log which view or action has been requested by the web browser.

--]]--

function trace.request(args)
  if not trace._disabled then
    local module       = args.module
    local view         = args.view
    local action       = args.action
    if type(module) ~= "string" then
      error("No module string passed to trace.request{...}.")
    end
    if view and action then
      error("Both view and action passed to trace.request{...}.")
    end
    if not (view or action) then
      error("Neither view nor action passed to trace.request{...}.")
    end
    if view and type(view) ~= "string" then
      error("No view string passed to trace.request{...}.")
    end
    if action and type(action) ~= "string" then
      error("No action string passed to trace.request{...}.")
    end
    trace._new_entry{
      type = "request",
      module       = args.module,
      view         = args.view,
      action       = args.action
    }
  end
end
