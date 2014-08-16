--[[--
ui.field.boolean{
  ...                        -- generic ui.field.* arguments, as described for ui.autofield{...}
  style       = style,       -- "radio" or "checkbox",
  nil_allowed = nil_allowed  -- set to true, if nil is allowed as third value
}

This function inserts a field for boolean values in the active slot. For description of the generic field helper arguments, see help for ui.autofield{...}.

--]] --

function ui.field.parelon_radio(args)
    local style = "radio"
    local extra_args = { fetch_value = true }
    if not args.readonly and args.style == "radio" then
        extra_args.disable_label_for_id = true
    end
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
    local attr = table.new(args.attr)
    attr.type = "radio"
    attr.name = args.name
    attr.id = ui.create_unique_id()
    local label_attr = table.new(args.label_attr)
    label_attr["for"] = tostring(attr.id)
    if value == true then
        attr.checked = "checked"
    else
        attr.checked = nil
    end
    ui.container {
        label_attr = args.label_attr,
        content = function()
            ui.tag { tag = "input", attr = attr }
            ui.tag { tag = "label", attr = label_attr, content = args.label }
        end
    }
    --[[      ui.hidden_field{
            name = args.html_name .. "__format", value = "boolean"
          }]]
end
