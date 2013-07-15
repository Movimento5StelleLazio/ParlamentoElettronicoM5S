--[[--
content_type =           -- content-type as selected with slot.set_layout(...)
slot.get_content_type()

This function returns the content-type to be sent to the browser. It may be changed by calling slot.set_layout(...). The default content-type is "text/html; charset=UTF-8".

--]]--

function slot.get_content_type()
  return slot._content_type or 'text/html; charset=UTF-8'
end
