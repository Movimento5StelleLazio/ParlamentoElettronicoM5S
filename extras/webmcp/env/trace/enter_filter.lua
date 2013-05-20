--[[--
trace.enter_filter{
  path = path
}

This function logs the call of a filter, when using execute.filtered_view{...} and execute.filtered_action{...}.

--]]--

function trace.enter_filter(args)
  if not trace._disabled then
    local path = args.path
    if type(path) ~= "string" then
      error("No path string passed to trace.enter_filter{...}.")
    end
    trace._open_section{ type = "filter", path = path }
  end
end
