--[[--
trace.error{
}

This function is called automatically in case of errors to log them.

--]]--

function trace.error(args)
  if not trace._disabled then
    trace._new_entry { type = "error" }
    local closed_section = trace._close_section()
    closed_section.hard_error = true  -- TODO: not used, maybe remove
    trace._stack = { trace._tree }
  end
end
