slot.set_layout("custom")

local issue = Issue:by_id(param.get("issue_id", atom.number))

ui.title(function()
    ui.container {
        attr = { class = "row" },
        content = function()
            ui.container {
                attr = { class = "col-md-3 text-left" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-large large_btn fixclick btn-back" },
                        module = "issue",
                        view = "show_ext_bs",
                        id = issue.id,
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
                        content = _ "Initiatives comparison"
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
                            datacontent = _ "Ti trovi nel box che consente di confrontare le differenti proposte di una STESSA questione. Seleziona le due versioni che vuoi confrontare e poi clicca su <i>Compara</i>",
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
    module = "initiative",
    view = "diff",
    id = issue.id,
    content = function()
        ui.parelon_list {
            style = "div",
            records = issue.initiatives,
            columns = {
                {
                    label = _ "Initiative Title",
                    field_attr = { class = "col-md-2 text-center spaceline spaceline-bottom" },
                    label_attr = { class = "col-md-2 text-center" },
                    content = function(record)
                        ui.field.text {
                            readonly = true,
                            value = record.title
                        }
                    end
                },
                {
                    label = _ "Authors",
                    field_attr = { class = "col-md-5 text-center spaceline spaceline-bottom" },
                    label_attr = { class = "col-md-5 text-center" },
                    content = function(record)
                        if record.initiators then
                            local authors = ""
                            for i, initiator in ipairs(record.initiators) do
                                authors = authors .. initiator.member.name .. ";"
                            end
                            return ui.field.text {
                                readonly = true,
                                value = authors
                            }
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
                            module = "initiative",
                            view = "show",
                            id = record.id,
                            params = { initiative_id = record.id }
                        }
                    end
                },
                {
                    field_attr = { class = "col-md-2 text-center spaceline spaceline-bottom" },
                    label_attr = { class = "col-md-2 text-center" },
                    label = _ "First initiative",
                    content = function(record)
                        ui.field.parelon_radio {
                            name = "first_initiative_id",
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
                    label = _ "Second initiative",
                    content = function(record)
                        ui.field.parelon_radio {
                            name = "second_initiative_id",
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
