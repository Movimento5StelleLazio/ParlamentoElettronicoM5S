local issues_selector = param.get("selector", "table")
local member = param.get("for_member", "table") or app.session.member

ui.paginate{
  per_page = tonumber(param.get("per_page") or 25),
  selector = issues_selector,
  content = function()
    local issues = issues_selector:exec()
    issues:load_everything_for_member_id(member and member.id or nil)

    if #issues == 0 then
      ui.container{ attr = { class = "row-fluid" }, content = function()
        ui.container{ attr = { class = "span12 text-center" }, content = function()
          ui.heading{level=4, content =_"There are no issue that match the selection criteria."}
        end }
      end }
    end


    ui.container{ attr = { class = "issues" }, content = function()
      for i, issue in ipairs(issues) do
        execute.view{ module = "issue", view = "_show_ext2_bs", params = {
          issue = issue, for_listing = true, for_member = member
         } }
      end
    end }
  end 
}
