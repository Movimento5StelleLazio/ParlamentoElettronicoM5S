slot.set_layout("custom")

local initiative_id = param.get("initiative_id", atom.integer)
local field_keyword = param.get("field_keyword", atom.string)
local requested = param.get("requested", atom.boolean) or false

ui.form {
    method = "post",
    module = "committee",
    action = "request_committee",
    attr = { id = "page_summon" },
    routing = {
        ok = {
            mode = "redirect",
            module = "committee",
            view = "summon",
            params = { initiative_id = initiative_id, field_keywords = field_keywords, requested = true }
        },
        error = {
            mode = "redirect",
            module = "committee",
            view = "summon",
            params = { initiative_id = initiative_id, field_keywords = field_keywords, requested = false }
        }
    },
    content = function()

        ui.container {
            attr = { class = "row" },
            content = function()
                ui.container {
                    attr = { class = "col-md-12 well" },
                    content = function()
                        ui.container {
                            content = function()

                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-3 col-md-offset-1" },
                                            content = function()
                                                ui.image { static = "png/committee_big.png" }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "col-md-8 text-center" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "row spaceline3" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "col-md-8 uppercase col-md-offset-2 label label-warning text-center" },
                                                            content = function()
                                                                ui.heading { level = 1, attr = { class = "uppercase" }, content = function() slot.put(_ "TECHNICAL COMMITTEE REPORT") end }
                                                            end
                                                        }
                                                    end
                                                }

                                                ui.container {
                                                    attr = { class = "row text-center spaceline2" },
                                                    content = function()
                                                        ui.heading { level = 2, content = function() slot.put(_ "- No technical committee summoned yet for this initiative -") end }
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
                                                        if not requested then
                                                            ui.image { attr = { class = "col-md-12", }, static = "png/commission_step_2.png" }
                                                        else
                                                            ui.image { attr = { class = "col-md-12", }, static = "png/commission_step_3.png" }
                                                        end
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
        if not requested then

            ui.container {
                attr = { class = "row text-center" },
                content = function()
                    ui.container {
                        attr = { class = "col-md-12 text-left" },
                        content = function()
                            ui.heading { level = 6, content = _ "You decided to summon a technical committee to examin this initiative. In the following you have to specify which competences are needed. You can either leave the ones selected from the author of the initiative or substitute some of them with others you prefer." }
                        end
                    }
                    ui.container {
                        attr = { class = "row" },
                        content = function()
                            ui.tag {
                                tag = "textarea",
                                attr = { class = "col-md-12" },
                                id = "competences",
                                content = technical_keywords or ""
                            }
                        end
                    }
                end
            }
            ui.container {
                attr = { class = "row" },
                content = function()
                    ui.container {
                        attr = { class = "col-md-offset-2 col-md-4" },
                        content = function()
                            ui.link {
                                attr = { class = "btn btn-primary" },
                                module = "committee",
                                view = "view",
                                params = { initiative_id = initiative_id },
                                content = _ "Ignore request"
                            }
                        end
                    }

                    ui.container {
                        attr = { class = "col-md-offset-2 col-md-4" },
                        content = function()
                            ui.tag {
                                tag = "a",
                                attr = { class = "btn btn-primary", onclick = "getElementById('page_summon').submit()" },
                                content = _ "Send request"
                            }
                        end
                    }
                end
            }

        else
            ui.container {
                attr = { class = "row" },
                content = function()
                    ui.heading { attr = { class = "col-md-12 text-center" }, level = 3, content = _ "Waiting for the quorum to be reached" }
                    ui.container {
                        attr = { class = "col-md-4" },
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
                        attr = { class = "col-md-7" },
                        content = function()
                            ui.heading {
                                level = 6,
                                content = function()
                                    slot.put(_("<strong>#{count_supporters}</strong> people support the request to summon a technical committee. <strong>#{count_remaining}</strong> people still needed.<br>The committee will be summoned only if the initiative will gather enough supporters.", { count_supporters = 140, count_remaining = 1000 }))
                                end
                            }
                        end
                    }
                end
            }
        end
    end
}

