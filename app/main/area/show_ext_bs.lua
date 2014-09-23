slot.set_layout("custom")

local create = param.get("create", atom.boolean) or false
local area = Area:by_id(param.get_id())
local state = param.get("state") or "any"
local scope = param.get("scope") or "all_units"
local orderby = param.get("orderby") or "creation_date"
local desc = param.get("desc", atom.boolean) or false
local interest = param.get("interest") or "any"
local member = app.session.member
local ftl_btns = param.get("ftl_btns", atom.boolean) or false

app.html_title.title = area.name
app.html_title.subtitle = _("Area")

ui.title(function()
    ui.container {
        attr = { class = "row-fluid text-left" },
        content = function()
            ui.container {
                attr = { class = "span3" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-large large_btn fixclick btn-back" },
                        module = "area",
                        id = area.id,
                        view = "filters_bs",
                        params = { create = create },
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            ui.heading {
                level = 1,
                attr = { class = "span8 spaceline2 text-center" },
                content = _("#{realname}, you are now in the Regione Lazio Assembly", { realname = (app.session.member.realname ~= "" and app.session.member.realname or app.session.member.login) })
            }
        end
    }
    ui.container {
        attr = { class = "row-fluid spaceline-bottom" },
        content = function()
            ui.container {
                attr = { class = "span11 text-center" },
                content = function()
                    ui.container {
                        attr = { class = "row-fluid spaceline" },
                        content = function()
                            ui.container {
                                attr = { class = "span4 text-right" },
                                content = function()
                                    ui.heading { level = 3, content = _ "Ti trovi nell' area tematica:" }
                                end
                            }
                            local area_id = area.id
                            local name = area.name
                            ui.container {
                                attr = { class = "span8 text-left" },
                                content = function()
                                    ui.heading { level = 3, content = name }
                                end
                            }
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
                            datatitle = _ "Box di aiuto per la pagina",
                            datacontent = _ "Sei nell'elenco delle QUESTIONI presentate per questa area tematica, puoi applicare i filtri per selezionare con maggior precisione quelle di tuo interesse, o scorrere le QUESTIONI ed entrare nei dettagli.",
                            datahtml = "true",
                            class = "text-center"
                        },
                        content = function()
                            ui.image { static = "png/tutor.png" }
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
                attr = { class = "span12 text-center spaceline" },
                content = function()
                    ui.heading { level = 2, attr = { class = "label label-warning" }, content = _ "Scegli la questione da esaminare:" }
                end
            }
        end
    }
end)

-- Determines the desc order button text
local inv_txt
if not desc then
    inv_txt = _ "INVERT ORDER FROM ASCENDING TO DESCENDING"
else
    inv_txt = _ "INVERT ORDER FROM DESCENDING TO ASCENDING"
end

local selector = area:get_reference_selector("issues")

execute.chunk {
    module = "issue",
    chunk = "_filters_ext",
    params = {
        state = state,
        orderby = orderby,
        desc = desc,
        interest = interest,
        selector = selector
    }
}

-- Category, used for routing
local category

-- This holds issue-oriented description text for shown issues
local issues_desc

if state == "admission" then
    issues_desc = _ "Citizens Initiatives Looking For Supporters" or Issue:get_state_name_for_state('admission')
elseif state == "development" then
    issues_desc = _ "Citizens Initiatives In Discussion" or _ "Development"
elseif state == "discussion" then
    issues_desc = _ "Citizens Initiatives In Discussion" or Issue:get_state_name_for_state('discussion')
elseif state == "voting" then
    issues_desc = _ "Citizens Initiatives In Discussion" or Issue:get_state_name_for_state('voting')
elseif state == "verification" then
    issues_desc = _ "Citizens Initiatives In Discussion" or Issue:get_state_name_for_state('verification')
elseif state == "committee" then
    issues_desc = _ "Citizens Initiatives In Discussion" or _ "Committee"
elseif state == "closed" then
    issues_desc = _ "Citizens Initiatives Completed or Retired" or _ "Closed"
elseif state == "canceled" then
    issues_desc = _ "Citizens Initiatives Completed or Retired" or _ "Canceled"
elseif state == "finished" then
    issues_desc = _ "Citizens Initiatives Completed or Retired" or _ "Finished"
elseif state == "finished_with_winner" then
    issues_desc = _ "Citizens Initiatives Completed or Retired" or _ "Finished (with winner)"
elseif state == "finished_without_winner" then
    issues_desc = _ "Citizens Initiatives Completed or Retired" or _ "Finished (without winner)"
elseif state == "open" then
    issues_desc = _ "Open"
elseif state == "any" then
    issues_desc = _ "Any"
else
    issues_desc = _ "Unknown"
end

if state == "development" or state == "verification" or state == "discussion" or state == "voting" or state == "committee" then
    btns = {
        default_state = 'development',
        state = { { "discussion", "verification", "voting", "committee" } },
        default_interest = 'any',
        interest = { { "any", "not_interested", "interested", "initiated" }, { "supported", "potentially_supported", "voted" } }
    }
elseif state == "closed" or state == "canceled" or state == "finished" then
    btns = {
        default_state = 'closed',
        default_interest = 'any',
        interest = { { "any", "not_interested", "interested", "initiated" }, { "supported", "potentially_supported", "voted" } }
    }
elseif state == "admission" then
    btns = {
        default_state = 'admission',
        default_interest = 'any',
        interest = { { "any", "not_interested", "interested", "initiated" }, { "supported", "potentially_supported", "voted" } }
    }
end
if state == "development" then
    execute.chunk {
        module = "issue",
        chunk = "_filters_btn2_bs",
        id = area.id,
        params = {
            state = state,
            orderby = orderby,
            desc = desc,
            interest = interest,
            btns = btns,
            ftl_btns = ftl_btns
        }
    }
end

ui.container {
    attr = { class = "row-fluid text-center" },
    content = function()
        ui.container {
            attr = { class = "span12 text-center" },
            content = function()
                ui.image { attr = { id = "parlamento_img" }, static = "parlamento_icon_small.png" }
            end
        }
    end
}

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
                            attr = { class = "span12 text-center" },
                            content = function()
                                ui.heading { level = 3, content = _(issues_desc) or "Initiatives:" }
                            end
                        }
                    end
                }
                ui.container {
                    attr = { class = "row-fluid" },
                    content = function()
                        ui.container {
                            attr = { class = "span12 well-inside paper" },
                            content = function()
                                ui.container {
                                    attr = { class = "row-fluid" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "span6 offset3" },
                                            content = function()
                                                ui.heading {
                                                    level = 3,
                                                    attr = { class = "uppercase text-center" },
                                                    content = function()
                                                        ui.tag { content = "Ordina le proposte per:" }
                                                    end
                                                }
                                            end
                                        }
                                    end
                                }
                                local btna, btnb, btnc, btnd = "", "", "", ""
                                if orderby == "supporters" then
                                    btna = " active"
                                elseif orderby == "creation_date" then
                                    btnb = " active"
                                elseif orderby == "event" then
                                    btnc = " active"
                                end
                                if desc then
                                    btnd = " active"
                                end
                                ui.container {
                                    attr = { class = "row-fluid spaceline" },
                                    content = function()
                                    --          local btn_style = "width:25%;"
                                        if not app.session.member.elected then
                                            --            btn_style = "width:25%;"
                                            ui.container {
                                                attr = { class = "span3 text-center spaceline  spaceline-bottom" },
                                                content = function()
                                                    ui.link {
                                                        attr = { class = "btn btn-primary large_btn fixclick" .. btna, style = btn_style },
                                                        module = "area",
                                                        view = "show_ext_bs",
                                                        id = area.id,
                                                        params = { state = state, orderby = "supporters", interest = interest, desc = desc, ftl_btns = ftl_btns },
                                                        content = function()
                                                            ui.heading { level = 3, content = _ "ORDER BY NUMBER OF SUPPORTERS" }
                                                        end
                                                    }
                                                end
                                            }
                                        end
                                        ui.container {
                                            attr = { class = "span3 text-center spaceline  spaceline-bottom" },
                                            content = function()
                                                ui.link {
                                                    attr = { class = "btn btn-primary large_btn fixclick" .. btnb, style = btn_style },
                                                    module = "area",
                                                    view = "show_ext_bs",
                                                    id = area.id,
                                                    params = { state = state, orderby = "creation_date", interest = interest, desc = desc, ftl_btns = ftl_btns },
                                                    content = function()
                                                        ui.heading { level = 3, content = _ "ORDER BY DATE OF CREATION" }
                                                    end
                                                }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "span3 text-center spaceline  spaceline-bottom" },
                                            content = function()
                                                ui.link {
                                                    attr = { class = "btn btn-primary large_btn fixclick" .. btnc, style = btn_style },
                                                    module = "area",
                                                    view = "show_ext_bs",
                                                    id = area.id,
                                                    params = { state = state, orderby = "event", interest = interest, desc = desc, ftl_btns = ftl_btns },
                                                    content = function()
                                                        ui.heading { level = 3, content = _ "ORDER BY LAST EVENT DATE" }
                                                    end
                                                }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "span3 text-center spaceline  spaceline-bottom" },
                                            content = function()
                                                ui.link {
                                                    attr = { class = "btn btn-primary large_btn_filter fixclick" .. btnd, style = btn_style },
                                                    module = "area",
                                                    view = "show_ext_bs",
                                                    id = area.id,
                                                    params = { state = state, orderby = orderby, interest = interest, desc = not (desc), ftl_btns = ftl_btns },
                                                    content = function()
                                                        ui.heading { level = 3, content = inv_txt }
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
                    attr = { id = "issues_box", class = "row-fluid spaceline" },
                    content = function()
                        execute.view {
                            module = "issue",
                            view = "_list_ext2_bs",
                            params = {
                                state = state,
                                orderby = orderby,
                                desc = desc,
                                interest = interest,
                                scope = scope,
                                ftl_btns = ftl_btns,
                                selector = selector,
                                view = "area",
                                member = member
                            }
                        }
                    end
                }
            end
        }
    end
}
