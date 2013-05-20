--[[--
slot.put_into(
  slot_ident  -- name of a slot
  string1,    -- string to be written into the named slot
  string2,    -- another string to be written into the named slot
  ...
)

This function is used to write strings into a named slot.

-- NOTE: ACCELERATED FUNCTION
-- Do not change unless also you also update webmcp_accelerator.c

--]]--

function slot.put_into(slot_ident, ...)
  local t = slot._data[slot_ident].string_fragments
  for i = 1, math.huge do
    local v = select(i, ...)
    if v == nil then break end
    t[#t + 1] = v
  end
end