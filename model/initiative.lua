Initiative = mondelefant.new_class()
Initiative.table = 'initiative'

Initiative:add_reference{
  mode          = 'm1',
  to            = "Issue",
  this_key      = 'issue_id',
  that_key      = 'id',
  ref           = 'issue',
}

Initiative:add_reference{
  mode          = '1m',
  to            = "Draft",
  this_key      = 'id',
  that_key      = 'initiative_id',
  ref           = 'drafts',
  back_ref      = 'initiative',
  default_order = '"id" DESC'
}

Initiative:add_reference{
  mode          = '1m',
  to            = "Suggestion",
  this_key      = 'id',
  that_key      = 'initiative_id',
  ref           = 'suggestions',
  back_ref      = 'initiative',
}

Initiative:add_reference{
  mode          = '1m',
  to            = "Initiator",
  this_key      = 'id',
  that_key      = 'initiative_id',
  ref           = 'initiators',
  back_ref      = 'initiative'
}

Initiative:add_reference{
  mode          = '1m',
  to            = "Supporter",
  this_key      = 'id',
  that_key      = 'initiative_id',
  ref           = 'supporters',
  back_ref      = 'initiative',
  default_order = '"id"'
}

Initiative:add_reference{
  mode          = '1m',
  to            = "Opinion",
  this_key      = 'id',
  that_key      = 'initiative_id',
  ref           = 'opinions',
  back_ref      = 'initiative',
  default_order = '"id"'
}

Initiative:add_reference{
  mode          = '1m',
  to            = "Vote",
  this_key      = 'id',
  that_key      = 'initiative_id',
  ref           = 'votes',
  back_ref      = 'initiative',
  default_order = '"member_id"'
}

Initiative:add_reference{
  mode          = 'm1',
  to            = "Initiative",
  this_key      = 'suggested_initiative_id',
  that_key      = 'id',
  ref           = 'suggested_initiative',
}

Initiative:add_reference{
  mode                  = 'mm',
  to                    = "Member",
  this_key              = 'id',
  that_key              = 'id',
  connected_by_table    = '"initiator"',
  connected_by_this_key = 'initiative_id',
  connected_by_that_key = 'member_id',
  ref                   = 'initiating_members'
}

Initiative:add_reference{
  mode                  = 'mm',
  to                    = "Member",
  this_key              = 'id',
  that_key              = 'id',
  connected_by_table    = '"supporter"',
  connected_by_this_key = 'initiative_id',
  connected_by_that_key = 'member_id',
  ref                   = 'supporting_members'
}

Initiative:add_reference{
  mode                  = 'mm',
  to                    = "Member",
  this_key              = 'id',
  that_key              = 'id',
  connected_by_table    = 'direct_supporter_snapshot',
  connected_by_this_key = 'initiative_id',
  connected_by_that_key = 'member_id',
  ref                   = 'supporting_members_snapshot'
}

Initiative:add_reference{
  mode               = "11",
  to                 = mondelefant.class_prototype,
  this_key           = "id",
  that_key           = "initiative_id",
  ref                = "member_info",
  back_ref           = "initiative",
  selector_generator = function(list, options)
    assert(options.member_id, "member_id mandatory for member_info")
    local ids = { sep = ", " }
    local issue_ids = { sep = ", " }
    for i, object in ipairs(list) do
      local id = object.id
      if id ~= nil then
        ids[#ids+1] = {"?", id}
        issue_ids[#issue_ids+1] = { "?", object.issue_id }
      end
    end

    local sub_selector = Issue:get_db_conn():new_selector()
    if #ids == 0 then
      return sub_selector:empty_list_mode()
    end
    sub_selector:from("issue")
    sub_selector:add_field("issue.id", "issue_id")
    sub_selector:add_field{ '(delegation_info(?, null, null, issue.id, ?)).*', options.member_id, options.trustee_id }
    sub_selector:add_where{ 'issue.id IN ($)', issue_ids }

    local selector = Initiative:get_db_conn():new_selector()
    selector:add_from("initiative")
    selector:add_field("initiative.id", "initiative_id")
    selector:join("issue", nil, "issue.id = initiative.issue_id")
    selector:join(sub_selector, "delegation_info", "delegation_info.issue_id = issue.id")
    selector:add_field("delegation_info.*")
    
    selector:left_join("supporter", nil, "supporter.initiative_id = initiative.id AND supporter.member_id = delegation_info.participating_member_id")

    selector:left_join("delegating_interest_snapshot", "delegating_interest_s", { "delegating_interest_s.event = issue.latest_snapshot_event AND delegating_interest_s.issue_id = issue.id AND delegating_interest_s.member_id = ?", options.member_id })

    selector:left_join("direct_supporter_snapshot", "supporter_s", { "supporter_s.event = issue.latest_snapshot_event AND supporter_s.initiative_id = initiative.id AND (supporter_s.member_id = ? OR supporter_s.member_id = delegating_interest_s.delegate_member_ids[array_upper(delegating_interest_s.delegate_member_ids, 1)])", options.member_id })

    selector:add_field("CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN supporter.member_id NOTNULL ELSE supporter_s.member_id NOTNULL END", "supported")
    selector:add_field({ "CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN delegation_info.own_participation AND supporter.member_id NOTNULL ELSE supporter_s.member_id = ? END", options.member_id }, "directly_supported")
    
    selector:add_field("CASE WHEN issue.fully_frozen ISNULL AND issue.closed ISNULL THEN supporter.member_id NOTNULL AND NOT EXISTS(SELECT 1 FROM critical_opinion WHERE critical_opinion.initiative_id = initiative.id AND critical_opinion.member_id = delegation_info.participating_member_id) ELSE supporter_s.satisfied NOTNULL END", "satisfied")

    
    --selector:add_field("", "informed")
    selector:left_join("initiator", nil, { "initiator.initiative_id = initiative.id AND initiator.member_id = ? AND initiator.accepted", options.member_id })
    selector:add_field("initiator.member_id NOTNULL", "initiated")
    
    return selector
  end
}

function Initiative.list:load_everything_for_member_id(member_id)
  if member_id then
    self:load("member_info", { member_id = member_id })
  end
end

function Initiative.object:load_everything_for_member_id(member_id)
  if member_id then
    self:load("member_info", { member_id = member_id })
  end
end




function Initiative:get_search_selector(search_string)
  return self:new_selector()
    :join("draft", nil, "draft.initiative_id = initiative.id")
    :add_field( {'"highlight"("initiative"."name", ?)', search_string }, "name_highlighted")
    :add_where{ '"initiative"."text_search_data" @@ "text_search_query"(?) OR "draft"."text_search_data" @@ "text_search_query"(?)', search_string, search_string }
    :add_group_by('"initiative"."id"')
    :add_group_by('"initiative"."issue_id"')
    :add_group_by('"initiative"."name"')
    :add_group_by('"initiative"."discussion_url"')
    :add_group_by('"initiative"."created"')
    :add_group_by('"initiative"."revoked"')
    :add_group_by('"initiative"."revoked_by_member_id"')
    :add_group_by('"initiative"."admitted"')
    :add_group_by('"initiative"."supporter_count"')
    :add_group_by('"initiative"."informed_supporter_count"')
    :add_group_by('"initiative"."satisfied_supporter_count"')
    :add_group_by('"initiative"."satisfied_informed_supporter_count"')
    :add_group_by('"initiative"."positive_votes"')
    :add_group_by('"initiative"."negative_votes"')
    :add_group_by('"initiative"."direct_majority"')
    :add_group_by('"initiative"."indirect_majority"')
    :add_group_by('"initiative"."schulze_rank"')
    :add_group_by('"initiative"."better_than_status_quo"')
    :add_group_by('"initiative"."worse_than_status_quo"')
    :add_group_by('"initiative"."reverse_beat_path"')
    :add_group_by('"initiative"."multistage_majority"')
    :add_group_by('"initiative"."eligible"')
    :add_group_by('"initiative"."winner"')
    :add_group_by('"initiative"."rank"')
    :add_group_by('"initiative"."suggested_initiative_id"')
    :add_group_by('"initiative"."text_search_data"')
    :add_group_by('"issue"."population"')
    :add_group_by("_initiator.member_id")
    :add_group_by("_supporter.member_id")
    :add_group_by("_direct_supporter_snapshot.member_id")
end

function Initiative:selector_for_updated_drafts(member_id)
  return Initiative:new_selector()
    :join("issue", "_issue_state", "_issue_state.id = initiative.issue_id AND _issue_state.closed ISNULL AND _issue_state.fully_frozen ISNULL")
    :join("current_draft", "_current_draft", "_current_draft.initiative_id = initiative.id")
    :join("supporter", "supporter", { "supporter.member_id = ? AND supporter.initiative_id = initiative.id AND supporter.draft_id < _current_draft.id", member_id })
    :add_where("initiative.revoked ISNULL")
end


function Initiative.object_get:current_draft()
  return Draft:new_selector()
    :add_where{ '"initiative_id" = ?', self.id }
    :add_order_by('"id" DESC')
    :single_object_mode()
    :exec()
end

function Initiative.object_get:shortened_name()
  local name = self.name
  if #name > 100 then
    name = name:sub(1,100) .. "..."
  end
  return name
end

function Initiative.object_get:initiator_names()
  local members = Member:new_selector()
    :join("initiator", nil, "initiator.member_id = member.id")
    :add_where{ "initiator.initiative_id = ?", self.id }
    :add_where{ "initiator.accepted" }
    :exec()

  local member_names = {}
  for i, member in ipairs(members) do
    member_names[#member_names+1] = member.name
  end
  return member_names
end

