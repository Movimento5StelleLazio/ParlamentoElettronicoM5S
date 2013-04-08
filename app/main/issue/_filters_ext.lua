local member = param.get("member", "table")
local for_member = param.get("for_member", "table")
local state = param.get("state")
local for_unit = param.get("for_unit", atom.boolean)
local for_area = param.get("for_area", atom.boolean)

local for_events = param.get("for_events", atom.boolean)

local filters = {}

local filter = { name = "filter" }
  
if state ~= "closed" then
  filter[#filter+1] = {
    name = "any",
    label = _"Any phase",
    selector_modifier = function(selector) end
  }
end

if not state then
  filter[#filter+1] = {
    name = "open",
    label = _"Open",
    selector_modifier = function(selector)
      if for_events then
        selector:add_where("event.state in ('admission', 'discussion', 'verification', 'voting')")
      else
        selector:add_where("issue.closed ISNULL")
      end
    end
  }
end

if not state or state == "open" then
  filter[#filter+1] = {
    name = "new",
    label = _"New",
    selector_modifier = function(selector)
      if for_events then
        selector:add_where("event.state = 'admission'")
      else
        selector:add_where("issue.accepted ISNULL AND issue.closed ISNULL")
      end
    end
  }
  filter[#filter+1] = {
    name = "accepted",
    label = _"Discussion",
    selector_modifier = function(selector)
      if for_events then
        selector:add_where("event.state = 'discussion'")
      else
        selector:add_where("issue.accepted NOTNULL AND issue.half_frozen ISNULL AND issue.closed ISNULL")
      end
    end
  }
  filter[#filter+1] = {
    name = "half_frozen",
    label = _"Frozen",
    selector_modifier = function(selector)
      if for_events then
        selector:add_where("event.state = 'verification'")
      else
        selector:add_where("issue.half_frozen NOTNULL AND issue.fully_frozen ISNULL")
      end
    end
  }
  filter[#filter+1] = {
    name = "frozen",
    label = _"Voting",
    selector_modifier = function(selector)
      if for_events then
        selector:add_where("event.state = 'voting'")
      else
        selector:add_where("issue.fully_frozen NOTNULL AND issue.closed ISNULL")
      end
      filter_voting = true
    end
  }
end

if not state then
  filter[#filter+1] = {
    name = "finished",
    label = _"Finished",
    selector_modifier = function(selector)
      if for_events then
        selector:add_where("event.state IN ('finished_with_winner', 'finished_without_winner')")
      else
        selector:add_where("issue.closed NOTNULL AND issue.fully_frozen NOTNULL")
      end
    end
  }
  filter[#filter+1] = {
    name = "canceled",
    label = _"Canceled",
    selector_modifier = function(selector)
        
      if for_events then
        selector:add_where("event.state IN ('canceled_revoked_before_accepted', 'canceled_issue_not_accepted', 'canceled_after_revocation_during_discussion', 'canceled_after_revocation_during_verification')")
      else
        selector:add_where("issue.closed NOTNULL AND issue.fully_frozen ISNULL")
      end
    end
  }
end

if state == "closed" then
  filter[#filter+1] = {
    name = "any",
    label = _"Any state",
    selector_modifier = function(selector) end
  }

  filter[#filter+1] = {
    name = "finished",
    label = _"Finished",
    selector_modifier = function(selector)
      if for_events then
        selector:add_where("event.state IN ('finished_with_winner', 'finished_without_winner')")
      else
        selector:add_where("issue.state IN ('finished_with_winner', 'finished_without_winner')")
      end
    end
  }
  filter[#filter+1] = {
    name = "finished_with_winner",
    label = _"with winner",
    selector_modifier = function(selector)
      if for_events then
        selector:add_where("event.state = 'finished_with_winner'")
      else
        selector:add_where("issue.state = 'finished_with_winner'")
      end
    end
  }
  filter[#filter+1] = {
    name = "finished_without_winner",
    label = _"without winner",
    selector_modifier = function(selector)
      if for_events then
        selector:add_where("event.state = 'finished_without_winner'")
      else
        selector:add_where("issue.state = 'finished_without_winner'")
      end
    end
  }
  filter[#filter+1] = {
    name = "canceled",
    label = _"Canceled",
    selector_modifier = function(selector)
      if for_events then
        selector:add_where("event.state NOT IN ('finished_with_winner', 'finished_without_winner')")
      else
        selector:add_where("issue.state NOT IN ('finished_with_winner', 'finished_without_winner')")
      end
    end
  }
end

filters[#filters+1] = filter


if member then
  local filter = {
    name = "filter_interest",
  }
  if not for_member then
    if not for_unit and not for_area then
      filter[#filter+1] = {
        name = "any",
        label = _"All units",
        selector_modifier = function()  end
      }
      filter[#filter+1] = {
        name = "unit",
        label = _"My units",
        selector_modifier = function(selector)
          selector:join("area", nil, "area.id = issue.area_id")
          selector:join("privilege", nil, { "privilege.unit_id = area.unit_id AND privilege.member_id = ? AND privilege.voting_right", member.id })
        end
      }
    end
    if for_unit and not for_area then
    filter[#filter+1] = {
        name = "any",
        label = _"All areas",
        selector_modifier = function()  end
      }
    end
    if not for_area then
      filter[#filter+1] = {
        name = "area",
        label = _"My areas",
        selector_modifier = function(selector)
          selector:join("membership", nil, { "membership.area_id = issue.area_id AND membership.member_id = ?", member.id })
        end
      }
    end
    if for_area then
    filter[#filter+1] = {
        name = "any",
        label = _"All issues",
        selector_modifier = function()  end
      }
    end
  end
  filter[#filter+1] = {
    name = "issue",
    label = _"Interested",
    selector_modifier = function() end
  }
  filter[#filter+1] = {
    name = "initiated",
    label = _"Initiated",
    selector_modifier = function(selector)
      selector:add_where({ "EXISTS (SELECT 1 FROM initiative JOIN initiator ON initiator.initiative_id = initiative.id AND initiator.member_id = ? AND initiator.accepted WHERE initiative.issue_id = issue.id)", member.id })
    end
  }
  filter[#filter+1] = {
    name = "supported",
    label = _"Supported",
    selector_modifier = function() end
  }
  filter[#filter+1] = {
    name = "potentially_supported",
    label = _"Potentially supported",
    selector_modifier = function() end
  }
  if state == 'closed' or (for_events) then
    filter[#filter+1] = {
      name = "voted",
      label = _"Voted",
      selector_modifier = function() end
    }
  end

  filters[#filters+1] = filter
end



if app.session.member then

  local filter_interest = param.get_all_cgi()["filter_interest"]
    
  if filter_interest ~= "any" and filter_interest ~= nil and (
    filter_interest == "issue" or filter_interest == "supported" or filter_interest == "potentially_supported" or 
    (filter_interest == 'voted' and state ~= 'open')
  ) then
    
    local function add_default_joins(selector)
      selector:left_join("interest", "filter_interest", { "filter_interest.issue_id = issue.id AND filter_interest.member_id = ? ", member.id })
      selector:left_join("direct_interest_snapshot", "filter_interest_s", { "filter_interest_s.issue_id = issue.id AND filter_interest_s.member_id = ? AND filter_interest_s.event = issue.latest_snapshot_event", member.id })
      selector:left_join("delegating_interest_snapshot", "filter_d_interest_s", { "filter_d_interest_s.issue_id = issue.id AND filter_d_interest_s.member_id = ? AND filter_d_interest_s.event = issue.latest_snapshot_event", member.id })        
    end
    
    filters[#filters+1] = {
      name = "filter_delegation",
      {
        name = "any",
        label = _"Direct and by delegation",
        selector_modifier = function(selector)
          add_default_joins(selector)
          selector:add_where("CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN filter_interest.member_id NOTNULL ELSE filter_interest_s.member_id NOTNULL END OR filter_d_interest_s.member_id NOTNULL")
          if filter_interest == "supported" then
            selector:add_where({ 
              "CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN " ..
                "EXISTS(SELECT 1 FROM initiative JOIN supporter ON supporter.initiative_id = initiative.id AND supporter.member_id = ? LEFT JOIN critical_opinion ON critical_opinion.initiative_id = initiative.id AND critical_opinion.member_id = supporter.member_id WHERE initiative.issue_id = issue.id AND critical_opinion.member_id ISNULL) " ..
              "ELSE " ..
                "EXISTS(SELECT 1 FROM direct_supporter_snapshot WHERE direct_supporter_snapshot.event = issue.latest_snapshot_event AND direct_supporter_snapshot.issue_id = issue.id AND direct_supporter_snapshot.member_id = ? AND direct_supporter_snapshot.satisfied) " ..
              "END OR EXISTS(SELECT 1 FROM direct_supporter_snapshot WHERE direct_supporter_snapshot.event = issue.latest_snapshot_event AND direct_supporter_snapshot.issue_id = issue.id AND direct_supporter_snapshot.member_id = filter_d_interest_s.delegate_member_ids[array_upper(filter_d_interest_s.delegate_member_ids,1)] AND direct_supporter_snapshot.satisfied)", member.id, member.id, member.id })

          elseif filter_interest == "potentially_supported" then
            selector:add_where({
              "CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN " ..
                "EXISTS(SELECT 1 FROM initiative JOIN supporter ON supporter.initiative_id = initiative.id AND supporter.member_id = ? LEFT JOIN critical_opinion ON critical_opinion.initiative_id = initiative.id AND critical_opinion.member_id = supporter.member_id WHERE initiative.issue_id = issue.id AND critical_opinion.member_id NOTNULL) " ..
              "ELSE " ..
                "EXISTS(SELECT 1 FROM direct_supporter_snapshot WHERE direct_supporter_snapshot.event = issue.latest_snapshot_event AND direct_supporter_snapshot.issue_id = issue.id AND direct_supporter_snapshot.member_id = ? AND NOT direct_supporter_snapshot.satisfied) " ..
              "END OR EXISTS(SELECT 1 FROM direct_supporter_snapshot WHERE direct_supporter_snapshot.event = issue.latest_snapshot_event AND direct_supporter_snapshot.issue_id = issue.id AND direct_supporter_snapshot.member_id = filter_d_interest_s.delegate_member_ids[array_upper(filter_d_interest_s.delegate_member_ids,1)] AND NOT direct_supporter_snapshot.satisfied)", member.id, member.id, member.id })

          elseif filter_interest == "voted" then
            selector:add_where({ "EXISTS(SELECT 1 FROM direct_voter WHERE direct_voter.issue_id = issue.id AND direct_voter.member_id = ?) OR (issue.closed NOTNULL AND EXISTS(SELECT 1 FROM delegating_voter WHERE delegating_voter.issue_id = issue.id AND delegating_voter.member_id = ?)) ", member.id, member.id })

          end

        end
      },
      {
        name = "direct",
        label = _"Direct",
        selector_modifier = function(selector)
          add_default_joins(selector)
          selector:add_where("CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN filter_interest.member_id NOTNULL ELSE filter_interest_s.member_id NOTNULL END")

          if filter_interest == "supported" then
            selector:add_where({ 
              "CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN " ..
                "EXISTS(SELECT 1 FROM initiative JOIN supporter ON supporter.initiative_id = initiative.id AND supporter.member_id = ? LEFT JOIN critical_opinion ON critical_opinion.initiative_id = initiative.id AND critical_opinion.member_id = supporter.member_id WHERE initiative.issue_id = issue.id AND critical_opinion.member_id ISNULL) " ..
              "ELSE " ..
                "EXISTS(SELECT 1 FROM direct_supporter_snapshot WHERE direct_supporter_snapshot.event = issue.latest_snapshot_event AND direct_supporter_snapshot.issue_id = issue.id AND direct_supporter_snapshot.member_id = ? AND direct_supporter_snapshot.satisfied) " ..
              "END", member.id, member.id })

          elseif filter_interest == "potentially_supported" then
            selector:add_where({
              "CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN " ..
                "EXISTS(SELECT 1 FROM initiative JOIN supporter ON supporter.initiative_id = initiative.id AND supporter.member_id = ? LEFT JOIN critical_opinion ON critical_opinion.initiative_id = initiative.id AND critical_opinion.member_id = supporter.member_id WHERE initiative.issue_id = issue.id AND critical_opinion.member_id NOTNULL) " ..
              "ELSE " ..
                "EXISTS(SELECT 1 FROM direct_supporter_snapshot WHERE direct_supporter_snapshot.event = issue.latest_snapshot_event AND direct_supporter_snapshot.issue_id = issue.id AND direct_supporter_snapshot.member_id = ? AND NOT direct_supporter_snapshot.satisfied) " ..
              "END", member.id, member.id })
          elseif filter_interest == "voted" then
            selector:add_where({ "EXISTS(SELECT 1 FROM direct_voter WHERE direct_voter.issue_id = issue.id AND direct_voter.member_id = ?) ", member.id })

          end
        end
      },
      {
        name = "delegated",
        label = _"By delegation",
        selector_modifier = function(selector)
          add_default_joins(selector)
          selector:add_where("filter_d_interest_s.member_id NOTNULL AND filter_interest.member_id ISNULL")

          if filter_interest == "supported" then
            selector:add_where({ 
              "EXISTS(SELECT 1 FROM direct_supporter_snapshot WHERE direct_supporter_snapshot.event = issue.latest_snapshot_event AND direct_supporter_snapshot.issue_id = issue.id AND direct_supporter_snapshot.member_id = filter_d_interest_s.delegate_member_ids[array_upper(filter_d_interest_s.delegate_member_ids,1)] AND direct_supporter_snapshot.satisfied)", member.id })

          elseif filter_interest == "potentially_supported" then
            selector:add_where({ 
              "EXISTS(SELECT 1 FROM direct_supporter_snapshot WHERE direct_supporter_snapshot.event = issue.latest_snapshot_event AND direct_supporter_snapshot.issue_id = issue.id AND direct_supporter_snapshot.member_id = filter_d_interest_s.delegate_member_ids[array_upper(filter_d_interest_s.delegate_member_ids,1)] AND NOT direct_supporter_snapshot.satisfied)", member.id })
          elseif filter_interest == "voted" then
            selector:add_where({ "issue.closed NOTNULL AND EXISTS(SELECT 1 FROM delegating_voter WHERE delegating_voter.issue_id = issue.id AND delegating_voter.member_id = ?) ", member.id })

          end
        end
      }
    }
  end

end

if state == 'open' and app.session.member and member.id == app.session.member_id and (param.get_all_cgi()["filter"] == "frozen") then
  filters[#filters+1] = {
    name = "filter_voting",
    {
      name = "any",
      label = _"Any",
      selector_modifier = function()  end
    },
    {
      name = "not_voted",
      label = _"Not voted",
      selector_modifier = function(selector)
        selector:left_join("direct_voter", nil, { "direct_voter.issue_id = issue.id AND direct_voter.member_id = ?", member.id })
        selector:add_where("direct_voter.member_id ISNULL")
        selector:left_join("non_voter", nil, { "non_voter.issue_id = issue.id AND non_voter.member_id = ?", member.id })
        selector:add_where("non_voter.member_id ISNULL")
      end
    },
    {
      name = "voted",
      label = _"Voted",
      selector_modifier = function(selector)
        selector:join("direct_voter", nil, { "direct_voter.issue_id = issue.id AND direct_voter.member_id = ?", member.id })
      end
    },
  }
end




function filters:get_filter(group, name)
  for i,grp in ipairs(self) do
    if grp.name == group then
      for i,entry in ipairs(grp) do
        if entry.name == name then
          return entry
        end
      end
    end
  end
end

return filters