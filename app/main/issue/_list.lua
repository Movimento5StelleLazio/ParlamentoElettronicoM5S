local issues_selector = param.get("issues_selector", "table")
local member = param.get("for_member", "table") or app.session.member
local for_member = param.get("for_member", "table")
local for_state = param.get("for_state")
local for_unit = param.get("for_unit", atom.boolean)
local for_area = param.get("for_area", atom.boolean)


if for_state == "open" then
  issues_selector:add_where("issue.closed ISNULL")
elseif for_state == "closed" then
  issues_selector:add_where("issue.closed NOTNULL")
end

ui.add_partial_param_names{
  "filter",
  "filter_open",
  "filter_voting",
  "filter_interest",
  "issue_list" 
}

local filters = execute.load_chunk{module="issue", chunk="_filters.lua", params = {
  member = member, for_member = for_member, state = for_state, for_unit = for_unit, for_area = for_area
}}

filters.content = function()
  ui.paginate{
    per_page = tonumber(param.get("per_page") or 25),
    selector = issues_selector,
    content = function()
      local highlight_string = param.get("highlight_string", "string")
      local issues = issues_selector:exec()
      issues:load_everything_for_member_id(member and member.id or nil)

      ui.container{ attr = { class = "issues" }, content = function()

        for i, issue in ipairs(issues) do

          execute.view{ module = "issue", view = "_show", params = {
            issue = issue, for_listing = true, for_member = for_member
          } }
          
        end
      end }
    end
  }
end

filters.opened = true
filters.selector = issues_selector

if param.get("no_filter", atom.boolean) then
  filters.content()
else
  ui.filters(filters)
end
