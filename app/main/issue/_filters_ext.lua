local state = param.get("state")
local orderby = param.get("orderby")
local unit_name = param.get("unit_name")
local desc =  param.get("desc", atom.boolean)
local interest = param.get("interest")
local selector = param.get("selector", "table")

local member = app.session.member

--local for_member = param.get("for_member", "table")
--local for_unit = param.get("for_unit", atom.boolean)
--local for_area = param.get("for_area", atom.boolean)
--local for_events = param.get("for_events", atom.boolean)
--local filters = {}
--local filter = { name = "filter" }

local ord = ""
if desc then ord = " DESC" end

if state == "admission" then
--  selector:add_where("issue.state = 'admission'")
  selector:add_where("issue.accepted ISNULL AND issue.closed ISNULL")

elseif state == "development" then
--  selector:add_where("issue.state in ('discussion', 'verification', 'voting')")
  selector:add_where("issue.accepted NOTNULL AND issue.closed ISNULL")

elseif state == "discussion" then
--  selector:add_where("issue.state = 'discussion'")
  selector:add_where("issue.accepted NOTNULL AND issue.half_frozen ISNULL AND issue.closed ISNULL")

elseif state == "voting" then
--  selector:add_where("issue.state = 'voting'")
  selector:add_where("issue.fully_frozen NOTNULL AND issue.closed ISNULL")

elseif state == "verification" then
--  selector:add_where("issue.state = 'verification'")
  selector:add_where("issue.half_frozen NOTNULL AND issue.fully_frozen ISNULL")

elseif state == "closed" then
  selector:add_where("issue.closed NOTNULL")

elseif state == "finished" then
--  selector:add_where("issue.state IN ('finished_with_winner', 'finished_without_winner')")
  selector:add_where("issue.closed NOTNULL AND issue.fully_frozen NOTNULL")

elseif state == "finished_with_winner" then
  selector:add_where("issue.state = 'finished_with_winner'")

elseif state == "finished_without_winner" then
  selector:add_where("issue.state = 'finished_without_winner'")

elseif state == "canceled" then
--  selector:add_where("issue.state in ('canceled_revoked_before_accepted', 'canceled_issue_not_accepted', 'canceled_after_revocation_during_discussion', 'canceled_after_revocation_during_verification', 'canceled_no_initiative_admitted')")
  selector:add_where("issue.closed NOTNULL AND issue.fully_frozen ISNULL")

elseif state == "open" then
--  selector:add_where("issue.state in ('admission', 'discussion', 'verification', 'voting')")
  selector:add_where("issue.closed ISNULL")
--  selector:add_order_by("coalesce(issue.fully_frozen + issue.voting_time, issue.half_frozen + issue.verification_time, issue.accepted + issue.discussion_time, issue.created + issue.admission_time) - now()")

else
  state = "any"
end


-- Filtering interest
if interest ~= "any" and interest ~= nil and ( interest == "not_interested" or interest == "interested" or interest == "supported" or interest == "potentially_supported" or interest == 'voted'  or interest == 'not_voted' ) then

  -- Not interested
  if interest ==  "not_interested" then
  -- TODO Not working using CASE WHEN :(
    selector:left_join("interest", "filter_interest", { "filter_interest.issue_id = issue.id AND filter_interest.member_id = ? ", member.id })
    selector:add_where("filter_interest.member_id ISNULL AND issue.fully_frozen ISNULL AND issue.closed ISNULL")
--    selector:left_join("direct_interest_snapshot", "filter_interest_s", { "filter_interest_s.issue_id = issue.id AND filter_interest_s.member_id = ? AND filter_interest_s.event = issue.latest_snapshot_event", member.id })
--    selector:left_join("delegating_interest_snapshot", "filter_d_interest_s", { "filter_d_interest_s.issue_id = issue.id AND filter_d_interest_s.member_id = ? AND filter_d_interest_s.event = issue.latest_snapshot_event", member.id })
--    selector:add_where("CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN filter_interest.member_id ISNULL ELSE filter_interest_s.member_id ISNULL END OR filter_d_interest_s.member_id ISNULL")
  else

  -- Default joins for interest
    selector:left_join("interest", "filter_interest", { "filter_interest.issue_id = issue.id AND filter_interest.member_id = ? ", member.id })
    selector:left_join("direct_interest_snapshot", "filter_interest_s", { "filter_interest_s.issue_id = issue.id AND filter_interest_s.member_id = ? AND filter_interest_s.event = issue.latest_snapshot_event", member.id })
    selector:left_join("delegating_interest_snapshot", "filter_d_interest_s", { "filter_d_interest_s.issue_id = issue.id AND filter_d_interest_s.member_id = ? AND filter_d_interest_s.event = issue.latest_snapshot_event", member.id }) 
    selector:add_where("CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN filter_interest.member_id NOTNULL ELSE filter_interest_s.member_id NOTNULL END OR filter_d_interest_s.member_id NOTNULL")
  end

  -- Initiated
  if interest == "initiated" then
    selector:add_where({ "EXISTS (SELECT 1 FROM initiative JOIN initiator ON initiator.initiative_id = initiative.id AND initiator.member_id = ? AND initiator.accepted WHERE initiative.issue_id = issue.id)", member.id })

  -- Supported
  elseif interest == "supported" then
    selector:add_where({ 
      "CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN " ..
      "EXISTS(SELECT 1 FROM initiative JOIN supporter ON supporter.initiative_id = initiative.id AND supporter.member_id = ? LEFT JOIN critical_opinion ON critical_opinion.initiative_id = initiative.id AND critical_opinion.member_id = supporter.member_id WHERE initiative.issue_id = issue.id AND critical_opinion.member_id ISNULL) " ..
      "ELSE " ..
      "EXISTS(SELECT 1 FROM direct_supporter_snapshot WHERE direct_supporter_snapshot.event = issue.latest_snapshot_event AND direct_supporter_snapshot.issue_id = issue.id AND direct_supporter_snapshot.member_id = ? AND direct_supporter_snapshot.satisfied) " ..
      "END OR EXISTS(SELECT 1 FROM direct_supporter_snapshot WHERE direct_supporter_snapshot.event = issue.latest_snapshot_event AND direct_supporter_snapshot.issue_id = issue.id AND direct_supporter_snapshot.member_id = filter_d_interest_s.delegate_member_ids[array_upper(filter_d_interest_s.delegate_member_ids,1)] AND direct_supporter_snapshot.satisfied)", member.id, member.id, member.id })

  -- Potentially supported
  elseif interest == "potentially_supported" then
    selector:add_where({
      "CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN " ..
      "EXISTS(SELECT 1 FROM initiative JOIN supporter ON supporter.initiative_id = initiative.id AND supporter.member_id = ? LEFT JOIN critical_opinion ON critical_opinion.initiative_id = initiative.id AND critical_opinion.member_id = supporter.member_id WHERE initiative.issue_id = issue.id AND critical_opinion.member_id NOTNULL) " ..
      "ELSE " ..
      "EXISTS(SELECT 1 FROM direct_supporter_snapshot WHERE direct_supporter_snapshot.event = issue.latest_snapshot_event AND direct_supporter_snapshot.issue_id = issue.id AND direct_supporter_snapshot.member_id = ? AND NOT direct_supporter_snapshot.satisfied) " ..
      "END OR EXISTS(SELECT 1 FROM direct_supporter_snapshot WHERE direct_supporter_snapshot.event = issue.latest_snapshot_event AND direct_supporter_snapshot.issue_id = issue.id AND direct_supporter_snapshot.member_id = filter_d_interest_s.delegate_member_ids[array_upper(filter_d_interest_s.delegate_member_ids,1)] AND NOT direct_supporter_snapshot.satisfied)", member.id, member.id, member.id })

  -- Voted
  elseif interest == "voted" then
    selector:add_where({ "EXISTS(SELECT 1 FROM direct_voter WHERE direct_voter.issue_id = issue.id AND direct_voter.member_id = ?) OR (issue.closed NOTNULL AND EXISTS(SELECT 1 FROM delegating_voter WHERE delegating_voter.issue_id = issue.id AND delegating_voter.member_id = ?)) ", member.id, member.id })
    selector:join("direct_voter", nil, { "direct_voter.issue_id = issue.id AND direct_voter.member_id = ?", member.id })

  -- Not voted
  elseif interest == "not_voted" then
    selector:left_join("direct_voter", nil, { "direct_voter.issue_id = issue.id AND direct_voter.member_id = ?", member.id })
    selector:add_where("direct_voter.member_id ISNULL")
    selector:left_join("non_voter", nil, { "non_voter.issue_id = issue.id AND non_voter.member_id = ?", member.id })
    selector:add_where("non_voter.member_id ISNULL")
  end
else
  interest = "any"
end

-- Checking orderby
if orderby == "supporters" then
  selector:add_field("COUNT (*)","supporters")
  selector:left_join("supporter",nil,"issue.id = supporter.issue_id")
  selector:add_group_by("issue.id")
  selector:add_order_by("supporters"..ord)

elseif orderby == "event" then
  -- TODO
  selector:add_order_by("coalesce(issue.closed, issue.fully_frozen, issue.half_frozen, issue.accepted, issue.created)")

else
  orderby = "creation_date"
  selector:add_order_by("issue.created"..ord)
end
