--[[--
disabled =           -- boolean indicating if trace system is disabled
trace.is_disabled()

This function returns true, if the trace system has been disabled. Otherwise false is returned.

--]]--

function trace.is_disabled()
  return trace._disabled
end
