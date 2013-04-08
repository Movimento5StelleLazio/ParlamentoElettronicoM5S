function ui.field.timestamp(args)
  ui.form_element(args, {fetch_value = true}, function(args)
    local value = args.value
    ui.tag{
      attr = { class = "ui_field_timestamp" },
      content = function()
        ui.tag{
          attr = { class = "value" },
          content = format.timestamp(value)
        }
      end
    }
  end)
end
