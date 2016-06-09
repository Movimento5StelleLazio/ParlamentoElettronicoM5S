function ui.field.rank(args)
    ui.form_element(args, { fetch_value = true }, function(args)
        local value = args.value
        local eligible = args.eligible
        ui.tag {
            attr = { class = "rank" },
            content = function()
                if eligible and value == 1 then
                    ui.image { attr = args.image_attr, static = "png/winner.png" }
                elseif eligible and value then
                    ui.image { attr = args.image_attr, static = "png/second_winner.png" }
                else
                    ui.image { attr = args.image_attr, static = "png/cross.png" }
                end
                if value and value ~= 1 then
                    ui.tag {
                        attr = { class = "value" },
                        content = tostring(value)
                    }
                end
            end
        }
    end)
end
