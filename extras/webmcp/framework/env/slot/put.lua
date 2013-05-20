--[[--
slot.put(
  string1,  -- string to be written into the active slot
  string2,  -- another string to be written into the active slot
  ...
)

This function is used to write strings into the active slot.

-- NOTE: ACCELERATED FUNCTION
-- Do not change unless also you also update webmcp_accelerator.c

--]]--

function slot.put(...)
  return slot.put_into(slot._active_slot, ...)
end