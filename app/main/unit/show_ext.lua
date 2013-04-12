local unit_id = param.get_id()
local unit = Unit:by_id(unit_id)

if not app.session.member_id then
  return false
end

local member = app.session.member

local areas_selector = Area:build_selector{ active = true, unit_id = unit_id }
areas_selector:add_order_by("member_weight DESC")

local members_selector = Member:build_selector{
  active = true,
  voting_right_for_unit_id = unit.id
}

ui.container{ attr = { class  = "unit_header_box" }, content = function()
  ui.link { attr = { id = "unit_button_back", class="button orange menuButton"  }, content = function()
    ui.image{ attr = { id = "unit_arrow_back" }, static = "arrow_left.png" }
    ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"BACK TO PREVIOUS PAGE" }
  end}
  ui.tag { tag = "p", attr = { id = "unit_title", class  = "welcome_text_l"}, content = _("#{realname}, you are now in the Regione Lazio Assembly", {realname = member.realname}) }
  ui.tag { tag = "p", attr = { class  = "welcome_text_xl"}, content = _"CHOOSE THE THEMATIC AREA" }
end}

ui.image{ attr = { id = "unit_parlamento_img" }, static = "parlamento_icon_small.png" }

ui.container{ attr = { class="unit_issue_box"}, content=function()
  -- Implementare la logica per mostrare la scritta corretta
  ui.tag { tag = "p", attr = { class  = "welcome_text_xl"  }, content = _"THEMATIC AREAS" }
  ui.link { attr = { id = "unit_button_left", class="button orange menuButton"  }, content = function()
    ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"SHOW ALL AREAS" }
  end}
  ui.link { attr = { id = "unit_button_right", class="button orange menuButton"  }, content = function()
    ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"SHOW ONLY PARTECIPATED AREAS" }
  end}
end}

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

--ui.tabs(tabs)
