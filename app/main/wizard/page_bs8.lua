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

local progresso = _ "FASE <strong>8</strong> di 10"

if issue_id ~= 0 then
    progresso = _ "FASE <strong>2</strong> di 4"
end

ui.title(function()
    ui.container {
        attr = { class = "row" },
        content = function()
            ui.container {
                attr = { class = "col-md-12" },
                content = function()
                    ui.container {
                        attr = { class = "row" },
                        content = function()
                            ui.container {
                                attr = { class = "col-md-10 col-md-offset-1 text-center" },
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
                            ui.container {
                                attr = { class = "col-md-1 text-center " },
                                content = function()
                                    ui.field.popover {
                                        attr = {
                                            dataplacement = "left",
                                            datahtml = "true";
                                            datatitle = _ "Give a brief description for your initiative to solve the problem",
                                            datacontent = _ "<iframe width='560' height='315' src='https://www.youtube.com/embed/EECcVB93Wv4' frameborder='0' allowfullscreen></iframe>",
                                            datahtml = "true",
                                            class = "text-center"
                                        },
                                        content = function()
                                            ui.container {
                                                attr = { class = "row" },
                                                content = function()
                                                    ui.image {attr = { class = "icon-medium" }, static = "png/tutor.png" }
                                                --								    ui.heading{level=3 , content= _"What you want to do?"}
                                                end
                                            }
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
                                content = function()
                                    ui.image { attr = { class = "img-responsive" }, static = "png/step_6_f8.png" }
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
    attr = { id = "page_bs8" },
    module = 'wizard',
    view = 'page_bs9',
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
        local progresso = _ "FASE <strong>8</strong> di 10"

        if issue_id ~= 0 then
            progresso = _ "FASE <strong>2</strong> di 4"
        end

        ui.container {
            attr = { class = "row" },
            content = function()
                ui.container {
                    attr = { class = "col-md-12 well" },
                    content = function()
                        ui.container {
                            attr = { class = "row" },
                            content = function()
                                ui.container {
                                    attr = { class = "col-md-12" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "row" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "col-md-6 col-md-offset-3 text-center spaceline" },
                                                    content = function()
                                                        ui.heading {
                                                            level = 3,
                                                            attr = { class = "label label-warning" },
                                                            content = function()
                                                                slot.put(progresso)
                                                            end
                                                        }
                                                        ui.heading { level = 4, attr = { class = "uppercase" }, content = _ "Give a brief description for your initiative to solve the problem" }
                                                    end
                                                }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "row spaceline text-center" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "col-md-12 well-inside paper" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "row spaceline spaceline-bottom" },
                                                            content = function()
                                                                ui.heading {
                                                                    attr = { class = "col-md-12 text-center" },
                                                                    level = 1,
                                                                    content = _ "Initiative short description"
                                                                }
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "row spaceline text-center" },
                                                            content = function()
                                                                ui.container {
                                                                    attr = { class = "col-md-10 col-md-offset-1" },
                                                                    content = function()
                                                                        ui.tag {
                                                                            tag = "textarea",
                                                                            attr = { id = "initiative_brief_description", name = "initiative_brief_description", style = "resize:none;height:260px;", class = "col-md-12" },
                                                                            content = initiative_brief_description
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
                                            attr = { class = "row spaceline" },
                                            content = function()
                                            end
                                        }
                                    end
                                }
                                -- Pulsante "Indietro"
                                ui.container {
                                    attr = { class = "col-md-3 col-md-offset-1 text-center" },
                                    content = function()
                                        ui.tag {
                                            tag = "a",
                                            attr = { id = "btnPreviuos", class = "btn btn-primary large_btn fixclick", onClick = "getElementById(\"page_bs8_back\").submit();" },
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
                                    attr = { class = "col-md-3 col-md-offset-4 text-center" },
                                    content = function()
                                        ui.tag {
                                            tag = "a",
                                            attr = { id = "btnNext", class = "btn btn-primary large_btn", onClick = "getElementById(\"page_bs8\").submit();" },
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

ui.form {
    method = "post",
    attr = { class = "inline-block", id = "page_bs8_back" },
    module = 'wizard',
    view = 'page_bs7',
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
    }
}
