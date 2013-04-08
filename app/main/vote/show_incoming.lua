local initiative = Initiative:by_id(param.get("initiative_id", atom.integer))
local issue = initiative.issue
local member = Member:by_id(param.get("member_id", atom.integer))

local members_selector = Member:new_selector()
  :join("delegating_voter", nil, "delegating_voter.member_id = member.id")
  :add_where{ "delegating_voter.issue_id = ?", issue.id }
  :add_where{ "delegating_voter.delegate_member_ids[1] = ?", member.id }
  :add_field("delegating_voter.weight", "voter_weight")
  :join("issue", nil, "issue.id = delegating_voter.issue_id")

execute.view{
  module = "member",
  view = "_list",
  params = {
    members_selector = members_selector,
    initiative = initiative,
    trustee = member,
    for_votes = true
  }
}