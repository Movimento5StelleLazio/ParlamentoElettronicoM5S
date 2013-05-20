--[[--
action_status =     -- status code returned by the action (a string)
execute.filtered_action{
  module = module,  -- module name of the action to be executed
  action = action,  -- name of the action to be executed
  id     = id,      -- id to be returned by param.get_id(...) during execution
  params = params   -- parameters to be returned by param.get(...) during execution
}

Executes an action with associated filters.
This function is only used by by the webmcp.lua file in the cgi-bin/ directory.

--]]--

function execute.filtered_action(args)
  local filters = {}
  local function add_by_path(...)
    execute._add_filters_by_path(filters, ...)
  end
  add_by_path("_filter")
  add_by_path("_filter_action")
  add_by_path(request.get_app_name(), "_filter")
  add_by_path(request.get_app_name(), "_filter_action")
  add_by_path(request.get_app_name(), args.module, "_filter")
  add_by_path(request.get_app_name(), args.module, "_filter_action")
  table.sort(filters)
  for idx, filter_name in ipairs(filters) do
    filters[idx] = filters[filter_name]
    filters[filter_name] = nil
  end
  local result
  execute.multi_wrapped(
    filters,
    function()
      result = execute.action(args)
    end
  )
  return result
end
