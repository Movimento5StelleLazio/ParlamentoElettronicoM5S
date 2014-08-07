local issue = param.get("issue","table")

    ui.link{
      module = "unit", view = "show", id = issue.area.unit_id,
      content=function()
        ui.heading{level=3,content= function()
          ui.tag{content= _"Unit:"}
          slot.put(" ")
          ui.tag{tag="strong", content=issue.area.unit.name }
        end } 
      end
    }
    ui.link{
      module = "area", view = "show", id = issue.area_id,
      content=function()
        ui.heading{level=3,content= function()
          ui.tag{content= _"Area:"}
          slot.put(" ")
          ui.tag{tag="strong", content=issue.area.name }
        end }
      end
    }
    ui.link{
      module = "issue", view = "show", id = issue.id,
      content=function()
        ui.heading{level=3,content= function()
          ui.tag{content= _"Policy:"}
          slot.put(" ")
          ui.tag{tag="strong", content=issue.policy.name }
        end }
      end
    }

