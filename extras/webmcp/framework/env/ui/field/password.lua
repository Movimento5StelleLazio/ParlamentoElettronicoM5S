--[[--
ui.field.password{
  ...                        -- generic ui.field.* arguments, as described for ui.autofield{...}
}

This function inserts a field for a password in the active slot. For read-only forms this function does nothing. For description of the generic field helper arguments, see help for ui.autofield{...}.

--]]--

function ui.field.password(args)
  ui.form_element(args, {fetch_value = true}, function(args)
    local value_string = atom.dump(args.value)
    if args.readonly then
      -- nothing
    else
      local attr = table.new(args.attr)
      attr.type  = "password"
      attr.name  = args.html_name
      attr.value = value_string
      ui.tag{ tag  = "input", attr = attr }
    end
  end)
end
