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
        attr = { class = "row text-left" },
        content = function()
            ui.container {
                attr = { class = "col-md-3 pull-left" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary fixclick btn-back text-center" },
                        module = "unit",
                        view = "show_ext_bs",
                        id = area.unit_id,
                        params = { filter = "my_areas" },
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }

            ui.container {
                attr = { class = "col-md-6 well-inside paper text-center" },
                content = function()
						          ui.heading {
					                level = 1,
					                attr = { class = "col-md-12 spaceline text-center" },
					                content = _("#{realname}", { realname = (app.session.member.realname ~= "" and app.session.member.realname or app.session.member.login) })
					             }
                            ui.container {
                                attr = { class = "col-md-12 text-center" },
                                content = function()
                                    ui.heading { level = 3, content = _ "Ti trovi nell' area tematica:" }
                                end
                            }
                            local area_id = area.id
                            local name = area.name
                            ui.container {
                                attr = { class = "col-md-12 text-center" },
                                content = function()
                                    ui.heading { level = 5, content = name }
                                end
                            }
                end
            }
            ui.container {
                attr = { class = "col-md-3 text-right hidden-sm hidden-xs" },
                content = function()
                    ui.field.popover {
                        attr = {
                            dataplacement = "bottom",
                            datahtml = "true";
                            datatitle = _ "Box di aiuto per la pagina",
                            datacontent = _ "Le NUOVE PROPOSTE sono quelle attualmente presenti in questa area tematica, IN DISCUSSIONE sono quelle attualmente sono attive, COMPLETATE O RITIRATE tutte le altre proposte in archivio.",
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
    attr = { class = "row" },
    content = function()
        ui.container {
            attr = { class = "col-md-12 well" },
            content = function()
                ui.container {
                    attr = { class = "row" },
                    content = function()
                        ui.heading {
                            level = 3,
                            attr = { class = "col-md-6 col-md-offset-3 text-center label label-warning" },
                            content = _("CHOOSE THE CITIZENS INITIATIVES YOU WANT TO READ:")
                        }
                    end
                }
                ui.container {
                    attr = { class = "row spaceline2" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-12 well-inside paper" },
                            content = function()
                                ui.container {
                                    attr = { class = "row spaceline3 text-center" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-4" },
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
                                            attr = { class = "col-md-4" },
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
                                            attr = { class = "col-md-4" },
                                            content = function()
                                                ui.link {
                                                    attr = { class = "btn btn-primary large_btn btn_size_fix_h fixclick" },
                                                    module = "area",
                                                    view = "show_ext_bs",
                                                    params = { state = "closed" },
                                                    id = area.id,
                                                    content = function()
                                                        ui.heading { level = 3, attr = { class = "fittext" }, content = _ "COMPLETE" }
                                                    end
                                                }
                                            end
                                        }
                                    end
                                }
                                ui.container {
                                    attr = { class = "row spaceline2 text-center" },
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
