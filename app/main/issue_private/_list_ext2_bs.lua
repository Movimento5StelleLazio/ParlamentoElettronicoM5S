local issues_selector = param.get("selector", "table")
local member = param.get("for_member", "table") or app.session.member
local state = param.get("state")
local orderby = param.get("orderby")
local desc = param.get("desc", atom.boolean)
local interest = param.get("interest")
local scope = param.get("scope")
local view = param.get("view")
local list = param.get("list")
local for_details = param.get("for_details", atom.boolean)
local ftl_btns = param.get("ftl_btns", atom.boolean)


if list == "proposals" then
    issues_selector:join("initiative", nil, "initiative.issue_id = issue.id")
    issues_selector:join("current_draft", nil, { "current_draft.initiative_id = initiative.id AND current_draft.author_id = ?", app.session.member.id })
    issues_selector:add_where("issue.closed ISNULL")
end

issues_selector:join("area", nil, "area.id = issue.area_id")
issues_selector:join("unit", nil, "unit.id = area.unit_id AND NOT unit.public")

ui.paginate {
    per_page = tonumber(param.get("per_page") or 5),
    selector = issues_selector,
    content = function()
        local issues = issues_selector:exec()
        issues:load_everything_for_member_id(member and member.id or nil)

        if #issues == 0 then
            ui.container {
                attr = { class = "row" },
                content = function()
                    ui.container {
                        attr = { class = "col-md-12 text-center" },
                        content = function()
                            if list == "voted" then
                                ui.heading { level = 4, content = _ "You didn't vote any issue yet." }
                            elseif list == "proposals" then
                                ui.heading { level = 4, content = _ "You didn't create any issue yet." }
                            else
                                ui.heading { level = 4, content = _ "There are no issues that match the selection criteria." }
                            end
                        end
                    }
                end
            }
        end

        ui.container {
            attr = { class = "" },
            content = function()
                for i, issue in ipairs(issues) do
                    execute.view {
                        module = "issue_private",
                        view = "_show_ext2_bs",
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
            end
        }
    end
}
