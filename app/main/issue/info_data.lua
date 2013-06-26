local issue = param.get("issue","table")
ui.container{ attr = { class = "row-fluid"}, content = function()
  ui.container{ attr = { class = "span12 alert issue_info_data"}, content = function()
    ui.link{
      module = "unit", view = "show", id = issue.area.unit_id,
      attr = { class = "" }, content=function()
        ui.heading{level=6,content= _("Unit: '#{name}'",{name=issue.area.unit.name})}
      end
    }
    ui.link{
      module = "area", view = "show", id = issue.area_id,
      attr = { class = "" }, content=function()
        ui.heading{level=6,content= _("Area: '#{name}'",{name=issue.area.name})}
      end
    }
    ui.link{
      attr = { class = "" },
      module = "issue",
      view = "show",
      id = issue.id,
      content=function()
        ui.heading{level=6,content= _("Policy: '#{name}'",{name=issue.policy.name})}
      end
    }
  end }
end }
