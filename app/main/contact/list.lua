local contacts_selector = Contact:build_selector {
    member_id = app.session.member_id,
    order = "name"
}

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
                attr = { class = "col-md-8 spaceline2 text-center label label-warning" },
                content = function()
                    ui.heading {
                        level = 1,
                        attr = { class = "fittext1 uppercase" },
                        content = _ "Contacts"
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
                            datacontent = _ "Qui puoi la visibilità pubblica dei tuoi contatti.",
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

ui.paginate {
    selector = contacts_selector,
    content = function()
        local contacts = contacts_selector:exec()
        if #contacts == 0 then
            ui.field.text { value = _ "You didn't save any member as contact yet." }
        else
            ui.parelon_list {
                records = contacts,
                style = "div",
                columns = {
                    {
                        label = _ "Name",
                        field_attr = { class = "col-md-5 text-center spaceline spaceline-bottom" },
                        label_attr = { class = "col-md-5 text-center" },
                        content = function(record)
                            ui.link {
                                text = record.other_member.name,
                                module = "member",
                                view = "show",
                                id = record.other_member_id
                            }
                        end
                    },
                    {
                        label = _ "Published",
                        field_attr = { class = "col-md-2 text-center spaceline spaceline-bottom" },
                        label_attr = { class = "col-md-2 text-center" },
                        content = function(record)
                            ui.field.boolean { value = record.public }
                        end
                    },
                    {
                        field_attr = { class = "col-md-2 text-center" },
                        label_attr = { class = "col-md-2 text-center" },
                        content = function(record)
                            if record.public then
                                ui.link {
                                    attr = { class = "action btn btn-primary btn-large large_btn fixclick" },
                                    text = _ "Hide",
                                    module = "contact",
                                    action = "add_member",
                                    id = record.other_member_id,
                                    params = { public = false },
                                    routing = {
                                        default = {
                                            mode = "redirect",
                                            module = request.get_module(),
                                            view = request.get_view(),
                                            id = param.get_id_cgi(),
                                            params = param.get_all_cgi()
                                        }
                                    }
                                }
                            else
                                ui.link {
                                    attr = { class = "action btn btn-primary btn-large large_btn fixclick" },
                                    text = _ "Publish",
                                    module = "contact",
                                    action = "add_member",
                                    id = record.other_member_id,
                                    params = { public = true },
                                    routing = {
                                        default = {
                                            mode = "redirect",
                                            module = request.get_module(),
                                            view = request.get_view(),
                                            id = param.get_id_cgi(),
                                            params = param.get_all_cgi()
                                        }
                                    }
                                }
                            end
                        end
                    },
                    {
                        field_attr = { class = "col-md-3 text-center" },
                        label_attr = { class = "col-md-3 text-center" },
                        content = function(record)
                            ui.link {
                                attr = { class = "action btn btn-primary btn-large large_btn fixclick" },
                                text = _ "Remove",
                                module = "contact",
                                action = "remove_member",
                                id = record.other_member_id,
                                routing = {
                                    default = {
                                        mode = "redirect",
                                        module = request.get_module(),
                                        view = request.get_view(),
                                        id = param.get_id_cgi(),
                                        params = param.get_all_cgi()
                                    }
                                }
                            }
                        end
                    }
                }
            }
        end
    end
}
