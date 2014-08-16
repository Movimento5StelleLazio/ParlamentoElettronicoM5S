function ui.field.parelon_group_radio(args)
    ui.container {
        content = function()
        -- Loading of all checkboxes for all allowed policies
            for i, value in ipairs(args.elements) do
                local attr = table.new(args.attr)
                attr["onclick"] = "getElementById(\"" .. args.out_id .. "\").value = " .. tostring(value.id)
                if value.id == args.selected then
                    --create a new checkbox with one pre-selected
                    ui.field.parelon_radio {
                        name = "parelon_radio" .. args.id,
                        attr = args.attr,
                        id = value.id,
                        value = true,
                        label = value.name,
                        label_attr = args.label_attr,
                        attr = attr
                    }
                else
                    --create a new checkbox
                    ui.field.parelon_radio {
                        name = "parelon_radio" .. args.id,
                        attr = args.attr,
                        id = value.id,
                        label = value.name,
                        label_attr = args.label_attr,
                        attr = attr
                    }
                end
            end
        end
    }
end
