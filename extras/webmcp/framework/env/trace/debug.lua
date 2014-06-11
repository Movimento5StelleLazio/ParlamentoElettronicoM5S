--[[--
trace.debug(...)
  ...     -- messages to be inserted into the trace log


This function can be used to include debug output in the trace log.

--]]--

function trace.debug(...)
  if not trace._disabled then
    local message = ""
    local arg = {...}
    for i= 1,#arg,1 do
      message = message..tostring(arg[i]).." "
    end
    trace._new_entry{ type = "debug", message = message }
  end
end
