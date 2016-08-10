local for_details = param.get("for_details", "boolean") or false
local init_ord = param.get("init_ord") or "event"
local list = param.get("list")

local initiatives = Initiative:new_selector()

initiatives:reset_fields()
initiatives:add_where { "initiative.issue_id = ?", tonumber(param.get_id()) }
initiatives:add_field("initiative.issue_id")
initiatives:add_field("initiative.id")
initiatives:add_field("initiative.name")
initiatives:add_field("initiative.polling")
initiatives:add_field("initiative.discussion_url")
initiatives:add_field("initiative.created")
initiatives:add_field("initiative.revoked")
initiatives:add_field("initiative.revoked_by_member_id")
initiatives:add_field("initiative.suggested_initiative_id")
initiatives:add_field("initiative.admitted")
initiatives:add_field("initiative.supporter_count")
initiatives:add_field("initiative.informed_supporter_count")
initiatives:add_field("initiative.satisfied_supporter_count")
initiatives:add_field("initiative.satisfied_informed_supporter_count")
initiatives:add_field("initiative.positive_votes")
initiatives:add_field("initiative.negative_votes")
initiatives:add_field("initiative.direct_majority")
initiatives:add_field("initiative.indirect_majority")
initiatives:add_field("initiative.schulze_rank")
initiatives:add_field("initiative.better_than_status_quo")
initiatives:add_field("initiative.worse_than_status_quo")
initiatives:add_field("initiative.reverse_beat_path")
initiatives:add_field("initiative.multistage_majority")
initiatives:add_field("initiative.eligible")
initiatives:add_field("initiative.winner")
initiatives:add_field("initiative.rank")
initiatives:add_field("initiative.text_search_data")
initiatives:add_field("initiative.harmonic_weight")
initiatives:add_field("initiative.final_suggestion_order_calculated")
initiatives:add_field("initiative.title")
initiatives:add_field("initiative.brief_description")
initiatives:add_field("initiative.competence_fields")
initiatives:add_field("initiative.author_type")
initiatives:add_field("max(event.id)", "last_event_id")
initiatives:left_join("event", nil, "event.initiative_id = initiative.id")
initiatives:add_group_by("initiative.issue_id")
initiatives:add_group_by("initiative.id")
initiatives:add_group_by("initiative.name")
initiatives:add_group_by("initiative.polling")
initiatives:add_group_by("initiative.discussion_url")
initiatives:add_group_by("initiative.created")
initiatives:add_group_by("initiative.revoked")
initiatives:add_group_by("initiative.revoked_by_member_id")
initiatives:add_group_by("initiative.suggested_initiative_id")
initiatives:add_group_by("initiative.admitted")
initiatives:add_group_by("initiative.supporter_count")
initiatives:add_group_by("initiative.informed_supporter_count")
initiatives:add_group_by("initiative.satisfied_supporter_count")
initiatives:add_group_by("initiative.satisfied_informed_supporter_count")
initiatives:add_group_by("initiative.positive_votes")
initiatives:add_group_by("initiative.negative_votes")
initiatives:add_group_by("initiative.direct_majority")
initiatives:add_group_by("initiative.indirect_majority")
initiatives:add_group_by("initiative.schulze_rank")
initiatives:add_group_by("initiative.better_than_status_quo")
initiatives:add_group_by("initiative.worse_than_status_quo")
initiatives:add_group_by("initiative.reverse_beat_path")
initiatives:add_group_by("initiative.multistage_majority")
initiatives:add_group_by("initiative.eligible")
initiatives:add_group_by("initiative.winner")
initiatives:add_group_by("initiative.rank")
initiatives:add_group_by("initiative.text_search_data")
initiatives:add_group_by("initiative.harmonic_weight")
initiatives:add_group_by("initiative.final_suggestion_order_calculated")
initiatives:add_group_by("initiative.title")
initiatives:add_group_by("initiative.brief_description")
initiatives:add_group_by("initiative.competence_fields")
initiatives:add_group_by("initiative.author_type")


if init_ord == "supporters" then
    initiatives:add_order_by("supporter_count DESC")
elseif init_ord == "event" then
    initiatives:add_order_by("last_event_id DESC")
end

if list == "proposals" then
    initiatives:join("current_draft", nil, { "current_draft.initiative_id = initiative.id AND current_draft.author_id = ?", app.session.member_id })
end

if list == "voted" then
    initiatives:join("vote", nil, { "vote.initiative_id = initiative.id AND vote.issue_id = ?", tonumber(param.get_id()) })
end

for i, initiative in ipairs(initiatives:exec()) do
    execute.view {
        module = "initiative",
        view = "_list_element_ext2_bs",
        params = {
            for_details = for_details,
            initiative = initiative
        }
    }
end
