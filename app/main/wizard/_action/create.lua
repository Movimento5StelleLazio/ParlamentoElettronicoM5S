local issue
local area

local issue_id = param.get("issue_id", atom.integer) or 0
local area_id = param.get("area_id", atom.integer)
local unit_id = param.get("unit_id", atom.integer)
local policy_id = param.get("policy_id", atom.integer) or 0
local issue_title = param.get("issue_title", atom.string) or ""
local issue_brief_description = param.get("issue_brief_description", atom.string) or ""
local issue_keywords = param.get("issue_keywords", atom.string) or ""
local problem_description = param.get("problem_description", atom.string) or ""
local aim_description = param.get("aim_description", atom.string) or ""
local initiative_title = param.get("initiative_title", atom.string) or ""
local initiative_brief_description = param.get("initiative_brief_description", atom.string) or ""
local draft_text = param.get("draft", atom.string) or ""
local technical_areas = param.get("technical_areas", atom.string) or tostring(area_id)
local proposer1 = param.get("proposer1", atom.boolean) or false
local proposer2 = param.get("proposer2", atom.boolean) or false
local proposer3 = param.get("proposer3", atom.boolean) or false
local formatting_engine = param.get("formatting_engine")
local resource = param.get("resource")

trace.debug("issue_id: " .. tostring(issue_id))
trace.debug("area_id: " .. tostring(area_id))
trace.debug("unit_id: " .. tostring(unit_id))
trace.debug("policy_id: " .. tostring(policy_id))
trace.debug("issue_title: " .. issue_title)
trace.debug("issue_brief_description: " .. issue_brief_description)
trace.debug("issue_keywords: " .. issue_keywords)
trace.debug("problem_description: " .. problem_description)
trace.debug("aim_description: " .. aim_description)
trace.debug("initiative_title: " .. initiative_title)
trace.debug("initiative_brief_description: " .. initiative_brief_description)
trace.debug("draft: " .. draft_text)
trace.debug("technical_areas: " .. tostring(technical_areas))
trace.debug("proposer1: " .. tostring(proposer1))
trace.debug("proposer2: " .. tostring(proposer2))
trace.debug("proposer3: " .. tostring(proposer3))

if area_id then
    area = Area:by_id(area_id)
    if not area.active then
        slot.put_into("error", "Invalid area.")
        return false
    end
end

if issue_id then
    issue = Issue:by_id(issue_id)
end

if not app.session.member:has_voting_right_for_unit_id(area.unit_id) then
    error("access denied")
end

local policy
if policy_id then
    policy = Policy:by_id(policy_id)
end

if not issue then
    if policy_id == -1 then
        slot.put_into("error", _ "Please choose a policy")
        return false
    end
    if not policy.active then
        slot.put_into("error", "Invalid policy.")
        return false
    end
    if policy.polling and not app.session.member:has_polling_right_for_unit_id(area.unit_id) then
        error("no polling right for this unit")
    end

    if not area:get_reference_selector("allowed_policies"):add_where { "policy.id = ?", policy_id }:optional_object_mode():exec()
    then
        error("policy not allowed")
    end
end

local is_polling = (issue and param.get("polling", atom.boolean)) or (policy and policy.polling) or false

local tmp = db:query({ "SELECT text_entries_left, initiatives_left FROM member_contingent_left WHERE member_id = ? AND polling = ?", app.session.member.id, is_polling }, "opt_object")
if (not tmp or tmp.initiatives_left < 1) and not (app.session.member.elected or app.session.member.admin) then
    slot.put_into("error", _ "Sorry, your contingent for creating initiatives has been used up. Please try again later.")
    return false
end
if (tmp and tmp.text_entries_left < 1) and not (app.session.member.elected or app.session.member.admin) then
    slot.put_into("error", _ "Sorry, you have reached your personal flood limit. Please be slower...")
    return false
end

local name = util.trim(initiative_title)

if #name < 3 then
    slot.put_into("error", _ "This title is really too short!")
    return false
end

local formatting_engine_valid = false
for fe, dummy in pairs(config.formatting_engine_executeables) do
    if formatting_engine == fe then
        formatting_engine_valid = true
    end
end
if not formatting_engine_valid then
    error("invalid formatting engine!")
end

if param.get("preview") then
    return
end


local initiative = Initiative:new()

if not issue then
    issue = Issue:new()
    issue.area_id = area.id
    issue.policy_id = policy_id
    issue.member_id = app.session.member_id
    issue.title = issue_title
    issue.brief_description = issue_brief_description
    issue.problem_description = problem_description
    issue.aim_description = aim_description

    if policy.polling then
        issue.accepted = 'now'
        issue.state = 'discussion'
        initiative.polling = true

        if policy.free_timeable then
            local free_timing_string = util.trim(param.get("free_timing"))
            local available_timings
            if config.free_timing and config.free_timing.available_func then
                available_timings = config.free_timing.available_func(policy)
                if available_timings == false then
                    error("error in free timing config")
                end
            end
            if available_timings then
                local timing_available = false
                for i, available_timing in ipairs(available_timings) do
                    if available_timing.id == free_timing_string then
                        timing_available = true
                    end
                end
                if not timing_available then
                    error('Invalid timing')
                end
            end
            local timing = config.free_timing.calculate_func(policy, free_timing_string)
            if not timing then
                error("error in free timing config")
            end
            issue.discussion_time = timing.discussion
            issue.verification_time = timing.verification
            issue.voting_time = timing.voting
        end
    end

    local issue = issue:save()
    issue_id = issue.id

    -- Keyword registration
    function string:split(sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields + 1] = c end)
        return fields
    end

    -- issue keywords
    trace.debug("non-technical keywords: " .. issue_keywords)
    for i, k in ipairs(param.get("issue_keywords"):split(",")) do
        local keyword = Keyword:new_selector():add_where { "name LIKE ? AND NOT technical_keyword", k }:join("issue_keyword", nil, { "keyword.id = issue_keyword.keyword_id AND issue_keyword.issue_id = ?", issue_id }):add_group_by("keyword.id"):add_order_by("keyword.id"):optional_object_mode():exec()

        if not keyword then
            trace.debug("creo nuova keyword")
            keyword = Keyword:new()
            keyword.name = k
            keyword.technical_keyword = false
            keyword:save()
            trace.debug("keyword creata con id " .. tostring(keyword.id) .. "; creo nuova issue_keyword")
            local issue_keyword = IssueKeyword:new()
            issue_keyword.issue_id = issue_id
            issue_keyword.keyword_id = keyword.id
            issue_keyword:save()
            trace.debug("nuova issue_keyword creata per la coppia keyword_id: " .. tostring(keyword.id) .. "; issue_id: " .. tostring(issue_id))
        elseif keyword then
            trace.debug("uso la keyword di id " .. tostring(keyword.id))
            local issue_keyword = IssueKeyword:by_pk(issue_id, keyword.id)
            if not issue_keyword then
                trace.debug("creo nuova issue_keyword")
                local issue_keyword = IssueKeyword:new()
                issue_keyword.issue_id = issue_id
                issue_keyword.keyword_id = keyword.id
                issue_keyword = issue_keyword:save()
                trace.debug("nuova issue_keyword creata per la coppia keyword_id: " .. tostring(keyword.id) .. "; issue_id: " .. tostring(issue_id))
            end
        else
            slot.put_into("error", _ "Failed to save keywords for issue")
        end
    end

    if config.etherpad then
        local result = net.curl(config.etherpad.api_base
                .. "api/1/createGroupPad?apikey=" .. config.etherpad.api_key
                .. "&groupID=" .. config.etherpad.group_id
                .. "&padName=Issue" .. tostring(issue.id)
                .. "&text=" .. request.get_absolute_baseurl() .. "issue/show/" .. tostring(issue.id) .. ".html")
    end
end

if param.get("polling", atom.boolean) and app.session.member:has_polling_right_for_unit_id(area.unit_id) then
    initiative.polling = true
end
initiative.issue_id = issue.id
initiative.name = name
initiative.title = initiative_title
initiative.brief_description = initiative_brief_description
initiative.competence_fields = technical_areas

--local proposer1=param.get("proposer1",atom.boolean)
if proposer1 then
    initiative.author_type = "citizens"
end

--local proposer2=param.get("proposer2",atom.boolean)
if proposer2 then
    initiative.author_type = "elected"
end

--local proposer3=param.get("proposer3",atom.boolean)
if proposer3 then
    initiative.author_type = "other"
end

param.update(initiative, "discussion_url")
initiative = initiative:save()

local draft = Draft:new()
draft.initiative_id = initiative.id
draft.formatting_engine = formatting_engine
draft.content = draft_text
draft.author_id = app.session.member.id
draft = draft:save()

local initiator = Initiator:new()
initiator.initiative_id = initiative.id
initiator.member_id = app.session.member.id
initiator.accepted = true
initiator = initiator:save()

if not is_polling then
    local supporter = Supporter:new()
    supporter.initiative_id = initiative.id
    supporter.member_id = app.session.member.id
    supporter.draft_id = draft.id
    supporter:save()
end

-- Keyword registration
function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields + 1] = c end)
    return fields
end

-- initiative keywords
trace.debug("technical_areas " .. technical_areas)
for i, k in ipairs(param.get("technical_areas"):split(",")) do
    trace.debug("t-keyword " .. k)
    local keyword = Keyword:new_selector():add_where { "name LIKE ? AND technical_keyword", k }:join("issue_keyword", nil, { "keyword.id = issue_keyword.keyword_id AND issue_keyword.issue_id = ?", issue_id }):add_group_by("keyword.id"):add_order_by("keyword.id"):optional_object_mode():exec()

    if not keyword then
        trace.debug("creo nuova keyword")
        keyword = Keyword:new()
        keyword.name = k
        keyword.technical_keyword = true
        keyword:save()
        trace.debug("keyword creata con id " .. tostring(keyword.id) .. "; creo nuova issue_keyword")
        local issue_keyword = IssueKeyword:new()
        issue_keyword.issue_id = issue_id
        issue_keyword.keyword_id = keyword.id
        issue_keyword:save()
        trace.debug("nuova issue_keyword creata per la coppia keyword_id: " .. tostring(keyword.id) .. "; issue_id: " .. tostring(issue_id))
    elseif keyword then
        trace.debug("uso la keyword di id " .. tostring(keyword.id))
        local issue_keyword = IssueKeyword:by_pk(issue_id, keyword.id)
        if not issue_keyword then
            trace.debug("creo nuova issue_keyword")
            local issue_keyword = IssueKeyword:new()
            issue_keyword.issue_id = issue_id
            issue_keyword.keyword_id = keyword.id
            issue_keyword = issue_keyword:save()
            trace.debug("nuova issue_keyword creata per la coppia keyword_id: " .. tostring(keyword.id) .. "; issue_id: " .. tostring(issue_id))
        end
    else
        slot.put_into("error", _ "Failed to save keywords for issue")
    end
end
-- end of keywords

-- video presentation
if resource then
    local video = Resource:new()
    video.url = resource
    video.initiative_id = initiative.id
    video.type = "video"
    video.title = "video presentation of initiative p" .. tostring(initiative.id)
    video:save()
end

slot.put_into("notice", _ "Initiative successfully created")

request.redirect {
    module = "issue",
    view = "show_ext_bs",
    params = { view = "homepage" },
    id = issue.id
}

