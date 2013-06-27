local list = param.get("view") or ""
local issues_selector = param.get("selector", "table")
local member = param.get("for_member", "table") or app.session.member
local state = param.get("state")
local orderby = param.get("orderby") or ""
local desc =  param.get("desc", atom.boolean)
local interest = param.get("interest")
local scope = param.get("scope")
local list = param.get("list")
local ftl_btns = param.get("ftl_btns",atom.boolean)


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
          elseif list == "created" then
             ui.heading{level=4, content =_"You didn't create any issue yet."}
          end
        end }
      end }
    end

    ui.container{ attr = { class = "issues" }, content = function()
      for i, issue in ipairs(issues) do
        execute.view{ module = "issue", view = "_show_ext_bs", 
          params = {
            issue = issue, 
            for_listing = true, 
            for_member = member,
            state = state,
            orderby = orderby,
            desc = desc,
            interest = interest,
            scope = scope,
            view = view,
            ftl_btns = ftl_btns
          } 
        }
      end
    end }
  end 
}
