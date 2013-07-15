--[[--
ui.field.integer{
  ...                              -- generic ui.field.* arguments, as described for ui.autofield{...}
  format_options = format_options  -- format options for format.decimal
}

This function inserts a field for an integer in the active slot. For description of the generic field helper arguments, see help for ui.autofield{...}.

--]]--

function ui.field.integer(args)
  ui.form_element(args, {fetch_value = true}, function(args)
    local value_string = format.decimal(args.value, args.format_options)
    if args.readonly then
      ui.tag{ tag = args.tag, attr = args.attr, content = value_string }
    else
      local attr = table.new(args.attr)
      attr.type  = "text"
      attr.name  = args.html_name
      attr.value = value_string
      ui.tag{ tag  = "input", attr = attr }
      ui.hidden_field{
        name  = args.html_name .. "__format",
        value = encode.format_info("decimal", args.format_options)
      }
    end
  end)
end
