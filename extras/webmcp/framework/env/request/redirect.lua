--[[--
request.redirect{
  module = module,  -- module name
  view   = view,    -- view name
  id     = id,      -- optional id for view
  params = params   -- optional view parameters
}

Calling this function causes the WebMCP to do a 303 HTTP redirect after the current view or action and all filters have finished execution. If routing mode "redirect" has been chosen, then this function is called automatically after an action and all its filters have finished execution. Calling request.redirect{...} (or request.forward{...}) explicitly inside an action will cause routing information from the browser to be ignored. To preserve GET/POST parameters of an action, use request.forward{...} instead. Currently no redirects to external (absolute) URLs are possible, there will be an implementation in future though.

--]]--

function request.redirect(args)
  -- TODO: support redirects to external URLs too
  --       (needs fixes in the trace system as well)
  local module = args.module
  local view   = args.view
  local id     = args.id
  local params = args.params or {}
  if type(module) ~= "string" then
    error("No module string passed to request.redirect{...}.")
  end
  if type(view) ~= "string" then
    error("No view string passed to request.redirect{...}.")
  end
  if type(params) ~= "table" then
    error("Params array passed to request.redirect{...} is not a table.")
  end
  if request.is_rerouted() then
    error("Tried to redirect after another forward or redirect.")
  end
  request._redirect = {
    module = module,
    view   = view,
    id     = id,
    params = params
  }
  trace.redirect{ module = args.module, view = args.view }
end
