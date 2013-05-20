--[[--
slot.set_layout(
  layout_ident,   -- name of layout or nil for binary data in slot named "data"
  content_type    -- content-type to be sent to the browser, or nil for default
)

This function selects which layout should be used when calling slot.render_layout(). If no layout is selected by passing nil as first argument, then no layout will be used, and the slot named "data" is used plainly. The second argument to slot.set_layout is the content-type which is sent to the browser.

--]]--

function slot.set_layout(layout_ident, content_type)
  slot._current_layout = layout_ident
  slot._content_type = content_type
end
