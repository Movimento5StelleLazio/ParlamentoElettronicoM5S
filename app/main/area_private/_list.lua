local areas_selector = param.get("areas_selector", "table")
local hide_membership = param.get("hide_membership", atom.boolean)
local member = param.get("member", "table")

areas_selector
  :reset_fields()
  :add_field("area.id", nil, { "grouped" })
  :add_field("area.unit_id", nil, { "grouped" })
  :add_field("area.name", nil, { "grouped" })
  :add_field("member_weight", nil, { "grouped" })
  :add_field("direct_member_count", nil, { "grouped" })
  :add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.accepted ISNULL AND issue.closed ISNULL)", "issues_new_count")
  :add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.accepted NOTNULL AND issue.half_frozen ISNULL AND issue.closed ISNULL)", "issues_discussion_count")
  :add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.half_frozen NOTNULL AND issue.fully_frozen ISNULL AND issue.closed ISNULL)", "issues_frozen_count")
  :add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.fully_frozen NOTNULL AND issue.closed ISNULL)", "issues_voting_count")
  :add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.fully_frozen NOTNULL AND issue.closed NOTNULL)", "issues_finished_count")
  :add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.fully_frozen ISNULL AND issue.closed NOTNULL)", "issues_canceled_count")

if app.session.member_id then
  areas_selector
    :add_field({ "(SELECT COUNT(*) FROM issue LEFT JOIN direct_voter ON direct_voter.issue_id = issue.id AND direct_voter.member_id = ? WHERE issue.area_id = area.id AND issue.fully_frozen NOTNULL AND issue.closed ISNULL AND direct_voter.member_id ISNULL)", app.session.member.id }, "issues_to_vote_count")
    :left_join("membership", "_membership", { "_membership.area_id = area.id AND _membership.member_id = ?", app.session.member.id })
    :add_field("_membership.member_id NOTNULL", "is_member", { "grouped" })
    :left_join("delegation", nil, {
      "delegation.truster_id = ? AND delegation.area_id = area.id AND delegation.scope = 'area'", app.session.member_id
    })
    :left_join("member", nil, "member.id = delegation.trustee_id")
    :add_field("member.id", "trustee_member_id", { "grouped" })
    :add_field("member.name", "trustee_member_name", { "grouped" })
else
  areas_selector:add_field("0", "issues_to_vote_count")
end

ui.container{ attr = { class = "area_list" }, content = function()
  for i, area in ipairs(areas_selector:exec()) do
    execute.view { module = "area", view = "_list_entry", params = { area = area, member = member } }
  end 
end }

