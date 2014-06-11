--[[--
trace.redirect{
  module = module,
  view   = view
}

This function is called automatically by request.redirect{...} for logging.

--]]--

function trace.redirect(args)
  if not trace._disabled then
    local module = args.module
    local view   = args.view
    if type(module) ~= "string" then
      error("No module string passed to trace.redirect{...}.")
    end
    if type(view) ~= "string" then
      error("No view string passed to trace.redirect{...}.")
    end
    trace._new_entry{ type = "redirect", module = module, view = view }
  end
end
