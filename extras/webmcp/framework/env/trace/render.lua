--[[--
trace.render()

This function renders a trace log and writes it into the active slot.

--]]--

function trace.render()
  if not trace._disabled then
    -- TODO: check if all sections are closed?
    trace._render_sub_tree(trace._tree)
  end
end
