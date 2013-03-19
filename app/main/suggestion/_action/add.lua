local tmp = db:query({ "SELECT text_entries_left FROM member_contingent_left WHERE member_id = ? AND NOT polling", app.session.member.id }, "opt_object")
if not tmp or tmp.text_entries_left < 1 then
  slot.put_into("error", _"Sorry, you have reached your personal flood limit. Please be slower...")
  return false
end

local initiative = Initiative:by_id(param.get("initiative_id", atom.integer))
if not app.session.member:has_voting_right_for_unit_id(initiative.issue.area.unit_id) then
  error("access denied")
end


local name = param.get("name")
local name = util.trim(name)

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

local suggestion = Suggestion:new()

suggestion.author_id = app.session.member.id
suggestion.name = name
suggestion.formatting_engine = formatting_engine
param.update(suggestion, "content", "initiative_id")
suggestion:save()

-- TODO important m1 selectors returning result _SET_!
local issue = suggestion.initiative:get_reference_selector("issue"):for_share():single_object_mode():exec()

if issue.closed then
  slot.put_into("error", _"This issue is already closed.")
  return false
elseif issue.half_frozen then 
  slot.put_into("error", _"This issue is already frozen.")
  return false
elseif 
  (issue.half_frozen and issue.phase_finished) or
  (not issue.accepted and issue.phase_finished) 
then
  slot.put_into("error", _"Current phase is already closed.")
  return false
end

local opinion = Opinion:new()

opinion.suggestion_id = suggestion.id
opinion.member_id     = app.session.member.id
opinion.degree        = param.get("degree", atom.integer)
opinion.fulfilled     = false

opinion:save()

slot.put_into("notice", _"Your suggestion has been added")