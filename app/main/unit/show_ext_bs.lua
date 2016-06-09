slot.set_layout("custom")

local filter = param.get("filter")
local create = param.get("create", atom.boolean) or false

if not app.session.member_id then
    return false
end

local member = app.session.member
areas_selector = Area:build_selector { active = true }
areas_selector:add_order_by("id")

if filter == "my_areas" then
    areas_selector:join("membership", nil, { "membership.area_id = area.id AND membership.member_id = ?", member.id })
else
    areas_selector:join("privilege", nil, { "privilege.unit_id = area.unit_id AND privilege.member_id = ? AND privilege.voting_right", member.id })
end

areas_selector:join("unit", nil, "unit.id = area.unit_id AND unit.public ")

ui.title(function()
    ui.container {
        attr = { class = "row" },
        content = function()
            ui.container {
                attr = { class = "col-md-3 text-left" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-large large_btn btn-back" },
                        module = "index",
                        view = "homepage_bs",
                        content = _ "Back to previous page",
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" }
                    }
                end
            }
            ui.container {
                attr = { class = "col-md-8 text-center spaceline2" },
                content = function()
                    ui.container {
                        attr = { class = "row" },
                        content = function()
                            ui.container {
                                attr = { class = "col-md-12 text-center" },
                                content = function()
                                    ui.heading { level = 1, content = _("#{realname}, you are now in the Regione Lazio Assembly", { realname = member.realname }) }
                                end
                            }
                        end
                    }
                    ui.container {
                        attr = { class = "row" },
                        content = function()
                            ui.container {
                                attr = { class = "col-md-12 text-center" },
                                content = function()
                                    ui.heading { level = 2, content = _ "CHOOSE THE THEMATIC AREA" }
                                end
                            }
                        end
                    }
                end
            }

            ui.container {
                attr = { class = "col-md-1 text-center spaceline" },
                content = function()
                    ui.field.popover {
                        attr = {
                            dataplacement = "left",
                            datahtml = "true";
                            datatitle = _ "Box di aiuto per la pagina",
                            datacontent = _ "Di default Parelon ti suggerisce le aree in cui sei iscritto, se è la prima volta che sei qui devi selezionare il pulsante TUTTE LE AREE per aderire a quelle di tuo interesse. <br />Una volta che ti sarai attivato, ti appare il sommario delle QUESTIONI sollevate e nel dettaglio la, o le varie PROPOSTE presentate per risolvere. <br />Puoi navigare nelle aree, interessarti, emendare e sostenere una o più PROPOSTE, o presentare una tua nuova QUESTIONE e PROPOSTA per quell' area selezionata.",
                            datahtml = "true",
                            class = "text-center"
                        },
                        content = function()
                            ui.image { attr = { class = "icon-medium" },static = "png/tutor.png" }
                        end
                    }
                end
            }
        end
    }
end)

ui.container {
    attr = { class = "row text-center" },
    content = function()
        ui.container {
            attr = { class = "col-md-4 col-md-offset-4 text-center" },
            content = function()
                ui.image { static = "parlamento_icon_small.png" }
            end
        }
    end
}

btn_class = "btn btn-primary btn-large large_btn"
btn_class_active = "btn btn-primary btn-large active large_btn"
btn1, btn2 = btn_class, btn_class

if filter == "my_areas" then
    btn2 = btn_class_active
else
    btn1 = btn_class_active
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
                        ui.tag {
                            tag = "h3",
                            attr = { class = "col-md-12 text-center" },
                            content = _ "CITIZENS THEMATIC AREAS" or _ "THEMATIC AREAS"
                        }
                    end
                }
                ui.container {
                    attr = { class = "row text-center" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-6" },
                            content = function()
                                ui.link {
                                    attr = { class = btn1 },
                                    module = "unit",
                                    view = "show_ext_bs",
                                    params = { create = create },
                                    content = function()
                                        ui.heading { level = 3, content = _ "SHOW ALL AREAS" }
                                    end
                                }
                            end
                        }
                        ui.container {
                            attr = { class = "col-md-6" },
                            content = function()
                                ui.link {
                                    attr = { class = btn2 },
                                    module = "unit",
                                    view = "show_ext_bs",
                                    params = { filter = "my_areas", create = create },
                                    content = function()
                                        ui.heading { level = 3, content = _ "SHOW ONLY PARTECIPATED AREAS" }
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
                            attr = { class = "col-md-12 spaceline" },
                            content = function()
                                execute.view {
                                    module = "area",
                                    view = "_list_ext_bs",
                                    params = { areas_selector = areas_selector, member = app.session.member, create = create }
                                }
                            end
                        }
                    end
                }
            end
        }
    end
}
