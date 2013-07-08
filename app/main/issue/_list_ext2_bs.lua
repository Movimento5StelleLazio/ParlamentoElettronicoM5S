local issues_selector = param.get("selector", "table")
local member = param.get("for_member", "table") or app.session.member
local state = param.get("state")
local orderby = param.get("orderby") or ""
local desc =  param.get("desc", atom.boolean)
local interest = param.get("interest")
local scope = param.get("scope")
local view = param.get("view")
local list = param.get("list")
local for_details = param.get("for_details",atom.boolean)
local ftl_btns = param.get("ftl_btns",atom.boolean)


if list == "proposals" then
  issues_selector:join("initiative", nil, "initiative.issue_id = issue.id")
  issues_selector:join("current_draft", nil, {"current_draft.initiative_id = initiative.id AND current_draft.author_id = ?", app.session.member.id })
end

ui.paginate{
  per_page = tonumber(param.get("per_page") or 25),
  selector = issues_selector,
  content = function()
    local issues = issues_selector:exec()
    issues:load_everything_for_member_id(member and member.id or nil)

    if #issues == 0 then
      ui.container{ attr = { class = "row-fluid" }, content = function()
        ui.container{ attr = { class = "span12 text-center" }, content = function()
          if list == "voted" then
             ui.heading{level=4, content =_"You didn't vote any issue yet."}
          elseif list == "proposals" then
             ui.heading{level=4, content =_"You didn't create any issue yet."}
          else
             ui.heading{level=4, content =_"There are no issues that match the selection criteria."}
          end
        end }
      end }
    end
    
    local target = "_show_ext2_bs"
    if list == "voted" or list == "proposals" then
      target = "_show_ext_bs"
    else
      target = "_show_ext2_bs"
    end

    ui.container{ attr = { class = "issues" }, content = function()
      for i, issue in ipairs(issues) do
        execute.view{ module = "issue", view = target,
          params = {
            issue = issue,
    --        for_listing = true,
            for_member = member,
            state = state,
            orderby = orderby,
            desc = desc,
            interest = interest,
            scope = scope,
            view = view,
            list = list,
            ftl_btns = ftl_btns
          }
        }
      end
    end }

  end 
}
