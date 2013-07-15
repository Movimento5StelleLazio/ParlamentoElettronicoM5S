--[[--
request.forward{
  module = module,  -- module name
  view   = view     -- view name
}

This function is called automatically to forward to another view, after an action and all its filters have finished execution, if routing mode "forward" has been chosen. Calling request.forward{...} (or request.redirect{...}) explicitly inside an action will cause routing information from the browser to be ignored. Calling request.forward{...} causes all GET/POST parameters of the action to be preserved for the given view.

--]]--

function request.forward(args)
  if request.is_rerouted() then
    error("Tried to forward after another forward or redirect.")
  end
  request._forward = args
  trace.forward { module = args.module, view = args.view }
end
