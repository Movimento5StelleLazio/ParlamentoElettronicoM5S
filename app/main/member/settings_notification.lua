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
                        content = _ "Notification settings"
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
                            datacontent = _ "In questa pagina puoi modificare le impostazioni delle notifiche da ricevere sulla tua email.",
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
    action = "update_notify_level",
    routing = {
        ok = {
            mode = "redirect",
            module = "member",
            view = "settings"
        }
    },
    content = function()
        ui.tag { tag = "p", content = _ "I like to receive notifications by email about events in my areas and issues:" }

        ui.container {
            content = function()
                ui.tag {
                    tag = "input",
                    attr = {
                        id = "notify_level_none",
                        type = "radio",
                        name = "notify_level",
                        value = "none",
                        checked = app.session.member.notify_level == 'none' and "checked" or nil
                    }
                }
                ui.tag {
                    tag = "label",
                    attr = { ['for'] = "notify_level_none" },
                    content = _ "No notifications at all"
                }
            end
        }

        slot.put("<br />")

        ui.container {
            content = function()
                ui.tag {
                    tag = "input",
                    attr = {
                        id = "notify_level_all",
                        type = "radio",
                        name = "notify_level",
                        value = "all",
                        checked = app.session.member.notify_level == 'all' and "checked" or nil
                    }
                }
                ui.tag {
                    tag = "label",
                    attr = { ['for'] = "notify_level_all" },
                    content = _ "All of them"
                }
            end
        }

        slot.put("<br />")

        ui.container {
            content = function()
                ui.tag {
                    tag = "input",
                    attr = {
                        id = "notify_level_discussion",
                        type = "radio",
                        name = "notify_level",
                        value = "discussion",
                        checked = app.session.member.notify_level == 'discussion' and "checked" or nil
                    }
                }
                ui.tag {
                    tag = "label",
                    attr = { ['for'] = "notify_level_discussion" },
                    content = _ "Only for issues reaching the discussion phase"
                }
            end
        }

        slot.put("<br />")

        ui.container {
            content = function()
                ui.tag {
                    tag = "input",
                    attr = {
                        id = "notify_level_verification",
                        type = "radio",
                        name = "notify_level",
                        value = "verification",
                        checked = app.session.member.notify_level == 'verification' and "checked" or nil
                    }
                }
                ui.tag {
                    tag = "label",
                    attr = { ['for'] = "notify_level_verification" },
                    content = _ "Only for issues reaching the frozen phase"
                }
            end
        }

        slot.put("<br />")

        ui.container {
            content = function()
                ui.tag {
                    tag = "input",
                    attr = {
                        id = "notify_level_voting",
                        type = "radio",
                        name = "notify_level",
                        value = "voting",
                        checked = app.session.member.notify_level == 'voting' and "checked" or nil
                    }
                }
                ui.tag {
                    tag = "label",
                    attr = { ['for'] = "notify_level_voting" },
                    content = _ "Only for issues reaching the voting phase"
                }
            end
        }

        slot.put("<br />")
        ui.tag {
            tag = "input",
            attr = {
                type = "submit",
                class = "col-md-offset-4 btn btn-primary btn-large large_btn",
                value = _ "Change notification settings"
            }
        }
    end
}
 
