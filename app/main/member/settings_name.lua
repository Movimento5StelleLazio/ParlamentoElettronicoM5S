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
                        content = _ "Change your screen name"
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
                            datacontent = _ "In questa pagina puoi modificare il tuo nome pubblico. Il tuo nome vero non sarà modificato da questa impostazione e sarà comunque visibile nella pagina del tuo profilo.",
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
    action = "update_name",
    routing = {
        ok = {
            mode = "redirect",
            module = "member",
            view = "settings"
        }
    },
    content = function()
        ui.field.text { label = _ "Name", name = "name", value = app.session.member.name }
        ui.tag {
            tag = "input",
            attr = {
                type = "submit",
                class = "col-md-offset-4 btn btn-primary btn-large large_btn",
                value = _ "Change name"
            }
        }
    end
}
