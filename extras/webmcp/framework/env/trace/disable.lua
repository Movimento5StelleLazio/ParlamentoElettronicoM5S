--[[--
trace.disable()

This function disables the trace system. Re-enabling the trace system is not possible.

--]]--

function trace.disable()
  trace._disabled = true
end
