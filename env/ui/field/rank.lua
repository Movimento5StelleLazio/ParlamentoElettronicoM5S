function ui.field.rank(args)
  ui.form_element(args, {fetch_value = true}, function(args)
    local value = args.value
    local eligible = args.eligible
    ui.tag{
      attr = { class = "rank" },
      content = function()
        if eligible and value == 1 then
            ui.image{ attr = args.image_attr, static = "icons/16/award_star_gold_2.png" }
        elseif eligible and value then
            ui.image{ attr = args.image_attr, static = "icons/16/award_star_silver_2.png" }
        else
            ui.image{ attr = args.image_attr, static = "icons/16/cross.png" }
        end
        if value then
          ui.tag{
            attr = { class = "value" },
            content = tostring(value)
          }
        end
      end
    }
  end)
end
