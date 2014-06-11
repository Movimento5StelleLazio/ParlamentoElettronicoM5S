local issue = param.get("issue","table")
ui.container{ attr = { class = "row-fluid"}, content = function()
  ui.container{ attr = { class = "span12 alert issue_info_data"}, content = function()
    ui.link{
      module = "unit", view = "show", id = issue.area.unit_id,
      content=function()
        ui.heading{level=6,content= function()
          ui.tag{content= _"Unit:"}
          slot.put(" ")
          ui.tag{tag="strong", content=issue.area.unit.name }
        end } 
      end
    }
    ui.link{
      module = "area", view = "show", id = issue.area_id,
      content=function()
        ui.heading{level=6,content= function()
          ui.tag{content= _"Area:"}
          slot.put(" ")
          ui.tag{tag="strong", content=issue.area.name }
        end }
      end
    }
    ui.link{
      module = "issue", view = "show", id = issue.id,
      content=function()
        ui.heading{level=6,content= function()
          ui.tag{content= _"Policy:"}
          slot.put(" ")
          ui.tag{tag="strong", content=issue.policy.name }
        end }
      end
    }
  end }
end }
