local issue = param.get("issue","table")
ui.container{ attr = { class = "row-fluid"}, content = function()
  ui.container{ attr = { class = "span12"}, content = function()
    ui.link{
      module = "unit", view = "show", id = issue.area.unit_id,
      attr = { class = "label label-success" }, text = issue.area.unit.name
    }
    slot.put(" ")
    ui.link{
      module = "area", view = "show", id = issue.area_id,
      attr = { class = "label label-important" }, text = issue.area.name
    }
    slot.put(" ")
    ui.link{
      attr = { class = "label label-info" },
      text = _("#{policy_name} ##{issue_id}", {
        policy_name = issue.policy.name,
        issue_id = issue.id
      }),
      module = "issue",
      view = "show",
      id = issue.id
    }
  end }
end }
