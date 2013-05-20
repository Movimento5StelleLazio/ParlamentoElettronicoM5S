--[[--
ui.submit{
  name  = name,   -- optional HTML name
  value = value,  -- HTML value
  text  = value   -- text on button
}

This function places a HTML form submit button in the active slot. Currently the text displayed on the button and the value attribute are the same, so specifying both a 'value' and a 'text' makes no sense.

--]]--

function ui.submit(args)
  if slot.get_state_table().form_readonly == false then
    local args = args or {}
    local attr = table.new(attr)
    attr.type  = "submit"
    attr.name  = args.name
    attr.value = args.value or args.text
    return ui.tag{ tag  = "input", attr = attr }
  end
end
