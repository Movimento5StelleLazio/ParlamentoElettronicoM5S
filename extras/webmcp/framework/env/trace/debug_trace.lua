--[[--
trace.debug_trace(
  message     -- optional message to add
)

This function includes a traceback into the debugging log

--]]--

function trace.debug_trace(message)
  trace._new_entry{ type = "traceback", message = tostring(debug.traceback(message or "", 2)) }
end
