--[[--
ui.field.hidden{
  ...             -- generic ui.field.* arguments, as described for ui.autofield{...}
}

This function inserts a hidden form field in the active slot. It is a high level function compared to ui.hidden_field{...}. If called inside a read-only form, then this function does nothing.

--]]--

function ui.field.hidden(args)
  ui.form_element(args, {fetch_value = true}, function(args)
    if not args.readonly then
      ui.hidden_field{
        attr  = args.attr,
        name  = args.html_name,
        value = args.value
      }
    end
  end)
end
