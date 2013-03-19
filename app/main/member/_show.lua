local member = param.get("member", "table")

local tabs = {
  module = "member",
  view = "show_tab",
  static_params = {
    member_id = member.id
  }
}

tabs[#tabs+1] = {
  name = "profile",
  label = _"Profile",
  icon = { static = "icons/16/application_form.png" },
  module = "member",
  view = "_profile",
  params = { member = member },
}

local areas_selector = member:get_reference_selector("areas")
tabs[#tabs+1] = {
  name = "areas",
  label = _"Units and areas",
  icon = { static = "icons/16/package.png" },
  module = "index",
  view = "_member_home",
  params = { areas_selector = areas_selector, member = member, for_member = true },
}
  
tabs[#tabs+1] = {
  name = "timeline",
  label = _"Latest events",
  module = "event",
  view = "_list",
  params = { for_member = member }
}

tabs[#tabs+1] = {
  name = "open",
  label = _"Open issues",
  module = "issue",
  view = "_list",
  link_params = { 
    filter_interest = "issue",
  },
  params = {
    for_state = "open",
    for_member = member,
    issues_selector = Issue:new_selector()
      :add_where("issue.closed ISNULL")
      :add_order_by("coalesce(issue.fully_frozen + issue.voting_time, issue.half_frozen + issue.verification_time, issue.accepted + issue.discussion_time, issue.created + issue.admission_time) - now()")
  }
}

tabs[#tabs+1] = {
  name = "closed",
  label = _"Closed issues",
  module = "issue",
  view = "_list",
  link_params = { 
    filter_interest = "issue",
  },
  params = {
    for_state = "closed",
    for_member = member,
    issues_selector = Issue:new_selector()
      :add_where("issue.closed NOTNULL")
      :add_order_by("issue.closed DESC")

  }
}


local outgoing_delegations_selector = member:get_reference_selector("outgoing_delegations")
  :left_join("issue", "_member_showtab_issue", "_member_showtab_issue.id = delegation.issue_id")
  :add_where("_member_showtab_issue.closed ISNULL")
tabs[#tabs+1] = {
  name = "outgoing_delegations",
  label = _"Outgoing delegations" .. " (" .. tostring(outgoing_delegations_selector:count()) .. ")",
  icon = { static = "icons/16/table_go.png" },
  module = "delegation",
  view = "_list",
  params = { delegations_selector = outgoing_delegations_selector, outgoing = true },
}

local incoming_delegations_selector = member:get_reference_selector("incoming_delegations")
  :left_join("issue", "_member_showtab_issue", "_member_showtab_issue.id = delegation.issue_id")
  :add_where("_member_showtab_issue.closed ISNULL")
tabs[#tabs+1] = {
  name = "incoming_delegations",
  label = _"Incoming delegations" .. " (" .. tostring(incoming_delegations_selector:count()) .. ")",
  icon = { static = "icons/16/table_go.png" },
  module = "delegation",
  view = "_list",
  params = { delegations_selector = incoming_delegations_selector, incoming = true },
}

local contacts_selector = member:get_reference_selector("saved_members"):add_where("public")
tabs[#tabs+1] = {
  name = "contacts",
  label = _"Contacts" .. " (" .. tostring(contacts_selector:count()) .. ")",
  icon = { static = "icons/16/book_edit.png" },
  module = "member",
  view = "_list",
  params = { members_selector = contacts_selector },
}

ui.tabs(tabs)
