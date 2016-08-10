slot.set_layout("custom")

local draft = Draft:new_selector():add_where { "id = ?", param.get_id() }:single_object_mode():exec()
local source = param.get("source", atom.boolean)

ui.title(function()
    ui.container {
        attr = { class = "row" },
        content = function()
            ui.container {
                attr = { class = "col-md-3 text-left" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-large large_btn fixclick btn-back" },
                        module = "draft",
                        view = "list",
                        params = { initiative_id = param.get("initiative_id", atom.integer) },
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            ui.container {
                attr = { class = "col-md-8 text-center spaceline2 label label-warning fittext1" },
                content = function()
                    ui.heading {
                        level = 1,
                        content = _ "Show draft"
                    }
                end
            }
            ui.container {
                attr = { class = "col-md-1 text-center" },
                content = function()
                    ui.field.popover {
                        attr = {
                            dataplacement = "left",
                            datahtml = "true";
                            datatitle = _ "Box di aiuto per la pagina",
                            datacontent = _ "Ti trovi nel box che visualizza la bozza selezionata. Se vuoi vedere il testo non formattato clicca su <i>Sorgente</i>.",
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
            attr = { class = "col-md-3" },
            content = function()
                ui.heading { level = 3, attr = { class = "label label-warning" }, content = _ "Draft" }
            end
        }
    end
}

ui.container {
    attr = { class = "row" },
    content = function()
        ui.container {
            tag = "div",
            attr = { class = "col-md-12 well-inside paper" },
            content = function()
                execute.view {
                    module = "draft",
                    view = "_show",
                    params = { draft = draft, source = source }
                }
                ui.container {
                    attr = { class = "row" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-12" },
                            content = function()
                                ui.tag { tag = "hr" }
                            end
                        }
                    end
                }
                ui.container {
                    attr = { class = "row" },
                    content = function()
                        if source then
                            ui.link {
                                content = _ "Rendered",
                                module = "draft",
                                view = "show",
                                id = param.get_id(),
                                params = { source = false },
                                attr = { class = "col-md-offset-10 col-md-2 btn btn-primary spaceline-bottom text-center" }
                            }
                        else
                            ui.link {
                                content = _ "Source",
                                module = "draft",
                                view = "show",
                                id = param.get_id(),
                                params = { source = true },
                                attr = { class = "col-md-offset-10 col-md-2 btn btn-primary spaceline-bottom text-center" }
                            }
                        end
                    end
                }
            end
        }
    end
}

