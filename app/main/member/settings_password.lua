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
                        view = "settings",
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }

            ui.container {
                attr = { class = "col-md-8 spaceline2 text-center label label-warning" },
                content = function()
                    ui.heading {
                        level = 1,
                        attr = { class = "fittext1 uppercase" },
                        content = _ "Change your password"
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
                            datacontent = _ "In questa pagina puoi modificare la tua password.",
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
    attr = { class = "vertical" },
    module = "member",
    action = "update_password",
    routing = {
        ok = {
            mode = "redirect",
            module = "member",
            view = "settings"
        }
    },
    content = function()
        ui.field.password { label = _ "Old password", name = "old_password" }
        ui.field.password { label = _ "New password", name = "new_password1" }
        ui.field.password { label = _ "Repeat new password", name = "new_password2" }
        ui.tag {
            tag = "input",
            attr = {
                type = "submit",
                class = "col-md-offset-4 btn btn-primary btn-large large_btn",
                value = _ "Change password"
            }
        }
    end
}