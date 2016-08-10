slot.set_layout("custom")

local initiative = Initiative:by_id(param.get_id())

ui.title(function()
    ui.container {
        attr = { class = "row" },
        content = function()
            ui.container {
                attr = { class = "col-md-3 text-left" },
                content = function()
                    ui.link {
                        attr = {
                            class = "btn btn-primary btn-large large_btn fixclick btn-back"
                        },
                        module = "initiative",
                        view = "show",
                        id = initiative.id,
                        params = {
                            tab = "initiators"
                        },
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            ui.container {
                attr = { class = "col-md-8 text-center label label-warning spaceline2 spaceline-bottom fittext1" },
                content = function()
                    ui.heading {
                        level = 1,
                        attr = { class = "" },
                        content = _ "Revoke initiative"
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
                            datacontent = _ "Here you can <i>withdraw</i> your initiative.",
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
    attr = { class = "vertical", id = "revoke_form" },
    module = "initiative",
    action = "revoke",
    id = initiative.id,
    routing = {
        ok = {
            mode = "redirect",
            module = "initiative",
            view = "show",
            id = initiative.id
        }
    },
    content = function()
        local initiatives = app.session.member:get_reference_selector("supported_initiatives"):join("issue", nil, "issue.id = initiative.issue_id"):add_field("'Issue #' || issue.id || ': ' || initiative.name", "myname"):exec()

        local tmp = { { id = -1, myname = _ "Suggest no initiative" } }
        for i, initiative in ipairs(initiatives) do
            tmp[#tmp + 1] = initiative
        end
        ui.field.select {
            label = _ "Suggested initiative",
            name = "suggested_initiative_id",
            foreign_records = tmp,
            foreign_id = "id",
            foreign_name = "myname",
            value = param.get("suggested_initiative_id", atom.integer)
        }
        ui.container {
            attr = { class = "row spaceline2" },
            content = function()
                ui.heading {
                    level = 2,
                    attr = { class = "col-md-6" },
                    content = _ "Are you sure that you want to withdraw your initiative?"
                }
                ui.link {
                    attr = {
                        class = "col-md-2 btn-primary btn text-center",
                        onclick = "getElementById('revoke_form').submit()"
                    },
                    external = "#",
                    image = { attr = { class = "col-md-3" }, static = "png/ok.png" },
                    content = _ "Yes, I am sure"
                }

                ui.link {
                    attr = { class = "col-md-offset-1 col-md-2 btn-primary btn text-center" },
                    module = "initiative",
                    view = "show",
                    id = initiative.id,
                    params = {
                        tab = "initiators"
                    },
                    image = { attr = { class = "col-md-3" }, static = "png/cross.png" },
                    content = _ "No, I am not"
                }
            end
        }
    end
}