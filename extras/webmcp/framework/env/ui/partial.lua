--[[--
ui.partial{
  module  = module,     -- module to be used to reload inner contents
  view    = view,       -- view   to be used to reload inner contents
  id      = id,         -- id     to be used to reload inner contents
  params  = params,     -- params to be used to reload inner contents
  target  = target,     -- id of HTML element containing contents to be replaced
  content = function()
    ...
  end
}

Calling this function declares that the inner contents can be requested
directly via the given module, view, id and params. The parameter "target"
specifies the id of the HTML element, which should be replaced when
reloading partially.

The function has an effect on inner calls of ui.link{..., partial = {...}}
and ui.form{..., partial = {...}}.

--]]--

function ui.partial(args)
  local old_state = ui._partial_state
  ui._partial_state = table.new(args)
  ui._partial_state.param_name_hash = {}
  if args.param_names then
    ui.add_partial_param_names(args.param_names)
  end
  args.content()
  ui._partial_state = old_state
end
