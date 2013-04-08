local issue = param.get("issue", "table")
local initiatives_selector = param.get("initiatives_selector", "table")

local initiatives
if issue then
  initiatives = issue.initiatives
else
  initiatives = initiatives_selector:exec()
  initiatives:load_everything_for_member_id(app.session.member_id)
end

local highlight_initiative = param.get("highlight_initiative", "table")

local for_member = param.get("for_member", "table") or app.session.member

local limit = param.get("limit", atom.number)
local hide_more_initiatives = param.get("hide_more_initiatives", atom.boolean)

local more_initiatives_count
if limit then
  if #initiatives > limit then
    more_initiatives_count = #initiatives - limit
  end
  initiatives = {}
  for i, initiative in ipairs(issue.initiatives) do
    if i <= limit then
      initiatives[#initiatives+1] = initiative
    end
  end
end

local name = "initiative_list"
if issue then
  name = "issue_" .. tostring(issue.id) ..  "_initiative_list"
end

ui.add_partial_param_names{ name }

if highlight_initiative then
  local highlight_initiative_found
  for i, initiative in ipairs(initiatives) do
    if initiative.id == highlight_initiative.id then
      highhighlight_initiative_found = true
    end
  end
  if not highhighlight_initiative_found then
    initiatives[#initiatives+1] = highlight_initiative
    if more_initiatives_count then
      more_initiatives_count = more_initiatives_count - 1
    end
  end
end
for i, initiative in ipairs(initiatives) do
  execute.view{
    module = "initiative",
    view = "_list_element",
    params = {
      initiative = initiative,
      selected = highlight_initiative and highlight_initiative.id == initiative.id or nil,
      for_member = for_member
    }
  }
end

if not hide_more_initiatives and more_initiatives_count and more_initiatives_count > 0 then
  local text
  if more_initiatives_count == 1 then
    text = _("and one more initiative")
  else
    text = _("and #{count} more initiatives", { count = more_initiatives_count })
  end
  ui.link{
    attr = { class = "more_initiatives_link" },
    content = text,
    module = "issue",
    view = "show",
    id = issue.id,
  }
end
