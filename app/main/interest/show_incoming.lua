local issue = Issue:by_id(param.get("issue_id", atom.integer))
local member = Member:by_id(param.get("member_id", atom.integer))

local members_selector = Member:new_selector()
  :join("delegating_interest_snapshot", nil, "delegating_interest_snapshot.member_id = member.id")
  :join("issue", nil, "issue.id = delegating_interest_snapshot.issue_id")
  :add_where{ "delegating_interest_snapshot.issue_id = ?", issue.id }
  :add_where{ "delegating_interest_snapshot.event = ?", issue.latest_snapshot_event }
  :add_where{ "delegating_interest_snapshot.delegate_member_ids[1] = ?", member.id }
  :add_field{ "delegating_interest_snapshot.weight" }

execute.view{
  module = "member",
  view = "_list",
  params = { 
    members_selector = members_selector,
    issue = issue,
    trustee = member
  }
}