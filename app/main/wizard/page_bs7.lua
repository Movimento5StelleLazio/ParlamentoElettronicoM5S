slot.set_layout("custom")

local issue_id = param.get("issue_id", atom.integer) or 0
local area_id = param.get("area_id", atom.integer)
local unit_id = param.get("unit_id", atom.integer)
local area_name = param.get("area_name", atom.string)
local unit_name = param.get("unit_name", atom.string)
local policy_id = param.get("policy_id", atom.integer) or 0
local issue_title = param.get("issue_title", atom.string) or ""
local issue_brief_description = param.get("issue_brief_description", atom.string) or ""
local issue_keywords = param.get("issue_keywords", atom.string) or ""
local problem_description = param.get("problem_description", atom.string) or ""
local aim_description = param.get("aim_description", atom.string) or ""
local initiative_title = param.get("initiative_title", atom.string) or ""
local initiative_brief_description = param.get("initiative_brief_description", atom.string) or ""
local draft = param.get("draft", atom.string) or ""
local technical_areas = param.get("technical_areas", atom.string) or ""
local proposer1 = param.get("proposer1", atom.boolean) or false
local proposer2 = param.get("proposer2", atom.boolean) or false
local proposer3 = param.get("proposer3", atom.boolean) or false
local resource = param.get("resource", atom.string) or ""

-- trace di controllo sui valori dei parametri
trace.debug("issue_id: " .. tostring(issue_id))
trace.debug("area_id: " .. tostring(area_id))
trace.debug("area_name: " .. area_name)
trace.debug("unit_id: " .. tostring(unit_id))
trace.debug("unit_name: " .. tostring(unit_name))
trace.debug("policy_id: " .. tostring(policy_id))
trace.debug("issue_title: " .. issue_title)
trace.debug("issue_brief_description: " .. issue_brief_description)
trace.debug("issue_keywords: " .. issue_keywords)
trace.debug("problem_description: " .. problem_description)
trace.debug("aim_description: " .. aim_description)
trace.debug("initiative_title: " .. initiative_title)
trace.debug("initiative_brief_description: " .. initiative_brief_description)
trace.debug("draft: " .. draft)
trace.debug("technical_areas: " .. tostring(technical_areas))
trace.debug("proposer1: " .. tostring(proposer1))
trace.debug("proposer2: " .. tostring(proposer2))
trace.debug("proposer3: " .. tostring(proposer3))
trace.debug("resource: " .. (resource and resource or "none"))

--set the back parameters
local view_back = "page_bs6"
local module_back = "wizard"
local params_back = {
    area_id = area_id,
    unit_id = unit_id,
    area_name = area_name,
    unit_name = unit_name,
    policy_id = policy_id,
    issue_title = issue_title,
    issue_brief_description = issue_brief_description,
    issue_keywords = issue_keywords,
    problem_description = problem_description,
    aim_description = aim_description,
    initiative_title = initiative_title,
    initiative_brief_description = initiative_brief_description,
    draft = draft,
    technical_areas = technical_areas,
    proposer1 = proposer1,
    proposer2 = proposer2,
    proposer3 = proposer3,
    resource = resource
}

ui.title(function()
    ui.container {
        attr = { class = "row-fluid" },
        content = function()
            ui.container {
                attr = { class = "span12" },
                content = function()
                    ui.container {
                        attr = { class = "row-fluid" },
                        content = function()
                            ui.container {
                                attr = { class = "span12 text-center" },
                                content = function()
                                    ui.heading { level = 1, attr = { class = "uppercase" }, content = _ "Create new issue" }
                                    ui.heading {
                                        level = 2,
                                        attr = { class = "spaceline" },
                                        content = function()
                                            slot.put(_ "Unit" .. ": " .. "<strong>" .. unit_name .. "</strong>")
                                        end
                                    }
                                    ui.heading {
                                        level = 2,
                                        content = function()
                                            slot.put(_ "Area" .. ": " .. "<strong>" .. area_name .. "</strong>")
                                        end
                                    }
                                end
                            }
                        end
                    }
                    ui.container {
                        attr = { class = "row-fluid" },
                        content = function()
                            ui.container {
                                attr = { class = "span12" },
                                content = function()
                                    ui.image { static = "png/step_6_f7.png" }
                                end
                            }
                        end
                    }
                end
            }
        end
    }
end)

ui.form {
    method = "post",
    attr = { id = "page_bs7" },
    module = 'wizard',
    view = "page_bs8",
    params = {
        issue_id = issue_id,
        area_id = area_id,
        unit_id = unit_id,
        area_name = area_name,
        unit_name = unit_name,
        policy_id = policy_id,
        issue_title = issue_title,
        issue_brief_description = issue_brief_description,
        issue_keywords = issue_keywords,
        problem_description = problem_description,
        aim_description = aim_description,
        initiative_title = initiative_title,
        initiative_brief_description = initiative_brief_description,
        draft = draft,
        technical_areas = technical_areas,
        proposer1 = proposer1,
        proposer2 = proposer2,
        proposer3 = proposer3,
        resource = resource
    },
    content = function()
        local progresso = _ "FASE <strong>7</strong> di 10"

        if issue_id ~= 0 then
            progresso = _ "FASE <strong>1</strong> di 4"
            view_back = "show_ext_bs"
            module_back = "issue"
            params_back = { id = issue_id }
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
                                ui.container {
                                    attr = { class = "span12" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "row-fluid" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span12 text-center spaceline" },
                                                    content = function()
                                                        ui.heading {
                                                            level = 3,
                                                            attr = { class = "label label-warning" },
                                                            content = function()
                                                                slot.put(progresso)
                                                            end
                                                        }
                                                        ui.heading { level = 4, attr = { class = "uppercase" }, content = _ "Give a title for your initiative to solve the problem" }
                                                    end
                                                }
                                            end
                                        }

                                        ui.container {
                                            attr = { class = "row-fluid spaceline text-center" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span12 well-inside paper" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "row-fluid spaceline spaceline-bottom" },
                                                            content = function()
                                                                ui.heading {
                                                                    attr = { class = "span12 text-center" },
                                                                    level = 1,
                                                                    content = _ "Initiative Title"
                                                                }
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "row-fluid" },
                                                            content = function()
                                                                ui.container {
                                                                    attr = { class = "span10 offset1" },
                                                                    content = function()
                                                                        ui.field.text {
                                                                            attr = { id = "initiative_title", style = " font-size: 25px;height: 4em;" },
                                                                            name = "initiative_title",
                                                                            value = initiative_title
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
                        ui.container {
                            attr = { class = "row-fluid spaceline" },
                            content = function()
                            -- Pulsante "Indietro"
                                ui.container {
                                    attr = { class = "span3 offset1 text-center" },
                                    content = function()
                                        ui.tag {
                                            tag = "a",
                                            attr = { id = "btnPreviuos", class = "btn btn-primary large_btn fixclick", onClick = "getElementById(\"page_bs7_back\").submit();" },
                                            content = function()
                                                ui.heading {
                                                    level = 3,
                                                    content = function()
                                                        ui.image { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" }
                                                        slot.put(_ "Back Phase")
                                                    end
                                                }
                                            end
                                        }
                                    end
                                }
                                -- Pulsante "Avanti"
                                ui.container {
                                    attr = { class = "span3 offset4 text-center" },
                                    content = function()
                                        ui.tag {
                                            tag = "a",
                                            attr = { id = "btnNext", class = "btn btn-primary large_btn", onClick = "getElementById(\"page_bs7\").submit();" },
                                            content = function()
                                                ui.heading {
                                                    level = 3,
                                                    content = function()
                                                        slot.put(_ "Next Phase")
                                                        ui.image { attr = { class = "arrow_medium" }, static = "svg/arrow-right.svg" }
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
--	ROUTING BACK
if issue_id then
    ui.form {
        method = "post",
        attr = { class = "inline-block", id = "page_bs7_back" },
        module = module_back,
        view = view_back,
        params = params_back,
        id = issue_id
    }

else
    ui.form {
        method = "post",
        attr = { class = "inline-block", id = "page_bs7_back" },
        module = module_back,
        view = view_back,
        params = params_back
    }
end
