function ui_deprecated.select(args)
  local record = assert(slot.get_state_table(), "ui_deprecated.select was not called within a form.").form_record
  local value = param.get(args.field) or record[args.field]
  local html_options = args.html_options or {}
  html_options.name = args.field
  
  ui_deprecated.tag("div", { html_options = { class="ui_field ui_select" }, content = function()
    if args.label then
      ui_deprecated.tag("div", { html_options = { class="label" }, content = function()
        ui_deprecated.text(args.label)
      end })
    end
    ui_deprecated.tag("div", { html_options = { class="value" }, content = function()
      ui_deprecated.tag("select", { html_options = html_options, content = function()
        if args.include_option then
          ui_deprecated.tag("option", { html_options = { value = "" }, content = args.include_option })
        end
        for i, object in ipairs(args.foreign_records) do
          local selected = nil
          if tostring(object[args.foreign_id]) == tostring(value) then
            selected = "1"
          end
          ui_deprecated.tag("option", { html_options = { value = object[args.foreign_id], selected = selected }, content = object[args.foreign_name] })
        end
      end }) -- /select
    end }) -- /div
  end }) -- /div
end



