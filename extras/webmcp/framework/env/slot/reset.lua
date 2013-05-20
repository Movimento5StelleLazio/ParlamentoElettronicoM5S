--[[--
slot.reset(
  slot_ident  -- name of a slot to be emptied
)

Calling this function reset the named slot to be empty.

--]]--

function slot.reset(slot_ident)
  slot._data[slot_ident] = nil
end
