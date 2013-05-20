--[[--
content =
slot.get_content(
  slot_ident       -- name of the slot
)

This function returns the content of a chosen slot as a single string.

--]]--

function slot.get_content(slot_ident)
  local slot_data = slot._data[slot_ident]
  if #slot_data.string_fragments > 1 then
    local str = table.concat(slot_data.string_fragments)
    slot_data.string_fragments = { str }
    return str
  else
    return slot_data.string_fragments[1] or ""
  end
end
