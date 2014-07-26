--[[--
ui.field.boolean{
  ...                        -- generic ui.field.* arguments, as described for ui.autofield{...}
  style       = style,       -- "radio" or "checkbox",
  nil_allowed = nil_allowed  -- set to true, if nil is allowed as third value
}

This function inserts a field for boolean values in the active slot. For description of the generic field helper arguments, see help for ui.autofield{...}.

--]]--

function ui.field.parelon_radio(args)
  local style = "radio"
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
        label         = args.true_as or "",  -- TODO: localize
        label_for     = attr.id,
        label_attr    = { class = "ui_radio_label" },
        content_first = false,
        content       = function()
          ui.tag{ tag  = "input", attr = attr }
        end
      }
      ui.hidden_field{
        name = args.html_name .. "__format", value = "boolean"
      }
    end
  end)
end
