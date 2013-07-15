--[[--
execute.filtered_view{
  module = module,  -- module name of the view to be executed
  view   = view     -- name of the view to be executed
}

Executes a view with associated filters.
This function is only used by by the webmcp.lua file in the cgi-bin/ directory.

--]]--

function execute.filtered_view(args)
  local filters = {}
  local function add_by_path(...)
    execute._add_filters_by_path(filters, ...)
  end
  add_by_path("_filter")
  add_by_path("_filter_view")
  add_by_path(request.get_app_name(), "_filter")
  add_by_path(request.get_app_name(), "_filter_view")
  add_by_path(request.get_app_name(), args.module, "_filter")
  add_by_path(request.get_app_name(), args.module, "_filter_view")
  table.sort(filters)
  for idx, filter_name in ipairs(filters) do
    filters[idx] = filters[filter_name]
    filters[filter_name] = nil
  end
  execute.multi_wrapped(
    filters,
    function()
      execute.view(args)
    end
  )
end
