slot.set_layout("custom")

ui.title(function()
    ui.container {
        attr = { class = "row" },
        content = function()
            ui.container {
                attr = { class = "col-md-3 text-left" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-large large_btn fixclick btn-back" },
                        module = "member",
                        view = "show",
                        id = app.session.member_id,
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            ui.container {
                attr = { class = "col-md-8 spaceline2" },
                content = function()
                    ui.container {
                        attr = { class = "row" },
                        content = function()
                            ui.container {
                                attr = { class = "col-md-12 label label-warning text-center" },
                                content = function()
                                    ui.heading {
                                        level = 1,
                                        attr = { class = "fittext1 uppercase " },
                                        content = _ "Upload images"
                                    }
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
                            datacontent = _ "Qui puoi modificare l'avatar e la foto del tuo profilo. Quando hai finito le modifiche, clicca su <i>Salva</i> per applicarle.",
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
    record = app.session.member,
    attr = {
        class = "vertical",
        enctype = 'multipart/form-data'
    },
    module = "member",
    action = "update_images",
    routing = {
        ok = {
            mode = "redirect",
            module = "member",
            view = "show",
            id = app.session.member_id
        }
    },
    content = function()
        execute.view {
            module = "member_image",
            view = "_show",
            params = {
                member = app.session.member,
                image_type = "avatar"
            }
        }
        ui.field.image { field_name = "avatar", label = _ "Avatar" }
        execute.view {
            module = "member_image",
            view = "_show",
            params = {
                member = app.session.member,
                image_type = "photo"
            }
        }
        ui.field.image { field_name = "photo", label = _ "Photo" }
        ui.tag {
            tag = "input",
            attr = {
                type = "submit",
                class = "col-md-offset-4 btn btn-primary btn-large large_btn",
                value = _ "Save"
            }
        }
    end
}