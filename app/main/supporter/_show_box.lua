local initiative = param.get("initiative", "table") or Initiative:by_id(param.get_id())


--local initiative = param.get("initiative", "table")
local supporter = Supporter:by_pk(initiative.id, app.session.member.id)

local partial = {
    routing = {
        default = {
            mode = "redirect",
            module = "initiative",
            view = "show_support",
            id = initiative.id
        }
    }
}

local routing = {
    default = {
        mode = "redirect",
        module = request.get_module(),
        view = request.get_view(),
        id = param.get_id_cgi(),
        params = param.get_all_cgi()
    }
}
ui.container {
    attr = { class = "col-md-4 spaceline" },
    content = function()
        ui.container {
            attr = { class = "row" },
            content = function()
                if not initiative.issue.fully_frozen and not initiative.issue.closed then
                    if supporter then
                        if not supporter:has_critical_opinion() then
                            ui.tag {
                                attr = { class = "col-md-7" },
                                content = function()
                                    ui.image {
                                        attr = { style = "height: 70px" },
                                        static = "thumb_up.png"
                                    }
                                    if initiative.issue.closed then
                                        slot.put(_ "You were supporter")
                                    else
                                        slot.put(_ "You are supporter")
                                    end
                                end
                            }
                        else
                            ui.tag {
                                attr = { class = "col-md-7 potential_supporter" },
                                content = function()
                                    ui.image {
                                        static = "thumb_up.png"
                                    }
                                    if initiative.issue.closed then
                                        slot.put(_ "You were potential supporter")
                                    else
                                        slot.put(_ "You are potential supporter")
                                    end
                                end
                            }
                        end
                        --slot.put(" (")
                        ui.link {
                            attr = { class = "col-md-5 label label-inverse fixclick spaceline" },
                            text = _ "Withdraw",
                            module = "initiative",
                            action = "remove_support",
                            id = initiative.id,
                            routing = routing,
                            partial = partial
                        }
                        --slot.put(") ")
                    elseif not initiative.revoked and app.session.member:has_voting_right_for_unit_id(initiative.issue.area.unit_id) then
                        local params = param.get_all_cgi()
                        params.dyn = nil
                        ui.link {
                            attr = { class = "btn btn-primary btn_size_fix fixclick h3" },
                            text = _ "Support this initiative",
                            module = "initiative",
                            action = "add_support",
                            id = initiative.id,
                            routing = routing,
                            partial = partial
                        }
                        slot.put(" ")
                    end
                end
            end
        }
    end
}

ui.container {
    attr = { class = "col-md-4 spaceline" },
    content = function()
        if not initiative.issue.closed then
            --[[ if not initiative.issue.fully_frozen and app.session.member:has_voting_right_for_unit_id(initiative.issue.area.unit_id) then
               slot.put(" &middot; ")
             end ]]
            local ignored_initiative = IgnoredInitiative:by_pk(app.session.member.id, initiative.id)
            if ignored_initiative then
                ui.tag {
                    content = _ "You are ignoring"
                }
                --    slot.put(" (")
                ui.link {
                    attr = { class = "btn btn-primary btn_size_fix fixclick h3" },
                    text = _ "Non ignorare",
                    module = "initiative",
                    action = "update_ignore",
                    id = initiative.id,
                    params = { delete = true },
                    routing = {
                        default = {
                            mode = "redirect",
                            module = request.get_module(),
                            view = request.get_view(),
                            id = param.get_id_cgi(),
                            params = param.get_all_cgi()
                        }
                    }
                }
                --    slot.put(")")
            else
                ui.link {
                    attr = { class = "btn btn-primary btn_size_fix fixclick h3" },
                    text = _ "Ignore initiative",
                    module = "initiative",
                    action = "update_ignore",
                    id = initiative.id,
                    routing = {
                        default = {
                            mode = "redirect",
                            module = request.get_module(),
                            view = request.get_view(),
                            id = param.get_id_cgi(),
                            params = param.get_all_cgi()
                        }
                    }
                }
            end
        end
    end
}
