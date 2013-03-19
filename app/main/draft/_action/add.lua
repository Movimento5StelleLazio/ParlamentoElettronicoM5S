local initiative = Initiative:by_id(param.get("initiative_id", atom.integer))

-- TODO important m1 selectors returning result _SET_!
local issue = initiative:get_reference_selector("issue"):for_share():single_object_mode():exec()

if issue.closed then
  slot.put_into("error", _"This issue is already closed.")
  return false
elseif issue.half_frozen then 
  slot.put_into("error", _"This issue is already frozen.")
  return false
elseif issue.phase_finished then
  slot.put_into("error", _"Current phase is already closed.")
  return false
end

local initiator = Initiator:by_pk(initiative.id, app.session.member.id)
if not initiator or not initiator.accepted then
  error("access denied")
end

local tmp = db:query({ "SELECT text_entries_left FROM member_contingent_left WHERE member_id = ? AND polling = ?", app.session.member.id, initiative.polling }, "opt_object")
if not tmp or tmp.text_entries_left < 1 then
  slot.put_into("error", _"Sorry, you have reached your personal flood limit. Please be slower...")
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
  return false
end

local draft = Draft:new()
draft.author_id = app.session.member.id
draft.initiative_id = initiative.id
draft.formatting_engine = formatting_engine
draft.content = param.get("content")
draft:save()

local supporter = Supporter:by_pk(initiative.id, app.session.member.id)

if supporter then
  supporter.draft_id = draft.id
  supporter:save()
end

draft:render_content()

slot.put_into("notice", _"New draft has been added to initiative")

