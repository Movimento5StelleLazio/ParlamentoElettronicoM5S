--[[--
trace.debug_table(
  message     -- message to be inserted into the trace log
)

This function can be used to include debug output in the trace log.

--]]--

function trace.debug_table(table)
  trace._new_entry{ type = "debug_table", message = table }
end
