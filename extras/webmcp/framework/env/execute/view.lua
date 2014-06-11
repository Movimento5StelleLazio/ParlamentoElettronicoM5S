--[[--
execute.view{
  module = module,  -- module name of the view to be executed
  view   = view,    -- name of the view to be executed
  id     = id,      -- id to be returned by param.get_id(...) during execution
  params = params   -- parameters to be returned by param.get(...) during execution
}

Executes a view directly (without associated filters).

--]]--

function execute.view(args)
  local module = args.module
  local view = args.view
  trace.enter_view{ module = module, view = view }
  execute.file_path{
    file_path = encode.file_path(
      request.get_app_basepath(),
      'app', request.get_app_name(), module, view .. '.lua'
    ),
    id     = args.id,
    params = args.params
  }
  trace.execution_return()
end
