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
                        module = "index",
                        view = "index",
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            ui.tag {
                tag = "strong",
                attr = { class = "col-md-9 text-center" },
                content = _ "Admin menu"
            }
        end
    }
end)

ui.tag {
    tag = "ul",
    content = function()
        ui.tag {
            tag = "li",
            content = function()
                ui.link {
                    text = _ "Policies",
                    module = "admin",
                    view = "policy_list",
                }
            end
        }
        ui.tag {
            tag = "li",
            content = function()
                ui.link {
                    text = _ "Units",
                    module = "admin",
                    view = "unit_list",
                }
            end
        }
        ui.tag {
            tag = "li",
            content = function()
                ui.link {
                    text = _ "Members",
                    module = "admin",
                    view = "member_list",
                }
            end
        }
        ui.tag {
            tag = "li",
            content = function()
                ui.link {
                    text = _ "Configuration",
                    module = "admin",
                    view = "configuration",
                }
            end
        }
        ui.tag {
            tag = "li",
            content = function()
                ui.link {
                    text = _ "Database Dumps",
                    module = "admin",
                    view = "download",
                }
            end
        }
    end
}
