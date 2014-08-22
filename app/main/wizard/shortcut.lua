slot.set_layout("custom")

local issue_id = param.get("issue_id", atom.integer) or 0
local draft_id = param.get("draft_id", atom.integer) or 0
local area_id = param.get("area_id", atom.integer)
local unit_id = param.get("unit_id", atom.integer)
local area_name = param.get("area_name", atom.string)
local unit_name = param.get("unit_name", atom.string)

-- trace di controllo sui valori dei parametri
trace.debug("issue_id: " .. tostring(issue_id))
trace.debug("draft_id: " .. tostring(draft_id))
trace.debug("area_id: " .. tostring(area_id))
trace.debug("area_name: " .. area_name)
trace.debug("unit_id: " .. tostring(unit_id))
trace.debug("unit_name: " .. tostring(unit_name))

--set the back parameters
local view_back = "show_ext_bs"
local module_back = "unit"
local params_back = { unit_id = unit_id, create = true, filter = "my_areas" }

ui.form {
    method = "post",
    attr = { id = "page_bs12", class = "" },
    module = 'wizard',
    action = 'create',
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
        formatting_engine = "rocketwiki"
    },
    routing = {
        error = {
            mode = 'redirect',
            module = 'wizard',
            view = 'shortcut',
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
                formatting_engine = "rocketwiki",
                resource = resource
            }
        }
    },
    content = function()
        local disable = "block"
        local only_draft = "block"
        if issue_id ~= 0 then
            disable = " hidden"
            view_back = "show_ext_bs"
            module_back = "issue"
            params_back = { issue_id = issue_id }
		end
        if draft_id ~= 0 then
            disable = " hidden"
            only_draft = " hidden"
            disable = " hidden"
            view_back = "show_ext_bs"
            module_back = "issue"
            params_back = { issue_id = issue_id }
        end

        trace.debug("disable: " .. disable .. "; only_draft: " .. only_draft)

        ui.container {
            attr = { class = "row-fluid" },
            content = function()
                ui.container {
                    attr = { class = "span12 well text-center" },
                    content = function()
                        ui.container {
                            attr = { class = "row-fluid" },
                            content = function()
                                ui.container {
                                    attr = { class = "span3" },
                                    content = function()
                                        ui.link {
                                            attr = { id = "btnPreviuos", class = "span9 btn btn-primary large_btn fixclick" },
                                            module = module_back,
                                            view = view_back,
                                            params = params_back,
                                            id = app.session.member.unit_id,
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
                                ui.container {
                                    attr = { class = "span6" },
                                    content = function()
                                        ui.heading { level = 1, content = _ "WIZARD SHORTCUT HEADER" }
                                        ui.heading { level = 3, content = _ "WIZARD SHORTCUT" }
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
                    end
                }
            end
        }

        ui.container {
            attr = { class = "row-fluid spaceline3" },
            content = function()
                ui.container {
                    attr = { class = "span12 text-center" },
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
                                    attr = { class = "formSelect" .. disable },
                                    content = function()
                                        ui.container {
                                            attr = { class = "row-fluid spaceline3" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "span12 text-center" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "inline-block" },
                                                            content = function()
                                                                ui.container {
                                                                    attr = { class = "text-left" },
                                                                    content = function()
                                                                        ui.container {
                                                                            attr = { class = "row-fluid text-center" },
                                                                            content = function()
                                                                            --policy selezionata cambiata
                                                                                ui.field.hidden {
                                                                                    html_name = "policy_id",
                                                                                    attr = { id = "policy_id" },
                                                                                    value = param.get("policy_id", atom.integer) or 0
                                                                                }
                                                                                ui.field.parelon_group_radio {
                                                                                    id = "policy_id",
                                                                                    out_id = "policy_id",
                                                                                    elements = policies,
                                                                                    selected = policy_id,
                                                                                    attr = { class = "parelon-checkbox spaceline3" },
                                                                                    label_attr = { class = "parelon-label spaceline3" }
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
                                    attr = { class = "row-fluid spaceline3" .. disable },
                                    content = function()
                                        ui.container {
                                            attr = { class = "span12 text-center alert alert-simple issue_box paper", style = "padding-bottom:30px" },
                                            content = function()
                                            --Titolo box questione
                                                ui.container {
                                                    attr = { class = "row-fluid spaceline3" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span4 offset1" },
                                                            content = function()
                                                                ui.heading { level = 5, attr = { class = "alert head-orange uppercase text-center" }, content = _ "QUESTIONE" }
                                                            end
                                                        }
                                                    end
                                                }
                                                --Titolo questione
                                                ui.container {
                                                    attr = { class = "row-fluid spaceline3" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span4 offset1 text-right" },
                                                            content = function()
                                                                ui.tag { tag = "label", content = _ "Problem Title" }
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "span6" },
                                                            content = function()
                                                                ui.tag { tag = "input", attr = { id = "issue_title", name = "issue_title", value = issue_title or "", style = "width:100%;" }, content = "" }
                                                            end
                                                        }
                                                    end
                                                }
                                                -- Descrizione breve questione
                                                ui.container {
                                                    attr = { class = "row-fluid spaceline4" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span4 offset1 text-right issue_brief_span" },
                                                            content = function()
                                                                ui.tag { tag = "p", content = _ "Description to the problem you want to solve" }
                                                            --									ui.tag{tag="em",content=  _"Description note"}
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "span6 issue_brief_span" },
                                                            content = function()
                                                                ui.tag {
                                                                    tag = "textarea",
                                                                    attr = { id = "issue_brief_description", name = "issue_brief_description", style = "width:100%;height:100%;resize:none;" },
                                                                    content = issue_brief_description or ""
                                                                }
                                                            end
                                                        }
                                                    end
                                                }
                                                -- Keywords
                                                ui.container {
                                                    attr = { class = "row-fluid spaceline4" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span4 offset1 text-right" },
                                                            content = function()
                                                                ui.tag { tag = "p", content = _ "Keywords" }
                                                            --                     ui.tag{tag="em",content=  _"Keywords note"}
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "span6 collapse", style = "height:auto;" },
                                                            content = function()
                                                                ui.tag {
                                                                    tag = "textarea",
                                                                    attr = { id = "issue_keywords", name = "issue_keywords", class = "tagsinput", style = "resize:none;" },
                                                                    content = issue_keywords or ""
                                                                }
                                                            end
                                                        }
                                                    end
                                                }
                                                -- Descrizione del problema
                                                ui.container {
                                                    attr = { class = "row-fluid spaceline4" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span4 offset1 text-right issue_desc" },
                                                            content = function()
                                                                ui.tag { tag = "p", content = _ "Problem description" }
                                                            --                      ui.tag{tag="em",content=  _"Problem note"}
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "span6 issue_desc" },
                                                            content = function()
                                                                ui.tag {
                                                                    tag = "textarea",
                                                                    attr = { id = "problem_description", name = "problem_description", style = "height:100%;width:100%;resize:none;" },
                                                                    content = problem_description or ""
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
                                    attr = { class = "row-fluid spaceline3" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "span12 text-center alert alert-simple issue_box paper", style = "padding-bottom:30px" },
                                            content = function()
                                            -- Titolo box proposta
                                                ui.container {
                                                    attr = { class = "row-fluid spaceline3" .. only_draft },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span4 offset1" },
                                                            content = function()
                                                                ui.heading { level = 5, attr = { class = "alert head-chocolate uppercase text-center" }, content = _ "PROPOSTA" }
                                                            end
                                                        }
                                                    end
                                                }
                                                -- Titolo proposta
                                                ui.container {
                                                    attr = { class = "row-fluid spaceline3" .. only_draft },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span4 offset1 text-right" },
                                                            content = function()
                                                                ui.tag { tag = "label", content = _ "Initiative Title" }
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "span6" },
                                                            content = function()
                                                                ui.tag { tag = "input", attr = { id = "initiative_title", name = "initiative_title", value = initiative_title, style = "width:100%;" }, content = "" }
                                                            end
                                                        }
                                                    end
                                                }
                                                -- Descrizione breve proposta
                                                ui.container {
                                                    attr = { class = "row-fluid spaceline3" .. only_draft },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span4 offset1 text-right init_brief" },
                                                            content = function()
                                                                ui.tag { tag = "p", content = _ "Initiative short description" }
                                                            --                      ui.tag{tag="em",content=  _"Initiative short note"}
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "span6 init_brief" },
                                                            content = function()
                                                                ui.tag {
                                                                    tag = "textarea",
                                                                    attr = { id = "initiative_brief_description", name = "initiative_brief_description", style = "height:100%;width:100%;resize:none;" },
                                                                    content = initiative_brief_description or ""
                                                                }
                                                            end
                                                        }
                                                    end
                                                }
                                                -- Descrizione dell'obiettivo
                                                ui.container {
                                                    attr = { class = "row-fluid spaceline3" .. only_draft },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span4 offset1 text-right aim_desc" },
                                                            content = function()
                                                                ui.tag { tag = "p", content = _ "Target description" }
                                                            --                      ui.tag{tag="em",content=  _"Target note"}
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "span6 aim_desc" },
                                                            content = function()
                                                                ui.tag {
                                                                    tag = "textarea",
                                                                    attr = { id = "aim_description", name = "aim_description", style = "height:100%;width:100%;resize:none;" },
                                                                    content = aim_description or ""
                                                                }
                                                            end
                                                        }
                                                    end
                                                }
                                                -- Testo della proposta
                                                ui.container {
                                                    attr = { class = "row-fluid spaceline3" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span4 offset1 text-right draft" },
                                                            content = function()
                                                                ui.tag { tag = "p", content = _ "Draft text" }
                                                            --                      ui.tag{tag="em",content=  _"Draft note"}
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "span6 draft" },
                                                            content = function()
                                                                ui.tag {
                                                                    tag = "textarea",
                                                                    attr = { id = "draft", name = "draft", style = "height:100%;width:100%;resize:none;" },
                                                                    content = draft or ""
                                                                }
                                                            end
                                                        }
                                                    end
                                                }
                                                -- Keywords competenze tecniche
                                                ui.container {
                                                    attr = { class = "row-fluid spaceline4" .. only_draft },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span4 offset1 text-right" },
                                                            content = function()
                                                                ui.tag { tag = "p", content = _ "Keywords" }
                                                            --                     ui.tag{tag="em",content=  _"Keywords note"}
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "span6 collapse", style = "height:auto;" },
                                                            content = function()
                                                                ui.tag {
                                                                    tag = "textarea",
                                                                    attr = { id = "technical_areas", name = "technical_areas", class = "tagsinput", style = "resize:none;" },
                                                                    content = technical_areas or ""
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
                                                            attr = { class = "span4 offset1 text-right" },
                                                            content = function()
                                                                ui.tag { tag = "p", content = _ "Youtube video" }
                                                            --                      ui.tag{tag="em",content=  _"Draft note"}
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "span6" },
                                                            content = function()
                                                                ui.tag {
                                                                    tag = "textarea",
                                                                    attr = { id = "resource", name = "resource" },
                                                                    content = resource or ""
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

                -- Pulsanti
                ui.container {
                    attr = { class = "row-fluid" },
                    content = function()
                        ui.container {
                            attr = { class = "span3 text-center", style = "width: 100%;" },
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
                                                            attr = { class = "span3 text-center", style = "margin-left: 7em;" },
                                                            content = function()
                                                            --pulsante anteprima
                                                                ui.container {
                                                                    attr = { id = "btnAnteprima", class = "btn btn-primary btn-large table-cell eq_btn fixclick", disabled = "true", style = "opacity:0.5;float:left;height: 103px;" },
                                                                    module = "wizard",
                                                                    view = "anteprima",
                                                                    content = function()
                                                                        ui.heading {
                                                                            level = 4,
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
                                                            attr = { class = "span3 text-center" },
                                                            content = function()
                                                                ui.container {
                                                                    attr = { id = "btnSalvaPreview", class = "btn btn-primary btn-large table-cell eq_btn fixclick", disabled = "true", style = "opacity:0.5;float:left;height: 103px;" },
                                                                    module = "wizard",
                                                                    view = "_save_preview",
                                                                    content = function()
                                                                        ui.heading {
                                                                            level = 4,
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
                                                            attr = { class = "span3 text-center" },
                                                            content = function()
                                                                ui.tag {
                                                                    tag = "a",
                                                                    attr = { id = "btnSaveIssue", class = "btn btn-primary btn-large table-cell eq_btn fixclick", style = "float:left;cursor:pointer;height: 103px;" },
                                                                    content = function()
                                                                        ui.heading {
                                                                            level = 4,
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

ui.script { static = "js/jquery.tagsinput.js" }
ui.script { script = "$('#issue_keywords').tagsInput({'height':'96%','width':'96%','defaultText':'" .. _ "Add a keyword" .. "','maxChars' : 20});" }
ui.script { script = "$('#technical_areas').tagsInput({'height':'96%','width':'96%','defaultText':'" .. _ "Add a keyword" .. "','maxChars' : 20});" }
