--[[--
ui.field.date{
  ...           -- generic ui.field.* arguments, as described for ui.autofield{...}
}

This function inserts a field for dates in the active slot. If the JavaScript library "gregor.js" has been loaded, a rich input field is used. For description of the generic field helper arguments, see help for ui.autofield{...}.

--]]--

function ui.field.date(args)
  ui.form_element(args, {fetch_value = true}, function(args)
    local value_string = format.date(args.value, args.format_options)
    if args.readonly then
      ui.tag{ tag = args.tag, attr = args.attr, content = value_string }
    else
      local fallback_data = slot.use_temporary(function()
        local attr = table.new(args.attr)
        attr.type  = "text"
        attr.name  = args.html_name
        attr.value = value_string
        attr.class = attr.class or "ui_field_date"
        ui.tag{ tag  = "input", attr = attr }
        ui.hidden_field{
          name  = args.html_name .. "__format",
          value = encode.format_info("date", args.format_options)
        }
      end)
      local user_field_id, hidden_field_id
      local helper_data = slot.use_temporary(function()
        local attr = table.new(args.attr)
        user_field_id = attr.id or ui.create_unique_id()
        hidden_field_id = ui.create_unique_id()
        attr.id    = user_field_id
        attr.type  = "text"
        attr.class = attr.class or "ui_field_date"
        ui.tag{ tag = "input", attr = attr }
        local attr = table.new(args.attr)
        attr.id    = hidden_field_id
        attr.type  = "hidden"
        attr.name  = args.html_name
        attr.value = atom.dump(args.value)  -- extra safety for JS failure
        ui.tag{
          tag = "input",
          attr = {
            id   = hidden_field_id,
            type = "hidden",
            name = args.html_name
          }
        }
      end)
      -- TODO: localization
      ui.script{
        noscript = fallback_data,
        type     = "text/javascript",
        content  = function()
          slot.put(
            "if (gregor_addGui == null) document.write(",
            encode.json(fallback_data),
            "); else { document.write(",
            encode.json(helper_data),
            "); gregor_addGui({element_id: ",
            encode.json(user_field_id),
            ", month_names: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'], weekday_names: ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'], week_numbers: 'left', format: 'DD.MM.YYYY', selected: "
          )
          if (args.value) then
            slot.put(
              "{year: ", tostring(args.value.year),
              ", month: ", tostring(args.value.month),
              ", day: ", tostring(args.value.day),
              "}"
            )
          else
            slot.put("null")
          end
          slot.put(
           ", select_callback: function(date) { document.getElementById(",
           encode.json(hidden_field_id),
           ").value = (date == null) ? '' : date.iso_string; } } ) }"
          )
        end
      }
    end
  end)
end
