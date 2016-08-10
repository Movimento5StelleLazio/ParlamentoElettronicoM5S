slot.set_layout("custom")

local initiative = Initiative:by_id(param.get("initiative_id", atom.number))

ui.title(function()
    ui.container {
        attr = { class = "row" },
        content = function()
            ui.container {
                attr = { class = "col-md-3 text-left" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-large large_btn fixclick btn-back" },
                        module = "initiative",
                        view = "show",
                        id = initiative.id,
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
                        content = _ "Drafts compare"
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
                            datacontent = _ "Ti trovi nel box che consente di confrontare le diverse versioni dei testi di una STESSA proposta. Seleziona le due versioni che vuoi confrontare e poi clicca su <i>Compara</i>",
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

ui.form {
    module = "draft",
    view = "diff",
    id = initiative.id,
    content = function()
        ui.parelon_list {
            style = "div",
            records = initiative.drafts,
            columns = {
                {
                    label = _ "Created at",
                    field_attr = { class = "col-md-2 text-center spaceline spaceline-bottom" },
                    label_attr = { class = "col-md-2 text-center" },
                    content = function(record)
                        ui.field.text {
                            readonly = true,
                            value = format.timestamp(record.created)
                        }
                    end
                },
                {
                    label = _ "Authors",
                    field_attr = { class = "col-md-5 text-center spaceline spaceline-bottom" },
                    label_attr = { class = "col-md-5 text-center" },
                    content = function(record)
                        if record.author then
                            return record.author:ui_field_text()
                        end
                    end
                },
                {
                    field_attr = { class = "col-md-1 text-center spaceline spaceline-bottom" },
                    label_attr = { class = "col-md-1 text-center" },
                    content = function(record)
                        ui.link {
                            attr = { class = "action" },
                            text = _ "Show",
                            module = "draft",
                            view = "show",
                            id = record.id,
                            params = { initiative_id = param.get("initiative_id", atom.number) }
                        }
                    end
                },
                {
                    field_attr = { class = "col-md-2 text-center spaceline spaceline-bottom" },
                    label_attr = { class = "col-md-2 text-center" },
                    label = _ "New draft",
                    content = function(record)
                        ui.field.parelon_radio {
                            name = "new_draft_id",
                            attr = {
                                class = "parelon-checkbox",
                                value = record.id
                            },
                            label_attr = { class = "parelon-label" }
                        }
                    end
                },
                {
                    field_attr = { class = "col-md-2 text-center spaceline spaceline-bottom" },
                    label_attr = { class = "col-md-2 text-center" },
                    label = _ "Old draft",
                    content = function(record)
                        ui.field.parelon_radio {
                            name = "old_draft_id",
                            attr = {
                                class = "parelon-checkbox",
                                value = record.id
                            },
                            label_attr = { class = "parelon-label" }
                        }
                    end
                }
            }
        }
        ui.container {
            attr = { class = "row spaceline" },
            content = function()
                ui.tag {
                    tag = "input",
                    attr = {
                        type = "submit",
                        class = "btn btn-primary col-md-2 col-md-offset-10",
                        value = _ "Compare",
                    }
                }
            end
        }
    end
}
