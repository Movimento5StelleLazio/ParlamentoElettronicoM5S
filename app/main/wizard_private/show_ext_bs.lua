slot.set_layout("custom")

local unit_id = param.get_id()
local filter = param.get("filter")

if not app.session.member_id then
    return false
end

local member = app.session.member
areas_selector = Area:build_selector { active = true }
areas_selector:add_order_by("member_weight DESC")

if filter == "my_areas" then
    areas_selector:join("membership", nil, { "membership.area_id = area.id AND membership.member_id = ?", member.id })
else
    areas_selector:join("privilege", nil, { "privilege.unit_id = area.unit_id AND privilege.member_id = ? AND privilege.voting_right", member.id })
end

areas_selector:join("unit", nil, "unit.id = area.unit_id' ")

ui.container {
    attr = { class = "row-fluid" },
    content = function()
        ui.container {
            attr = { class = "well span12" },
            content = function()
                ui.container {
                    attr = { class = "row-fluid" },
                    content = function()
                        ui.container {
                            attr = { class = "span3" },
                            content = function()
                                ui.link {
                                    attr = { class = "btn btn-primary btn-large large_btn table-cell" },
                                    module = "index", --non sono convinto che sia questo il back corretto
                                    view = "homepage_bs",
                                    content = function()
                                        ui.heading {
                                            level = 3,
                                            attr = { class = "fittext_back_btn" },
                                            content = function()
                                                ui.image { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" }
                                                slot.put(_ "Back to previous page")
                                            end
                                        }
                                    end
                                }
                            end
                        }
                        ui.container {
                            attr = { class = "span9 text-center" },
                            content = function()
                                ui.container {
                                    attr = { class = "row-fluid" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "span12 text-center" },
                                            content = function()
                                                ui.heading { level = 1, attr = { class = "fittext0" }, content = _("#{realname}, you are now in the Regione Lazio Internal Assembly", { realname = member.realname }) }
                                            end
                                        }
                                    end
                                }
                                ui.container {
                                    attr = { class = "row-fluid" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "span12 text-center" },
                                            content = function()
                                                ui.heading { level = 2, attr = { class = "fittext0" }, content = _ "CHOOSE THE THEMATIC AREA" }
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

ui.container {
    attr = { class = "row-fluid text-center" },
    content = function()
        ui.container {
            attr = { class = "span4 offset4 text-center" },
            content = function()
                ui.image { static = "parlamento_icon_small.png" }
            end
        }
    end
}

btn_class = "btn btn-primary btn-large large_btn_show_ext table-cell eq1"
btn_class_active = "btn btn-primary btn-large active large_btn_show_ext table-cell eq1"
btn1, btn2 = btn_class, btn_class
if filter == "my_areas" then
    btn2 = btn_class_active
else
    btn1 = btn_class_active
end


ui.container {
    attr = { class = "row-fluid" },
    content = function()
        ui.container {
            attr = { class = "span12 well" },
            content = function()
                ui.container {
                    attr = { class = "row-fluid" },
                    content = function()
                        ui.tag {
                            tag = "h3",
                            attr = { class = "span12 text-center" },
                            content = _ "M5S MEMBERS THEMATIC AREAS" or _ "THEMATIC AREAS"
                        }
                    end
                }
                ui.container {
                    attr = { class = "row-fluid" },
                    content = function()
                        ui.container {
                            attr = { class = "span4 offset2" },
                            content = function()
                                ui.link {
                                    attr = { class = btn1 },
                                    module = "wizard_private",
                                    view = "show_ext_bs",
                                    id = unit_id,
                                    content = function()
                                        ui.heading { level = 3, attr = { class = "fittext1" }, content = _ "SHOW ALL AREAS" }
                                    end
                                }
                            end
                        }
                        ui.container {
                            attr = { class = "span4 offset1" },
                            content = function()
                                ui.link {
                                    attr = { class = btn2 },
                                    module = "wizard_private",
                                    view = "show_ext_bs",
                                    id = unit_id,
                                    params = { filter = "my_areas" },
                                    content = function()
                                        ui.heading { level = 3, attr = { class = "fittext1" }, content = _ "SHOW ONLY PARTECIPATED AREAS" }
                                    end
                                }
                            end
                        }
                    end
                }
                ui.container {
                    attr = { class = "row-fluid" },
                    content = function()
                        ui.container { attr = { class = "span2" }, content = "" }
                    end
                }


                ui.container {
                    attr = { class = "row-fluid" },
                    content = function()
                        execute.view {
                            module = "wizard_private",
                            view = "_list_ext_bs",
                            params = { areas_selector = areas_selector, member = app.session.member }
                        }
                    end
                }
            end
        }
    end
}
