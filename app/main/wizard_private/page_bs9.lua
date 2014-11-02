slot.set_layout("custom")

local draft_id = param.get("draft_id", atom.integer) or 0
local initiative_id = param.get("initiative_id", atom.integer) or 0
local new_draft = param.get("new_draft", atom.string)
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
-- Forzo temporaneamente i valori delle variabili per saltare la pagina 11
--local proposer1 = param.get("proposer1", atom.boolean) or false
--local proposer2 = param.get("proposer2", atom.boolean) or false
--local proposer3 = param.get("proposer3", atom.boolean) or false
local technical_areas = param.get("technical_areas", atom.string) or ""
local proposer1 = true
local proposer2 = false
local proposer3 = false
local resource = param.get("resource", atom.string) or ""

-- trace di controllo sui valori dei parametri
trace.debug("draft_id: " .. tostring(draft_id))
trace.debug("initiative_id: " .. tostring(initiative_id))
trace.debug("new_draft: " .. (new_draft and new_draft or "none"))
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

local back_module = 'wizard_private'
local back_view = 'page_bs8'
local back_params = {
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
local next_view = "page_bs10"
local next_params = {
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

local progresso = _ "FASE <strong>9</strong> di 10"

ui.title(function()
    ui.container {
        attr = { class = "row-fluid" },
        content = function()
            ui.container {
                attr = { class = "span10 offset1 text-center" },
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
                attr = { class = "span1 text-center " },
                content = function()
                    ui.field.popover {
                        attr = {
                            dataplacement = "left",
                            datahtml = "true";
                            datatitle = _ "Insert the text for your initiative to solve the problem",
                            datacontent = _ "Draft note",
                            datahtml = "true",
                            class = "text-center"
                        },
                        content = function()
                            ui.container {
                                attr = { class = "row-fluid" },
                                content = function()
                                    ui.image { static = "png/tutor.png" }
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
        attr = { class = "row-fluid" },
        content = function()
            ui.container {
                attr = { class = "span12" },
                content = function()
                    ui.image { static = "png/step_6_f9.png" }
                end
            }
        end
    }
end)

if draft_id ~= 0 then

    progresso = _ "FASE <strong>1</strong> di 1"
    draft_node = Draft:by_id(draft_id)
    draft = Draft:by_id(draft_id).content
    trace.debug("Initiative id: " .. tostring(draft_node.initiative_id))
    back_module = 'initiative'
    back_view = 'show'
    back_params = { initiative_id = draft_node.initiative_id }
    next_view = "page_bs12"
    next_params = {
        draft_id = draft_id,
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
elseif issue_id ~= 0 then
    progresso = _ "FASE <strong>3</strong> di 4"
end
ui.form {
    method = "post",
    attr = { id = "page_bs9" },
    module = 'wizard_private',
    view = next_view,
    params = next_params,
    content = function()
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

                                                        ui.heading { level = 4, attr = { class = "uppercase" }, content = _ "Give the draft text" }
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
                                                            attr = { class = "row-fluid spaceline text-center" },
                                                            content = function()
                                                                ui.heading {
                                                                    attr = { class = "span12 text-center" },
                                                                    level = 1,
                                                                    content = _ "Draft text"
                                                                }
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "row-fluid spaceline text-center" },
                                                            content = function()
                                                                ui.container {
                                                                    attr = { class = "span10 offset1" },
                                                                    content = function()
                                                                        ui.tag {
                                                                            tag = "textarea",
                                                                            attr = { id = "draft", name = "draft", style = "height:22em; resize:none;" },
                                                                            content = draft
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
                                            attr = { id = "btnPreviuos", class = "btn btn-primary large_btn fixclick", onClick = "getElementById(\"page_bs9_back\").submit();" },
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
                                            attr = { id = "btnNext", class = "btn btn-primary large_btn", onClick = "getElementById(\"page_bs9\").submit();" },
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
    attr = { class = "inline-block", id = "page_bs9_back" },
    module = back_module,
    view = back_view,
    params = back_params
}
