--[[--
trace.enter_config{
  name = name 
}

This function is used by execute.config and logs the inclusion of a configuration.

--]]--

function trace.enter_config(args)
  if not trace._disabled then
    local name = args.name
    if type(name) ~= "string" then
      error("No name string passed to trace.enter_config{...}.")
    end
    trace._open_section{ type = "config", name = name }
  end
end
