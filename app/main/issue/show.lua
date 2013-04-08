local issue = Issue:by_id(param.get_id())
if app.session.member_id then
  issue:load_everything_for_member_id(app.session.member_id)
end

if not app.html_title.title then
	app.html_title.title = _("Issue ##{id}", { id = issue.id })
end

slot.select("head", function()
  execute.view{ module = "area", view = "_head", params = { area = issue.area } }
end)

util.help("issue.show")

slot.select("head", function()
  execute.view{ module = "issue", view = "_show", params = { issue = issue } }
end )

if app.session:has_access("all_pseudonymous") then

  ui.container{ attr = { class = "heading" }, content = _"Interested members" }
  
  local interested_members_selector = issue:get_reference_selector("interested_members_snapshot")
    :join("issue", nil, "issue.id = direct_interest_snapshot.issue_id")
    :add_field("direct_interest_snapshot.weight")
    :add_where("direct_interest_snapshot.event = issue.latest_snapshot_event")

  execute.view{
    module = "member",
    view = "_list",
    params = {
      issue = issue,
      members_selector = interested_members_selector
    }
  }

  ui.container{ attr = { class = "heading" }, content = _"Details" }
  
  execute.view{
    module = "issue",
    view = "_details",
    params = { issue = issue }
  }
  
end

if issue.snapshot then
  slot.put("<br />")
  ui.field.timestamp{ label = _"Last snapshot:", value = issue.snapshot }
end

