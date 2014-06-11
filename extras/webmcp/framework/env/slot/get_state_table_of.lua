--[[--
state_table =             -- table for saving the slot's state
slot.get_state_table_of(
  slot_ident              -- name of a slot
)

This function returns a table, holding state information of the named slot. To change the state information the returned table may be modified.

--]]--

function slot.get_state_table_of(slot_ident)
  return slot._data[slot_ident].state_table
end
