local unit_id = config.single_unit_id or param.get_id()

local unit = Unit:by_id(unit_id)

slot.select("head", function()
  execute.view{ module = "unit", view = "_head", params = { unit = unit, show_content = true, member = app.session.member } }
end)

if config.single_unit_id and not app.session.member_id and config.motd_public then
  local help_text = config.motd_public
  ui.container{
    attr = { class = "wiki motd" },
    content = function()
      slot.put(format.wiki_text(help_text))
    end
  }
end

local areas_selector = Area:build_selector{ active = true, unit_id = unit_id }
areas_selector:add_order_by("member_weight DESC")

local members_selector = Member:build_selector{
  active = true,
  voting_right_for_unit_id = unit.id
}

local delegations_selector = Delegation:new_selector()
  :join("member", "truster", "truster.id = delegation.truster_id AND truster.active")
  :join("privilege", "truster_privilege", "truster_privilege.member_id = truster.id AND truster_privilege.unit_id = delegation.unit_id AND truster_privilege.voting_right")
  :join("member", "trustee", "trustee.id = delegation.trustee_id AND truster.active")
  :join("privilege", "trustee_privilege", "trustee_privilege.member_id = trustee.id AND trustee_privilege.unit_id = delegation.unit_id AND trustee_privilege.voting_right")
  :add_where{ "delegation.unit_id = ?", unit.id }

local open_issues_selector = Issue:new_selector()
  :join("area", nil, "area.id = issue.area_id")
  :add_where{ "area.unit_id = ?", unit.id }
  :add_where("issue.closed ISNULL")
  :add_order_by("coalesce(issue.fully_frozen + issue.voting_time, issue.half_frozen + issue.verification_time, issue.accepted + issue.discussion_time, issue.created + issue.admission_time) - now()")

local closed_issues_selector = Issue:new_selector()
  :join("area", nil, "area.id = issue.area_id")
  :add_where{ "area.unit_id = ?", unit.id }
  :add_where("issue.closed NOTNULL")
  :add_order_by("issue.closed DESC")

local tabs = {
  module = "unit",
  view = "show",
  id = unit.id
}

tabs[#tabs+1] = {
  name = "areas",
  label = _"Areas",
  module = "area",
  view = "_list",
  params = { areas_selector = areas_selector, member = app.session.member }
}

tabs[#tabs+1] = {
  name = "timeline",
  label = _"Latest events",
  module = "event",
  view = "_list",
  params = { for_unit = unit }
}

tabs[#tabs+1] = {
  name = "open",
  label = _"Open issues",
  module = "issue",
  view = "_list",
  params = {
    for_state = "open",
    issues_selector = open_issues_selector, for_unit = true
  }
}
tabs[#tabs+1] = {
  name = "closed",
  label = _"Closed issues",
  module = "issue",
  view = "_list",
  params = {
    for_state = "closed",
    issues_selector = closed_issues_selector, for_unit = true
  }
}

if app.session:has_access("all_pseudonymous") then
  tabs[#tabs+1] = {
    name = "eligible_voters",
    label = _"Eligible voters",
    module = "member",
    view = "_list",
    params = { members_selector = members_selector }
  }

  tabs[#tabs+1] = {
    name = "delegations",
    label = _"Delegations",
    module = "delegation",
    view = "_list",
    params = { delegations_selector = delegations_selector }
  }
end

ui.tabs(tabs)