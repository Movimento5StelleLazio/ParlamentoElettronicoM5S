slot.set_layout("custom")

local initiative_id = param.get("initiative_id", atom.integer) or 0
local field_keywords = param.get("field_keywords", atom.string)
local committee_id = param.get("committee_id", atom.integer) or 0

ui.container {
    attr = { class = "row" },
    content = function()
        ui.container {
            attr = { class = "col-md-12 well" },
            content = function()
                ui.container {
                    attr = { class = "row" },
                    content = function()
                        ui.image { attr = { class = "col-md-3 col-md-offset-1" }, static = "png/committee_big.png" }
                        ui.container {
                            attr = { class = "col-md-6 col-md-offset-1 text-center spaceline3" },
                            content = function()
                                ui.container {
                                    attr = { class = "row label label-warning" },
                                    content = function()
                                        ui.heading { level = 1, attr = { class = "uppercase" }, content = function() slot.put(_ "TECHNICAL COMMITTEE REPORT") end }
                                    end
                                }
                                ui.container {
                                    attr = { class = "row spaceline2" },
                                    content = function()
                                        if committee_id == 0 then
                                            ui.heading { level = 3, content = slot.put(_ "- No technical committee summoned yet for this initiative -") }
                                        else
                                            ui.heading { level = 3, content = slot.put(_ "Technical committee already summoned") }
                                        end
                                    end
                                }
                            end
                        }
                        ui.container {
                            attr = { class = "row" },
                            content = function()
                                ui.image { attr = { class = "col-md-12", }, static = "png/commission_step_1.png" }
                            end
                        }
                    end
                }

                if committee_id == 0 then
                    ui.container {
                        attr = { class = "row spaceline" },
                        content = function()
                            ui.container {
                                attr = { class = "col-md-12 well-inside paper" },
                                content = function()
                                    ui.container {
                                        attr = { class = "col-md-6 text-justify" },
                                        content = function()
                                            ui.heading { level = 3, content = _ "Do you think that this initiative needs to be examined by experts? Click here to support the request for a technical committee to be summoned" }
                                        end
                                    }
                                    ui.container {
                                        attr = { class = "col-md-2 text-center" },
                                        content = function()
                                            ui.image { attr = { class = "arrow_big" }, static = "svg/arrow-right.svg" }
                                        end
                                    }
                                    --DA RIFARE: params sbagliati
                                    ui.container {
                                        attr = { class = "col-md-4 spaceline" },
                                        content = function()
                                            ui.link {
                                                attr = { class = "btn btn-primary" },
                                                module = "committee",
                                                view = "summon",
                                                params = { initiative_id = initiative_id, field_keywords = field_keywords },
                                                content = function()
                                                    slot.put(_ "Summon a committee")
                                                end
                                            }
                                        end
                                    }
                                end
                            }
                        end
                    }
                    ui.container {
                        attr = { class = "row spaceline" },
                        content = function()
                            ui.container {
                                attr = { class = "col-md-12 well-inside paper" },
                                content = function()
                                    ui.container {
                                        attr = { class = "col-md-6" },
                                        content = function()
                                            ui.container {
                                                attr = { class = "row" },
                                                content = function()
                                                    local quorum_percent = 20 --issue.policy.issue_quorum_num * 100 / issue.policy.issue_quorum_den
                                                    local quorum_supporters
                                                    --[[if issue.population and issue.population > 0 then
                                                    quorum_supporters = math.ceil(issue.population * quorum_percent / 100)
                                                    else]]
                                                    quorum_supporters = 0
                                                    --end
                                                    ui.container {
                                                        attr = { class = "col-md-2 col-md-offset-2" },
                                                        content = function()

                                                            ui.container {
                                                                attr = { class = "initiative_quorum_out_box" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { id = "quorum_box", class = "initiative_quorum_box", style = "left:" .. 2 + quorum_percent .. "%" },
                                                                        content = function()
                                                                            ui.container {
                                                                                attr = { id = "quorum_txt" },
                                                                                content = function()
                                                                                    slot.put(" " .. "Quorum" .. " " .. quorum_percent .. "%" .. "<br>" .. "    (" .. quorum_supporters .. " " .. _ "supporters" .. ")")
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
                                        attr = { class = "col-md-6 text-justify" },
                                        content = function()
                                            ui.heading {
                                                level = 3,
                                                content = function()
                                                    slot.put(_("<strong>#{count_supporters}</strong> people support the request to summon a technical committee. <strong>#{count_remaining}</strong> people still needed.<br>The committee will be summoned only if the initiative will gather enough supporters.", { count_supporters = 140, count_remaining = 1000 }))
                                                end
                                            }
                                        end
                                    }
                                end
                            }
                        end
                    }
                else
                    execute.view {
                        module = "committee",
                        view = "status",
                        params = { initiative_id = initiative_id, committee_id = committee_id }
                    }
                end
            end
        }
    end
}
