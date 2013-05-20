--[[--
ui.field.boolean{
  ...                        -- generic ui.field.* arguments, as described for ui.autofield{...}
  style       = style,       -- "radio" or "checkbox",
  nil_allowed = nil_allowed  -- set to true, if nil is allowed as third value
}

This function inserts a field for boolean values in the active slot. For description of the generic field helper arguments, see help for ui.autofield{...}.

--]]--

function ui.field.boolean(args)
  local style = args.style
  if not style then
    if args.nil_allowed then
      style = "radio"
    else
      style = "checkbox"
    end
  end
  local extra_args = { fetch_value = true }
  if not args.readonly and args.style == "radio" then
    extra_args.disable_label_for_id = true
  end
  ui.form_element(args, extra_args, function(args)
    local value = args.value
    if value ~= true and value ~= false and value ~= nil then
      error("Boolean value must be true, false or nil.")
    end
    if value == nil then
      if args.nil_allowed then
        value = args.default
      else
        value = args.default or false
      end
    end
    if args.readonly then
      ui.tag{
        tag     = args.tag,
        attr    = args.attr,
        content = format.boolean(value, args.format_options)
      }
    elseif style == "radio" then
      local attr = table.new(args.attr)
      attr.type  = "radio"
      attr.name  = args.html_name
      attr.id    = ui.create_unique_id()
      attr.value = "1"
      if value == true then
        attr.checked = "checked"
      else
        attr.checked = nil
      end
      ui.container{
        attr          = { class = "ui_radio_div" },
        label         = args.true_as or "Yes",  -- TODO: localize
        label_for     = attr.id,
        label_attr    = { class = "ui_radio_label" },
        content_first = true,
        content       = function()
          ui.tag{ tag  = "input", attr = attr }
        end
      }
      attr.id    = ui.create_unique_id()
      attr.value = "0"
      if value == false then
        attr.checked = "1"
      else
        attr.checked = nil
      end
      ui.container{
        attr          = { class = "ui_radio_div" },
        label         = args.false_as or "No",  -- TODO: localize
        label_for     = attr.id,
        label_attr    = { class = "ui_radio_label" },
        content_first = true,
        content       = function()
          ui.tag{ tag  = "input", attr = attr }
        end
      }
      if args.nil_allowed then
        attr.id    = ui.create_unique_id()
        attr.value = ""
        if value == nil then
          attr.checked = "1"
        else
          attr.checked = nil
        end
        ui.container{
          attr          = { class = "ui_radio_div" },
          label         = args.nil_as or "N/A",  -- TODO: localize
          label_for     = attr.id,
          label_attr    = { class = "ui_radio_label" },
          content_first = true,
          content       = function()
            ui.tag{ tag  = "input", attr = attr }
          end
        }
      end
      ui.hidden_field{
        name = args.html_name .. "__format", value = "boolean"
      }
    elseif style == "checkbox" then
      if args.nil_allowed then
        error("Checkboxes do not support nil values.")
      end
      local attr = table.new(args.attr)
      attr.type  = "checkbox"
      attr.name  = args.html_name
      attr.value = "1"
      if value then
        attr.checked = "checked"
      else
        attr.checked = nil
      end
      ui.tag{ tag = "input", attr = attr }
      ui.hidden_field{
        name = args.html_name .. "__format",
        value = encode.format_info(
          "boolean",
          { true_as = "1", false_as = "" }
        )
      }
    else
      error("'style' attribute for ui.field.boolean{...} must be set to \"radio\", \"checkbox\" or nil.")
    end
  end)
end
