Issue = mondelefant.new_class()
Issue.table = 'issue'

local new_selector = Issue.new_selector

function Issue:new_selector()
  local selector = new_selector(self)
  selector:add_field("justify_interval(admission_time)::text", "admission_time_text")
  selector:add_field("justify_interval(discussion_time)::text", "discussion_time_text")
  selector:add_field("justify_interval(verification_time)::text", "verification_time_text")
  selector:add_field("justify_interval(voting_time)::text", "voting_time_text")
  selector:add_field("justify_interval(coalesce(issue.fully_frozen + issue.voting_time, issue.half_frozen + issue.verification_time, issue.accepted + issue.discussion_time, issue.created + issue.admission_time) - now())", "state_time_left")
  selector:add_field("justify_interval(now() - issue.closed)", "closed_ago")
  return selector
end

Issue:add_reference{
  mode          = 'm1',
  to            = "Area",
  this_key      = 'area_id',
  that_key      = 'id',
  ref           = 'area',
}

Issue:add_reference{
  mode          = 'm1',
  to            = "Policy",
  this_key      = 'policy_id',
  that_key      = 'id',
  ref           = 'policy',
}

Issue:add_reference{
  mode          = '1m',
  to            = "Initiative",
  this_key      = 'id',
  that_key      = 'issue_id',
  ref           = 'initiatives',
  back_ref      = 'issue',
  default_order = 'initiative.admitted DESC NULLS LAST, initiative.rank NULLS LAST, initiative.harmonic_weight DESC NULLS LAST, id'
}

Issue:add_reference{
  mode          = '1m',
  to            = "Interest",
  this_key      = 'id',
  that_key      = 'issue_id',
  ref           = 'interests',
  back_ref      = 'issue',
  default_order = '"id"'
}

Issue:add_reference{
  mode          = '1m',
  to            = "Supporter",
  this_key      = 'id',
  that_key      = 'issue_id',
  ref           = 'supporters',
  back_ref      = 'issue',
  default_order = '"id"'
}

Issue:add_reference{
  mode          = '1m',
  to            = "DirectVoter",
  this_key      = 'id',
  that_key      = 'issue_id',
  ref           = 'direct_voters',
  back_ref      = 'issue',
  default_order = '"member_id"'
}

Issue:add_reference{
  mode          = '1m',
  to            = "Vote",
  this_key      = 'id',
  that_key      = 'issue_id',
  ref           = 'votes',
  back_ref      = 'issue',
  default_order = '"member_id", "initiative_id"'
}

Issue:add_reference{
  mode          = '1m',
  to            = "Delegation",
  this_key      = 'id',
  that_key      = 'issue_id',
  ref           = 'delegations',
  back_ref      = 'issue'
}

Issue:add_reference{
  mode                  = 'mm',
  to                    = "Member",
  this_key              = 'id',
  that_key              = 'id',
  connected_by_table    = 'interest',
  connected_by_this_key = 'issue_id',
  connected_by_that_key = 'member_id',
  ref                   = 'members'
}

Issue:add_reference{
  mode                  = 'mm',
  to                    = "Member",
  this_key              = 'id',
  that_key              = 'id',
  connected_by_table    = 'direct_interest_snapshot',
  connected_by_this_key = 'issue_id',
  connected_by_that_key = 'member_id',
  ref                   = 'interested_members_snapshot'
}

Issue:add_reference{
  mode                  = 'mm',
  to                    = "Member",
  this_key              = 'id',
  that_key              = 'id',
  connected_by_table    = 'direct_voter',
  connected_by_this_key = 'issue_id',
  connected_by_that_key = 'member_id',
  ref                   = 'direct_voters'
}

Issue:add_reference{
  mode               = "11",
  to                 = mondelefant.class_prototype,
  this_key           = "id",
  that_key           = "issue_id",
  ref                = "member_info",
  back_ref           = "issue",
  selector_generator = function(list, options)
    assert(options.member_id, "member_id mandatory for member_info")
    local ids = { sep = ", " }
    for i, object in ipairs(list) do
      local id = object.id
      if id ~= nil then
        ids[#ids+1] = {"?", id}
      end
    end
    local sub_selector = Issue:get_db_conn():new_selector()
    if #ids == 0 then
      return sub_selector:empty_list_mode()
    end
    sub_selector:from("issue")
    sub_selector:add_field("issue.id", "issue_id")
    sub_selector:add_field{ '(delegation_info(?, null, null, issue.id, ?)).*', options.member_id, options.trustee_id }
    sub_selector:add_where{ 'issue.id IN ($)', ids }

    local selector = Issue:get_db_conn():new_selector()
    selector:add_from("issue")
    selector:join(sub_selector, "delegation_info", "delegation_info.issue_id = issue.id")
    selector:left_join("member", "first_trustee", "first_trustee.id = delegation_info.first_trustee_id")
    selector:left_join("member", "other_trustee", "other_trustee.id = delegation_info.other_trustee_id")
    selector:add_field("delegation_info.*")
    selector:add_field("first_trustee.name", "first_trustee_name")
    selector:add_field("other_trustee.name", "other_trustee_name")
    selector:left_join("direct_voter", nil, { "direct_voter.issue_id = issue.id AND direct_voter.member_id = ?", options.member_id })
    selector:add_field("direct_voter.member_id NOTNULL", "direct_voted")
    selector:left_join("non_voter", nil, { "non_voter.issue_id = issue.id AND non_voter.member_id = ?", options.member_id })
    selector:add_field("non_voter.member_id NOTNULL", "non_voter")
    return selector
  end
}

function Issue.list:load_everything_for_member_id(member_id)
  local areas = self:load("area")
  areas:load("unit")
  self:load("policy")
  if member_id then
    self:load("member_info", { member_id = member_id })
  end
  local initiatives = self:load("initiatives")
  initiatives:load_everything_for_member_id(member_id)
end

function Issue.object:load_everything_for_member_id(member_id)
  local areas = self:load("area")
  areas:load("unit")
  self:load("policy")
  if member_id then
    self:load("member_info", { member_id = member_id })
  end
  local initiatives = self:load("initiatives")
  initiatives:load_everything_for_member_id(member_id)
end



function Issue:get_state_name_for_state(value)
  local state_name_table = {
    admission = _"New",
    discussion = _"Discussion",
    verification = _"Frozen",
    voting = _"Voting",
    canceled_revoked_before_accepted = _"Canceled (before accepted due to revocation)",
    canceled_issue_not_accepted = _"Canceled (issue not accepted)",
    canceled_after_revocation_during_discussion = _"Canceled (during discussion due to revocation)",
    canceled_after_revocation_during_verification = _"Canceled (during verification due to revocation)",
    calculation = _"Calculation",
    canceled_no_initiative_admitted = _"Canceled (no initiative admitted)",
    finished_without_winner = _"Finished (without winner)",
    finished_with_winner = _"Finished (with winner)"
  }
  return state_name_table[value] or value or ''
end



function Issue:get_search_selector(search_string)
  return self:new_selector()
    :join('"initiative"', nil, '"initiative"."issue_id" = "issue"."id"')
    :join('"draft"', nil, '"draft"."initiative_id" = "initiative"."id"')
    :add_where{ '"initiative"."text_search_data" @@ "text_search_query"(?) OR "draft"."text_search_data" @@ "text_search_query"(?)', search_string, search_string }
    :add_group_by('"issue"."id"')
    :add_group_by('"issue"."area_id"')
    :add_group_by('"issue"."policy_id"')
    :add_group_by('"issue"."state"')
    :add_group_by('"issue"."phase_finished"')
    :add_group_by('"issue"."created"')
    :add_group_by('"issue"."accepted"')
    :add_group_by('"issue"."half_frozen"')
    :add_group_by('"issue"."fully_frozen"')
    :add_group_by('"issue"."closed"')
    :add_group_by('"issue"."status_quo_schulze_rank"')
    :add_group_by('"issue"."cleaned"')
    :add_group_by('"issue"."snapshot"')
    :add_group_by('"issue"."latest_snapshot_event"')
    :add_group_by('"issue"."population"')
    :add_group_by('"issue"."voter_count"')
    :add_group_by('"issue"."admission_time"')
    :add_group_by('"issue"."discussion_time"')
    :add_group_by('"issue"."verification_time"')
    :add_group_by('"issue"."voting_time"')
    --:set_distinct()
end

function Issue:modify_selector_for_state(initiatives_selector, state)
  if state == "new" then
    initiatives_selector:add_where("issue.accepted ISNULL AND issue.closed ISNULL")
  elseif state == "accepted" then
    initiatives_selector:add_where("issue.accepted NOTNULL AND issue.half_frozen ISNULL AND issue.closed ISNULL")
  elseif state == "frozen" then
    initiatives_selector:add_where("issue.half_frozen NOTNULL AND issue.fully_frozen ISNULL AND issue.closed ISNULL")
  elseif state == "voting" then
    initiatives_selector:add_where("issue.fully_frozen NOTNULL AND issue.closed ISNULL")
  elseif state == "finished" then
    initiatives_selector:add_where("issue.fully_frozen NOTNULL AND issue.closed NOTNULL")
  elseif state == "canceled" then
    initiatives_selector:add_where("issue.fully_frozen ISNULL AND issue.closed NOTNULL")
  else
    error("Invalid state")
  end
end


function Issue.object_get:state_name()
  return Issue:get_state_name_for_state(self.state)
end

function Issue.object_get:next_states_names()
  local next_states = self.next_states
  if not next_states then
    return
  end
  local state_names = {}
  for i, state in ipairs(self.next_states) do
    state_names[#state_names+1] = Issue:get_state_name_for_state(state)
  end
  return table.concat(state_names, ", ")
end

function Issue.object_get:etherpad_url()
  return config.etherpad.base_url .. "p/" .. config.etherpad.group_id .. "$Issue" .. self.id
end
