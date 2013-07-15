--[[--
ui.field.text{
  ...                              -- generic ui.field.* arguments, as described for ui.autofield{...}
  format_options = format_options  -- format options for format.string
}

This function inserts a field for a text in the active slot. For description of the generic field helper arguments, see help for ui.autofield{...}.

--]]--

function ui.field.text(args)
  ui.form_element(args, {fetch_value = true}, function(args)
    local value_string = format.string(args.value, args.format_options)
    if args.readonly then
      ui.tag{ tag = args.tag, attr = args.attr, content = value_string }
    else
      local attr = table.new(args.attr)
      attr.name  = args.html_name
      if args.multiline then
        ui.tag { tag = "textarea", attr = attr, content = value_string }
      else
        attr.type  = "text"
        attr.value = value_string
        ui.tag{ tag  = "input", attr = attr }
      end
    end
  end)
end
