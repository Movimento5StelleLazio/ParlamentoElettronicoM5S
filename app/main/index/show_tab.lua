local tabs = {
  module = "index",
  view = "show_tab"
}

local selector = Area:new_selector()
  :reset_fields()
  :add_field("area.id", nil, { "grouped" })
  :add_field("area.name", nil, { "grouped" })
  :add_field("membership.member_id NOTNULL", "is_member", { "grouped" })
  :add_field("count(issue.id)", "issues_to_vote_count")
  :add_field("count(interest.member_id)", "interested_issues_to_vote_count")
  :add_field("count(interest.member_id NOTNULL OR interest.member_id NOTNULL)", "issues_to_vote_count_sum")
  :join("issue", nil, "issue.area_id = area.id AND issue.fully_frozen NOTNULL AND issue.closed ISNULL")
  :left_join("direct_voter", nil, { "direct_voter.issue_id = issue.id AND direct_voter.member_id = ?", app.session.member.id })
  :add_where{ "direct_voter.member_id ISNULL" }
  :left_join("interest", nil, { "interest.issue_id = issue.id AND interest.member_id = ?", app.session.member.id })
  :left_join("membership", nil, { "membership.area_id = area.id AND membership.member_id = ? ", app.session.member.id })

local not_voted_areas = {}
local issues_to_vote_count = 0
for i, area in ipairs(selector:exec()) do
  if area.is_member or area.interested_issues_to_vote_count > 0 then
    not_voted_areas[#not_voted_areas+1] = area
  end
  issues_to_vote_count = issues_to_vote_count + area.issues_to_vote_count_sum
end

tabs[#tabs+1] = {
  name = "not_voted_issues",
  label = _"Not voted issues" .. " (" .. tostring(issues_to_vote_count) .. ")",
  icon = { static = "icons/16/email_open.png" },
  module = "index",
  view = "_not_voted_issues",
  params = {
    areas = not_voted_areas
  }
}

local initiator_invites_selector = Initiative:new_selector()
  :join("issue", "_issue_state", "_issue_state.id = initiative.issue_id")
  :join("initiator", nil, { "initiator.initiative_id = initiative.id AND initiator.member_id = ? AND initiator.accepted ISNULL", app.session.member.id })
  :add_where("_issue_state.closed ISNULL AND _issue_state.half_frozen ISNULL")

tabs[#tabs+1] = {
  name = "initiator_invites",
  label = _"Initiator invites" .. " (" .. tostring(initiator_invites_selector:count()) .. ")",
  icon = { static = "icons/16/email_open.png" },
  module = "index",
  view = "_initiator_invites",
  params = {
    initiatives_selector = initiator_invites_selector
  }
}

local updated_drafts_selector = Initiative:new_selector()
  :join("issue", "_issue_state", "_issue_state.id = initiative.issue_id AND _issue_state.closed ISNULL AND _issue_state.fully_frozen ISNULL")
  :join("current_draft", "_current_draft", "_current_draft.initiative_id = initiative.id")
  :join("supporter", "supporter", { "supporter.member_id = ? AND supporter.initiative_id = initiative.id AND supporter.draft_id < _current_draft.id", app.session.member_id })

tabs[#tabs+1] = {
  name = "updated_drafts",
  label = _"Updated drafts" .. " (" .. tostring(updated_drafts_selector:count()) .. ")",
  icon = { static = "icons/16/email_open.png" },
  module = "index",
  view = "_updated_drafts",
  params = {
    initiatives_selector = updated_drafts_selector
  }
}

ui.tabs(tabs)