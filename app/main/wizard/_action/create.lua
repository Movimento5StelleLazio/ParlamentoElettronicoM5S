
if param.get("indietro")=="true" then

return request.redirect{
  module = "wizard",
  view = "show_ext_bs",
  id=issue.id
}


end

local issue
local area

local issue_id = param.get("issue_id", atom.integer)

  local area_id = param.get("area_id", atom.integer)
  area = Area:new_selector():add_where{"id=?",area_id}:single_object_mode():exec()
  if not area.active then
    slot.put_into("error", "Invalid area.")
    return false
  end

if not app.session.member:has_voting_right_for_unit_id(area.unit_id) then
  error("access denied")
end

local policy_id = param.get("policy_id_hidden", atom.integer)
local policy
if policy_id then
  policy = Policy:by_id(policy_id)
end

if not issue then
  if policy_id == -1 then
    slot.put_into("error", _"Please choose a policy")
    return false
  end
  if not policy.active then
    slot.put_into("error", "Invalid policy.")
    return false
  end
  if policy.polling and not app.session.member:has_polling_right_for_unit_id(area.unit_id) then
    error("no polling right for this unit")
  end
  
  if not area:get_reference_selector("allowed_policies")
    :add_where{ "policy.id = ?", policy_id }
    :optional_object_mode()
    :exec()
  then
    error("policy not allowed")
  end
end

local is_polling = (issue and param.get("polling", atom.boolean)) or (policy and policy.polling) or false

local tmp = db:query({ "SELECT text_entries_left, initiatives_left FROM member_contingent_left WHERE member_id = ? AND polling = ?", app.session.member.id, is_polling }, "opt_object")
if not tmp or tmp.initiatives_left < 1 then
  slot.put_into("error", _"Sorry, your contingent for creating initiatives has been used up. Please try again later.")
  return false
end
if tmp and tmp.text_entries_left < 1 then
  slot.put_into("error", _"Sorry, you have reached your personal flood limit. Please be slower...")
  return false
end

local initiative_title = param.get("initiative_title")

local name = util.trim(initiative_title)

if #name < 3 then
  slot.put_into("error", _"This title is really too short!")
  return false
end

local formatting_engine = param.get("formatting_engine")

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
  issue.title=param.get("issue_title")
  issue.brief_description=param.get("issue_brief_description")
  issue.problem_description=param.get("problem_description")
  issue.aim_description=param.get("aim_description")
  
  
  issue.keywords=param.get("issue_keywords")
  
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
  
  local issue=issue:save()

  if config.etherpad then
    local result = net.curl(
      config.etherpad.api_base 
      .. "api/1/createGroupPad?apikey=" .. config.etherpad.api_key
      .. "&groupID=" .. config.etherpad.group_id
      .. "&padName=Issue" .. tostring(issue.id)
      .. "&text=" .. request.get_absolute_baseurl() .. "issue/show/" .. tostring(issue.id) .. ".html"
    )
  end
end

if param.get("polling", atom.boolean) and app.session.member:has_polling_right_for_unit_id(area.unit_id) then
  initiative.polling = true
end
initiative.issue_id = issue.id
initiative.name = name
trace.debug("line 151")
initiative.title=param.get("initiative_title")
initiative.brief_description=param.get("initiative_brief_description")
initiative.competence_fields=param.get("technical_area_1")
 
trace.debug("line 156")
local proposer1=param.get("proposer_hidden_1",atom.boolean)
if proposer1 then
initiative.author_type="other"
end

local proposer2=param.get("proposer_hidden_2",atom.boolean)
if proposer2 then
initiative.author_type="elected"
end

local proposer3=param.get("proposer_hidden_3",atom.boolean)
if proposer3 then
initiative.author_type="other"
end

trace.debug("line 168")
param.update(initiative, "discussion_url")
trace.debug("line 170")
initiative:save()


local draft = Draft:new()
draft.initiative_id = initiative.id
draft.formatting_engine = formatting_engine
draft.content = param.get("draft")
draft.author_id = app.session.member.id
draft:save()

local initiator = Initiator:new()
initiator.initiative_id = initiative.id
initiator.member_id = app.session.member.id
initiator.accepted = true
initiator:save()

if not is_polling then
  local supporter = Supporter:new()
  supporter.initiative_id = initiative.id
  supporter.member_id = app.session.member.id
  supporter.draft_id = draft.id
  supporter:save()
end

slot.put_into("notice", _"Initiative successfully created")

 
--[[
request.redirect{
  module = "index",
  view = "homepage_bs",
  id = initiative.id
}
]]--
 
 request.redirect{
  module = "issue",
  view = "show_ext_bs",
  id=issue.id
}

