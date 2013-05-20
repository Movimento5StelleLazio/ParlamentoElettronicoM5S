--[[--
state_table =           -- table for saving a slot's state
slot.get_state_table()

This function returns a table, holding state information of the currently active slot. To change the state information the returned table may be modified.

--]]--

function slot.get_state_table()
  return slot.get_state_table_of(slot._active_slot)
end
