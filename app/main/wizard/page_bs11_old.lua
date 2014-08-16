local area_id = param.get("area_id", atom.integer)
local unit_id = param.get("unit_id", atom.integer)
local area_name = param.get("area_name", atom.string)
local unit_name = param.get("unit_name", atom.string)
local policy_id = param.get("policy_id", atom.integer)
local issue_title = param.get("issue_title", atom.string)
local issue_brief_description = param.get("issue_brief_description", atom.string)
local issue_keywords = param.get("issue_keywords", atom.string)
local problem_description = param.get("problem_description", atom.string)
local aim_description = param.get("aim_description", atom.string)
local initiative_title = param.get("initiative_title", atom.string)
local initiative_brief_description = param.get("initiative_brief_description", atom.string)
local draft = param.get("draft", atom.string)
local technical_area_1 = param.get("technical_area_1", atom.integer)
local technical_area_2 = param.get("technical_area_2", atom.integer)
local technical_area_3 = param.get("technical_area_3", atom.integer)
local technical_area_4 = param.get("technical_area_4", atom.integer)
local proposer1 = param.get("proposer1", atom.boolean)
local proposer2 = param.get("proposer2", atom.boolean)
local proposer3 = param.get("proposer3", atom.boolean)

local area_id = param.get("area_id", atom.integer)
local unit_id = param.get("unit_id", atom.integer)

local page = param.get("page", atom.integer)
local wizard = param.get("wizard", "table")

local btnBackModule = "wizard"
local btnBackView = "wizard_new_initiative"

if not page or page <= 1 then
    page = 1
    btnBackModule = "index"
    btnBackView = "homepage"
end

local previus_page = page - 1
local next_page = page + 1



ui.container {
    attr = { class = "row-fluid" },
    content = function()
        ui.container {
            attr = { class = "span12 text-center" },
            content = function()
                ui.heading {
                    level = 3,
                    content = function()
                        slot.put(_ "FASE <strong>" .. page .. "</strong> di 11")
                    end
                }
                ui.heading { level = 4, content = _ "The proposals was presented by:" }
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
            --------------------------------------------------------
                ui.container {
                    attr = { class = "row-fluid" },
                    content = function()
                        ui.container {
                            attr = { class = "span12" },
                            content = function()
                                ui.form
                                    {
                                        method = "post",
                                        attr = { id = "wizardForm" .. page, class = "inline-block" },
                                        module = 'wizard',
                                        view = 'wizard_new_initiative_bs',
                                        params = {
                                            area_id = area_id,
                                            unit_id = unit_id,
                                            page = page
                                        },
                                        routing = {
                                            ok = {
                                                mode = 'redirect',
                                                module = 'wizard',
                                                view = 'wizard_new_initiative_bs',
                                                params = {
                                                    area_id = area_id,
                                                    unit_id = unit_id,
                                                    page = page
                                                },
                                            },
                                            error = {
                                                mode = '',
                                                module = 'wizard',
                                                view = 'wizard_new_initiative_bs',
                                            }
                                        },
                                        content = function()

                                        --parametri in uscita
                                            ui.hidden_field { name = "indietro", value = false }
                                            ui.hidden_field { name = "proposer_hidden", value = false }


                                            local proposer1
                                            local proposer2
                                            local proposer3
                                            for i, k in ipairs(wizard) do
                                                ui.hidden_field { name = k.name, value = k.value }
                                                if k.value then
                                                    trace.debug("[wizard] name=" .. k.name .. " | value=" .. k.value)

                                                    if k.name == "proposer1" then
                                                        proposer1 = "true"
                                                    end

                                                    if k.name == "proposer2" then
                                                        proposer2 = "true"
                                                    end

                                                    if k.name == "proposer3" then
                                                        proposer3 = "true"
                                                    end
                                                end
                                            end

                                            ui.container {
                                                attr = { class = "row-fluid spaceline2" },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "span12 text-left" },
                                                        content = function()



                                                        --1 proposer
                                                            execute.view
                                                                {
                                                                    module = "wizard",
                                                                    view = "_checkbox_bs",
                                                                    params = {
                                                                        id_checkbox = "1",
                                                                        label = _ "Citiziens",
                                                                        selected = proposer1
                                                                    }
                                                                }

                                                            --2 proposer
                                                            execute.view
                                                                {
                                                                    module = "wizard",
                                                                    view = "_checkbox_bs",
                                                                    params = {
                                                                        id_checkbox = "2",
                                                                        label = _ "Elected M5S",
                                                                        selected = proposer2
                                                                    }
                                                                }


                                                            --3 proposer
                                                            execute.view
                                                                {
                                                                    module = "wizard",
                                                                    view = "_checkbox_bs",
                                                                    params = {
                                                                        id_checkbox = "3",
                                                                        label = _ "Other groups",
                                                                        selected = proposer1
                                                                    }
                                                                }
                                                        end
                                                    }
                                                end
                                            }
                                        --fine div formSelect
                                        end
                                    } --fine form
                            --------------------------------------------------------
                            end
                        }
                    end
                }
            end
        }
    end
}


ui.script { static = "js/wizard_checkbox.js" }


ui.container {
    attr = { class = "row-fluid btn_box_bottom spaceline3" },
    content = function()
        ui.container {
            attr = { class = "span12 text-center" },
            content = function()
                execute.view {
                    module = "wizard",
                    view = "_pulsanti_bs",
                    params = {
                        btnBackModule = "wizard",
                        btnBackView = "wizard_new_initiative_bs",
                        page = page
                    }
                }
            end
        }
    end
}
 
