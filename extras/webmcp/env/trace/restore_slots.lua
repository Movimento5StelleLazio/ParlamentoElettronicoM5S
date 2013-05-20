--[[--
trace.restore_slots{
}

This function is used to log the event of restoring previously stored slot contents.

--]]--

function trace.restore_slots(args)
  if not trace._disabled then
    trace._new_entry{ type = "restore_slots" }
  end
end
