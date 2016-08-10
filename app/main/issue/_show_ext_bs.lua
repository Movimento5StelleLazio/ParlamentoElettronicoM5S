local issue = param.get("issue", "table")
local initiative_limit = param.get("initiative_limit", atom.integer)
local for_member = param.get("for_member", "table")
--local for_listing = param.get("for_listing", atom.boolean)
--local for_initiative = param.get("for_initiative", "table")
--local for_initiative_id = for_initiative and for_initiative.id or nil
local state = param.get("state")
local orderby = param.get("orderby") or ""
local desc = param.get("desc", atom.boolean)
local interest = param.get("interest")
local scope = param.get("scope")
--local view = param.get("view")
local list = param.get("list")
local ftl_btns = param.get("ftl_btns", atom.boolean)


local direct_voter
if app.session.member_id then
    direct_voter = issue.member_info.direct_voted
end

ui.container {
    attr = { class = "row well" },
    content = function()
        ui.container {
            attr = { class = "col-md-12" },
            content = function()
                ui.container {
                    attr = { class = "row" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-7 well-blue spaceline paper-green" },
                            content = function()
                                execute.view { module = "issue", view = "info_box", params = { issue = issue } }
                            end
                        }
                    end
                }
                ui.container {
                    attr = { class = "row" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-12 alert alert-simple issue_box paper" },
                            content = function()

                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "alert alert-simple issue_box paper" },
                                            content = function()
                                                ui.tag {
                                                    tag = "strong",
                                                    content = function()
                                                        ui.heading { level = 5, content = "Q" .. issue.id .. " - " .. (issue.title or _ "No title for this issue!") }
                                                    end
                                                }
                                            end
                                        }
                                    end
                                }

                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12" },
                                            content = function()
                                                execute.view { module = "issue", view = "info_data", params = { issue = issue } }
                                            end
                                        }
                                    end
                                }

                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12" },
                                            content = function()
                                            --           local initiatives_selector = issue:get_reference_selector("initiatives")
                                            --          local highlight_string = param.get("highlight_string")
                                            --         if highlight_string then
                                            --          initiatives_selector:add_field( {'"highlight"("initiative"."name", ?)', highlight_string }, "name_highlighted")
                                            --       end
                                                execute.view {
                                                    module = "initiative",
                                                    view = "_list_ext2_bs",
                                                    id = issue.id,
                                                    params = {
                                                        issue = issue,
                                                        --          initiatives_selector = initiatives_selector,
                                                        --                highlight_initiative = for_initiative,
                                                        --               highlight_string = highlight_string,
                                                        --                no_sort = true,
                                                        --                limit = (for_listing or for_initiative) and 5 or nil,
                                                        --                hide_more_initiatives=false,
                                                        --                limit=25,
                                                        list = list,
                                                        --                for_member = for_member
                                                    }
                                                }
                                            end
                                        }
                                    end
                                }
                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12 text-center" },
                                            content = function()
                                                ui.link {
                                                    attr = { id = "issue_see_det_" .. issue.id, class = "btn btn-primary issue_see_det_btn" },
                                                    module = "issue",
                                                    view = "show_ext_bs",
                                                    id = issue.id,
                                                    params = {
                                                        state = state,
                                                        orderby = orderby,
                                                        desc = desc,
                                                        interest = interest,
                                                        scope = scope,
                                                        view = "homepage",
                                                        ftl_btns = ftl_btns
                                                    },
                                                    content = function()
                                                        ui.heading { level = 5, content = _ "SEE DETAILS" }
                                                    end
                                                }
                                            end
                                        }
                                    end
                                }
                            end
                        }
                    end
                }
            end
        }
    end
}
