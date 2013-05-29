--[[--
trace.execution_return{
  status = status        -- optional status
}

This function is called automatically when returning from a view, action, configuration or filter for logging purposes.

--]]--

function trace.execution_return(args)
  if not trace._disabled then
    local status
    if args then
      status = args.status
    end
    if status and type(status) ~= "string" then
      error("Status passed to trace.execution_return{...} is not a string.")
    end
    local closed_section = trace._close_section()
    closed_section.status = status
  end
end
