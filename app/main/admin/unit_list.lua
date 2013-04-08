local inactive = param.get("inactive", atom.boolean)

local units = Unit:get_flattened_tree{ include_inactive = inactive }

ui.title(_"Unit list")

ui.actions(function()
  ui.link{
    text = _"Create new unit",
    module = "admin",
    view = "unit_edit"
  }
  slot.put(" &middot; ")
  if inactive then
    ui.link{
      text = _"Hide active units",
      module = "admin",
      view = "unit_list"
    }
  else
    ui.link{
      text = _"Show inactive units",
      module = "admin",
      view = "unit_list",
      params = { inactive = true }
    }
  end
end)
 
ui.list{
  records = units,
  columns = {
    {
      content = function(unit)
        for i = 1, unit.depth - 1 do
          slot.put("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
        end
        local style = ""
        if not unit.active then
          style = "text-decoration: line-through;"
        end
        ui.link{
          attr = { style = "font-weight: bold;" .. style },
          text = unit.name,
          module = "admin", view = "unit_edit", id = unit.id
        }
        slot.put(" &middot; ")
        ui.link{
          text = _"Edit areas",
          module = "admin", view = "area_list", params = { unit_id = unit.id }
        }
      end 
    }
  }
}