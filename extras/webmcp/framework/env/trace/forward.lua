--[[--
trace.forward{
  module = module,
  view   = view
}

This function is called automatically by request.forward{...} for logging.

--]]--

function trace.forward(args)
  if not trace._disabled then
    local module = args.module
    local view   = args.view
    if type(module) ~= "string" then
      error("No module string passed to trace.forward{...}.")
    end
    if type(view) ~= "string" then
      error("No view string passed to trace.forward{...}.")
    end
    trace._new_entry{ type = "forward", module = module, view = view }
  end
end
