--[[--
slot_content =
slot.use_temporary(
  function()
    ...
  end
)

This function creates a temporary slot and executes code in a way that slot.put(...) and other functions will write into the temporary slot. Afterwards the contents of the temporary slot are returned as a single string.

--]]--

function slot.use_temporary(block)
  local old_slot = slot._active_slot
  local temp_slot_reference = {}  -- just a unique reference
  slot._active_slot = temp_slot_reference
  block()
  slot._active_slot = old_slot
  local result = slot.get_content(temp_slot_reference)
  slot.reset(temp_slot_reference)
  return result
end
