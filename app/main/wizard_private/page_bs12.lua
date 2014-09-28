slot.set_layout("custom")

local issue_id = param.get("issue_id", atom.integer) or 0
local draft_id = param.get("draft_id", atom.integer) or 0
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
local proposer1 = param.get("proposer1", atom.boolean) or true
local proposer2 = param.get("proposer2", atom.boolean) or true
local proposer3 = param.get("proposer3", atom.boolean) or true
local resource = param.get("resource", atom.string) or ""

-- trace di controllo sui valori dei parametri
trace.debug("issue_id: " .. tostring(issue_id))
trace.debug("draft_id: " .. tostring(draft_id))
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

local action = "create"
local action_params = {
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
    formatting_engine = "rocketwiki",
    resource = resource
}

local back_view = "page_bs10"
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

local disable = ""
local only_draft = ""
if issue_id ~= 0 then
    disable = " hidden"
end
if draft_id ~= 0 then
    disable = " hidden"
    only_draft = " hidden"
    action = "add_new_draft"
    action_params = {
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
        content = draft,
        draft = draft,
        technical_areas = technical_areas,
        proposer1 = proposer1,
        proposer2 = proposer2,
        proposer3 = proposer3,
        formatting_engine = "rocketwiki",
        resource = resource
    }
    back_view = "page_bs9"
    back_params = {
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
end
trace.debug("disable: " .. disable .. "; only_draft: " .. only_draft)

ui.title(function()
    ui.container {
        attr = { class = "row-fluid spaceline" },
        content = function()
            ui.container {
                attr = { class = "span12" },
                content = function()
                    ui.container {
                        attr = { class = "row-fluid" },
                        content = function()
                            ui.container {
                                attr = { class = "span3 text-left" },
                                content = function()
                                -- implementare "indietro"
                                    ui.tag {
                                        tag = "a",
                                        attr = {
                                            class = "btn btn-primary btn-large fixclick btn-back",
                                            onclick = "getElementById('page_bs12_back').submit();"
                                        },
                                        content = function()
                                            ui.heading {
                                                level = 3,
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
                                attr = { class = "span8 spaceline2 label label-warning text-center" },
                                content = function()
                                    ui.heading { level = 1, content = _ "WIZARD HEADER END" }
                                end
                            }
                            ui.container {
                                attr = { class = "span1 spaceline text-center " },
                                content = function()
                                    ui.field.popover {
                                        attr = {
                                            dataplacement = "left",
                                            datahtml = "true";
                                            datatitle = _ "Insert Technical Areas",
                                            datacontent = _ "WIZARD END",
                                            datahtml = "true",
                                            class = "text-center"
                                        },
                                        content = function()
                                            ui.container {
                                                attr = { class = "icon" },
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
                                attr = { class = "span12 text-center" },
                                content = function()
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
                                    ui.image { static = "png/step_end.png" }
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
    attr = { id = "page_bs12", class = "" },
    module = 'wizard_private',
    action = action,
    params = action_params,
    routing = {
        error = {
            mode = 'redirect',
            module = 'wizard_private',
            view = 'page_bs12',
            params = action_params
        }
    },
    content = function()
        ui.container {
            attr = { class = "row-fluid" },
            content = function()
                ui.container {
                    attr = { class = "span12 well" },
                    content = function()
                        ui.container {
                            attr = { class = "row-fluid" .. disable },
                            content = function()
                                ui.container {
                                    attr = { class = "span12 text-center well-inside paper" },
                                    content = function()
                                    --Selezione policy
                                        ui.container {
                                            attr = { class = "formSelect" },
                                            content = function()
                                                local area_policies = AllowedPolicy:get_policy_by_area_id(area_id)
                                                local policies = {}

                                                for i, k in ipairs(area_policies) do
                                                    policies[#policies + 1] = { id = k.policy_id, name = Policy:by_id(k.policy_id).name }
                                                end

                                                ui.container {
                                                    attr = { class = "formSelect" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "row-fluid spaceline1 spaceline-bottom " },
                                                            content = function()
                                                                ui.container {
                                                                    attr = { class = "span12" },
                                                                    content = function()
                                                                        ui.container {
                                                                            attr = { class = "inline-block" },
                                                                            content = function()
                                                                                ui.container {
                                                                                    attr = { class = "text-left" },
                                                                                    content = function()
                                                                                        ui.container {
                                                                                            attr = { class = "row-fluid" },
                                                                                            content = function()
                                                                                            --policy selezionata cambiata
                                                                                                ui.field.hidden {
                                                                                                    html_name = "policy_id",
                                                                                                    attr = { id = "policy_id" },
                                                                                                    value = param.get("policy_id", atom.integer) or 0
                                                                                                }
                                                                                                --radio-button group
                                                                                                ui.field.parelon_group_radio {
                                                                                                    id = "policy_id",
                                                                                                    out_id = "policy_id",
                                                                                                    elements = policies,
                                                                                                    selected = policy_id,
                                                                                                    attr = { class = "parelon-checkbox spaceline3 " },
                                                                                                    label_attr = { class = "parelon-label spaceline3 " }
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
                                            end
                                        }
                                    end
                                }
                            end
                        }
                        -- Box questione
                        ui.container {
                            attr = { class = "row-fluid spaceline3 " .. disable },
                            content = function()
                                ui.container {
                                    attr = { class = "span12 well-blue", style = "padding-bottom:30px" },
                                    content = function()
                                    --Titolo box questione
                                        ui.container {
                                            attr = { class = "row-fluid spaceline " },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span10 offset1  offset3 label label-warning " },
                                                    content = function()
                                                        ui.heading { level = 1, attr = { class = "uppercase text-center" }, content = _ "QUESTIONE" }
                                                    end
                                                }
                                            end
                                        }
                                        --Titolo questione
                                        ui.container {
                                            attr = { class = "row-fluid spaceline " },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "row-fluid spaceline " },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span10 offset1 text-left" },
                                                            content = function()
                                                                ui.tag { tag = "label", content = _ "Problem Title" }
                                                            end
                                                        }
                                                    end
                                                }
                                                ui.container {
                                                    attr = { class = "row-fluid" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span10 offset1 text-left spaceline" },
                                                            content = function()
                                                                ui.tag { tag = "input", attr = { id = "issue_title", name = "issue_title", value = issue_title, style = "width:70%;" }, content = "" }
                                                            end
                                                        }
                                                    end
                                                }
                                            end
                                        }
                                        -- Descrizione breve questione
                                        ui.container {
                                            attr = { class = "row-fluid spaceline3 " },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span10 offset1 text-left" },
                                                    content = function()
                                                        ui.tag { tag = "p", content = _ "Brief description" }
                                                    --									ui.tag{tag="em",content=  _"Description note"}
                                                    end
                                                }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "row-fluid " },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span10 offset1 issue_brief_span" },
                                                    content = function()
                                                        ui.tag {
                                                            tag = "textarea",
                                                            attr = { id = "issue_brief_description", name = "issue_brief_description", style = "width:100%;height:250px;resize:yes;" },
                                                            content = issue_brief_description
                                                        }
                                                    end
                                                }
                                            end
                                        }
                                        -- Keywords
                                        ui.container {
                                            attr = { class = "row-fluid spaceline3 " },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span10 offset1 text-left" },
                                                    content = function()
                                                        ui.tag { tag = "p", content = _ "Keywords" }
                                                    --                     ui.tag{tag="em",content=  _"Keywords note"}
                                                    end
                                                }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "row-fluid" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span10 offset1 collapse", style = "height:60px;" },
                                                    content = function()
                                                        ui.tag {
                                                            tag = "textarea",
                                                            attr = { id = "issue_keywords", name = "issue_keywords", class = "tagsinput", style = "height:200px;resize:none;" },
                                                            content = issue_keywords
                                                        }
                                                    end
                                                }
                                            end
                                        }
                                        -- Descrizione del problema
                                        ui.container {
                                            attr = { class = "row-fluid spaceline3 " },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span10 offset1 text-left issue_desc" },
                                                    content = function()
                                                        ui.tag { tag = "p", content = _ "Problem description" }
                                                    --                      ui.tag{tag="em",content=  _"Problem note"}
                                                    end
                                                }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "row-fluid" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span10 offset1 issue_desc" },
                                                    content = function()
                                                        ui.tag {
                                                            tag = "textarea",
                                                            attr = { id = "problem_description", name = "problem_description", style = "height:250px;width:100%;resize:yes;" },
                                                            content = problem_description
                                                        }
                                                    end
                                                }
                                            end
                                        }
                                        -- Descrizione dell'obiettivo
                                        ui.container {
                                            attr = { class = "row-fluid spaceline3 " .. only_draft },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span10 offset1 text-left aim_desc" },
                                                    content = function()
                                                        ui.tag { tag = "p", content = _ "Target description" }
                                                    --                      ui.tag{tag="em",content=  _"Target note"}
                                                    end
                                                }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "row-fluid" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span10 offset1  aim_desc" },
                                                    content = function()
                                                        ui.tag {
                                                            tag = "textarea",
                                                            attr = { id = "aim_description", name = "aim_description", style = "height:250px;width:100%;resize:yes;" },
                                                            content = aim_description
                                                        }
                                                    end
                                                }
                                            end
                                        }
                                    end
                                }
                            end
                        }

                        -- Box proposta
                        ui.container {
                            attr = { class = "row-fluid spaceline3 " },
                            content = function()
                                ui.container {
                                    attr = { class = "span12 well", style = "padding-bottom:30px" },
                                    content = function()
                                    -- Titolo box proposta
                                        if only_draft == "" then
                                            ui.container {
                                                attr = { class = "row-fluid" },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "span6 offset3 label label-warning text-center" },
                                                        content = function()
                                                            ui.heading { level = 1, content = _ "PROPOSTA" }
                                                        end
                                                    }
                                                end
                                            }
                                            -- Titolo proposta
                                            ui.container {
                                                attr = { class = "row-fluid spaceline3 " },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "span10 offset1 text-left" },
                                                        content = function()
                                                            ui.tag { tag = "label", content = _ "Initiative Title" }
                                                        end
                                                    }
                                                end
                                            }
                                            ui.container {
                                                attr = { class = "row-fluid" },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "span10 offset1 " },
                                                        content = function()
                                                            ui.tag { tag = "input", attr = { id = "initiative_title", name = "initiative_title", value = initiative_title, style = "width:100%;" }, content = "" }
                                                        end
                                                    }
                                                end
                                            }
                                            -- Descrizione breve proposta
                                            ui.container {
                                                attr = { class = "row-fluid spaceline3 " },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "span10 offset1 text-left init_brief" },
                                                        content = function()
                                                            ui.tag { tag = "p", content = _ "Initiative short description" }
                                                        --                      ui.tag{tag="em",content=  _"Initiative short note"}
                                                        end
                                                    }
                                                end
                                            }
                                            ui.container {
                                                attr = { class = "row-fluid" },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "span10 offset1  init_brief" },
                                                        content = function()
                                                            ui.tag {
                                                                tag = "textarea",
                                                                attr = { id = "initiative_brief_description", name = "initiative_brief_description", style = "resize:yes;height:250px;width:100%;resize:none;" },
                                                                content = initiative_brief_description
                                                            }
                                                        end
                                                    }
                                                end
                                            }
                                        end
                                        -- Testo della proposta
                                        ui.container {
                                            attr = { class = "row-fluid spaceline3 " },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span10 offset1 text-left draft" },
                                                    content = function()
                                                        ui.tag { tag = "p", content = _ "Draft text" }
                                                    --                      ui.tag{tag="em",content=  _"Draft note"}
                                                    end
                                                }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "row-fluid" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span10 offset1  draft" },
                                                    content = function()
                                                        ui.tag {
                                                            tag = "textarea",
                                                            attr = { id = "draft", name = "draft", style = "height:500px;;resize:yes;" },
                                                            content = draft
                                                        }
                                                    end
                                                }
                                            end
                                        }
                                        if only_draft == "" then
                                            -- Keywords competenze tecniche
                                            ui.container {
                                                attr = { class = "row-fluid spaceline3 " .. only_draft },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "span10 offset1 text-left" },
                                                        content = function()
                                                            ui.tag { tag = "p", content = _ "Keywords" }
                                                        --                     ui.tag{tag="em",content=  _"Keywords note"}
                                                        end
                                                    }
                                                end
                                            }
                                            ui.container {
                                                attr = { class = "row-fluid" },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "span10 offset1 collapse" .. only_draft, style = "height:60px;" },
                                                        content = function()
                                                            ui.tag {
                                                                tag = "textarea",
                                                                attr = { id = "technical_areas", name = "technical_areas", class = "tagsinput", style = "height:250px;resize:none;" },
                                                                content = technical_areas
                                                            }
                                                        end
                                                    }
                                                end
                                            }
                                            -- link youtube
                                            ui.container {
                                                attr = { class = "row-fluid spaceline3 " },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "span10 offset1 text-left" .. only_draft },
                                                        content = function()
                                                            ui.tag { tag = "p", content = _ "Youtube video" }
                                                        --                      ui.tag{tag="em",content=  _"Draft note"}
                                                        end
                                                    }
                                                end
                                            }
                                            ui.container {
                                                attr = { class = "row-fluid" },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "span10 offset1 " .. only_draft },
                                                        content = function()
                                                            ui.tag {
                                                                tag = "textarea",
                                                                attr = { id = "resource", name = "resource" },
                                                                content = resource
                                                            }
                                                        end
                                                    }
                                                end
                                            }
                                        end
                                    end
                                }
                            end
                        }


                        -- Pulsanti
                        ui.container {
                            attr = { class = "row-fluid" },
                            content = function()
                                ui.container {
                                    attr = { class = "span3 text-center", style = "width:100%;" },
                                    content = function()
                                        ui.container {
                                            attr = { id = "pulsanti", style = "position: relative;" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "row-fluid" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "row-fluid" },
                                                            content = function()
                                                                ui.container {
                                                                    attr = { class = "span4 text-center" },
                                                                    content = function()
                                                                    --pulsante anteprima
                                                                        ui.container {
                                                                            attr = { id = "btnAnteprima", class = "btn btn-primary large_btn fixclick", disabled = "true", style = "opacity:0.5;" },
                                                                            module = "wizard",
                                                                            view = "anteprima",
                                                                            content = function()
                                                                                ui.heading {
                                                                                    level = 3,
                                                                                    attr = { class = "fittext_btn_wiz" },
                                                                                    content = function()
                                                                                        ui.container {
                                                                                            attr = { class = "row-fluid" },
                                                                                            content = function()
                                                                                                ui.container {
                                                                                                    attr = { class = "span12" },
                                                                                                    content = function()
                                                                                                        slot.put(_ "Show preview")
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
                                                                --pulsante "Save preview"
                                                                ui.container {
                                                                    attr = { class = "span4 text-center" },
                                                                    content = function()
                                                                        ui.container {
                                                                            attr = { id = "btnSalvaPreview", class = "btn btn-primary large_btn fixclick", disabled = "true", style = "opacity:0.5;" },
                                                                            module = "wizard",
                                                                            view = "_save_preview",
                                                                            content = function()
                                                                                ui.heading {
                                                                                    level = 3,
                                                                                    attr = { class = "fittext_btn_wiz" },
                                                                                    content = function()
                                                                                        ui.container {
                                                                                            attr = { class = "row-fluid" },
                                                                                            content = function()
                                                                                                ui.container {
                                                                                                    attr = { class = "span12" },
                                                                                                    content = function()
                                                                                                        slot.put(_ "Save preview")
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
                                                                --pulsante Save
                                                                ui.container {
                                                                    attr = { class = "span4 text-center" },
                                                                    content = function()
                                                                        ui.tag {
                                                                            tag = "a",
                                                                            attr = { id = "btnSaveIssue", class = "btn btn-primary large_btn fixclick", style = "cursor:pointer;", onclick = "getElementById(\"page_bs12\").submit()" },
                                                                            content = function()
                                                                                ui.heading {
                                                                                    level = 3,
                                                                                    attr = { class = "fittext_btn_wiz" },
                                                                                    content = function()
                                                                                        ui.container {
                                                                                            attr = { class = "row-fluid" },
                                                                                            content = function()
                                                                                                ui.container {
                                                                                                    attr = { class = "span12" },
                                                                                                    content = function()
                                                                                                        slot.put(_ "Save issue")
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
    attr = { id = "page_bs12_back" },
    module = 'wizard',
    view = back_view,
    params = back_params
}

ui.script { static = "js/jquery.tagsinput.js" }
ui.script { script = "$('#issue_keywords').tagsInput({'height':'96%','width':'96%','defaultText':'" .. _ "Add a keyword" .. "','maxChars' : 20});" }
ui.script { script = "$('#technical_areas').tagsInput({'height':'96%','width':'96%','defaultText':'" .. _ "Add a keyword" .. "','maxChars' : 20});" }
