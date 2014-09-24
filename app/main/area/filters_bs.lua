slot.set_layout("custom")

local create = param.get("create", atom.boolean)
local area = Area:by_id(param.get_id())

if not area then
    slot.put_into("error", "Please provide a valid area id")
    return false
end

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
                        module = "unit",
                        view = "show_ext_bs",
                        id = area.unit_id,
                        params = { filter = "my_areas" },
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
                attr = { class = "span1 text-center" },
                content = function()
                    ui.field.popover {
                        attr = {
                            dataplacement = "left",
                            datahtml = "true";
                            datatitle = _ "Box di aiuto per la pagina",
                            datacontent = _ "Le NUOVE PROPOSTE sono quelle attualmente presenti in questa area tematica, IN DISCUSSIONE sono quelle attualmente sono attive, COMPLETATE O RITIRATE tutte le altre proposte in archivio.",
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
end)

ui.container {
    attr = { class = "row-fluid" },
    content = function()
        ui.container {
            attr = { class = "span12 well" },
            content = function()
                ui.container {
                    attr = { class = "row-fluid" },
                    content = function()
                        ui.heading {
                            level = 3,
                            attr = { class = "span6 offset3 text-center label label-warning" },
                            content = _("CHOOSE THE CITIZENS INITIATIVES YOU WANT TO READ:")
                        }
                    end
                }
                ui.container {
                    attr = { class = "row-fluid spaceline2" },
                    content = function()
                        ui.container {
                            attr = { class = "span12 well-inside paper" },
                            content = function()
                                ui.container {
                                    attr = { class = "row-fluid spaceline3 text-center" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "span4" },
                                            content = function()
                                                ui.link {
                                                    attr = { class = "btn btn-primary large_btn btn_size_fix_h fixclick" },
                                                    module = "area",
                                                    view = "show_ext_bs",
                                                    params = { state = "admission" },
                                                    id = area.id,
                                                    content = function()
                                                        ui.heading { level = 3, attr = { class = "fittext" }, content = _ "INITIATIVES LOOKING FOR SUPPORTERS" }
                                                    end
                                                }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "span4" },
                                            content = function()
                                                ui.link {
                                                    attr = { class = "btn btn-primary large_btn btn_size_fix_h fixclick" },
                                                    module = "area",
                                                    view = "show_ext_bs",
                                                    params = { state = "development" },
                                                    id = area.id,
                                                    content = function()
                                                        ui.heading { level = 3, attr = { class = "fittext" }, content = _ "INITIATIVES NOW IN DISCUSSION" }
                                                    end
                                                }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "span4" },
                                            content = function()
                                                ui.link {
                                                    attr = { class = "btn btn-primary large_btn btn_size_fix_h fixclick" },
                                                    module = "area",
                                                    view = "show_ext_bs",
                                                    params = { state = "closed" },
                                                    id = area.id,
                                                    content = function()
                                                        ui.heading { level = 3, attr = { class = "fittext" }, content = _ "COMPLETED OR RETIRED INITIATIVES" }
                                                    end
                                                }
                                            end
                                        }
                                    end
                                }
                                ui.container {
                                    attr = { class = "row-fluid spaceline2 text-center" },
                                    content = function()
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
