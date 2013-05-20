--[[--
slot.select(
  slot_ident,  -- name of a slot
  function()
    ...        -- code to be executed using the named slot
  end
)

This function executes code in a way that slot.put(...) and other functions write into the slot with the given name. Calls of slot.select may be nested.

--]]--

function slot.select(slot_ident, block)
  local old_slot = slot._active_slot
  slot._active_slot = slot_ident
  block()
  slot._active_slot = old_slot
end
