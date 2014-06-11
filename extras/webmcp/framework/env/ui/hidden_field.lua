--[[--
ui.hidden_field{
  name = name,    -- HTML name
  value = value,  -- value
  attr  = attr    -- extra HTML attributes
}

This function inserts a hidden form field in the active slot. It is a low level function compared to ui.field.hidden{...}.

--]]--

function ui.hidden_field(args)
  local args = args or {}
  local attr = table.new(args.attr)
  attr.type  = "hidden"
  attr.name  = args.name
  attr.value = atom.dump(args.value)
  return ui.tag{ tag  = "input", attr = attr }
end
