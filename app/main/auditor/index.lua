slot.set_layout("custom")
ui.container {
    attr = { class = "row" },
    content = function()
        ui.container {
            attr = { class = "col-md-12 well" },
            content = function()
                ui.container {
                    attr = { class = "row" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-12 text-center" },
                            content = function()
                                ui.heading { level = 1, attr = { class = "uppercase" }, content = _ "Auditor Panel" .. " ID:" .. app.session.member_id }
                                ui.heading { level = 3, attr = { class = "" }, content = _ "Your certified users" }
                            end
                        }
                    end
                }
                ui.container {
                    attr = { class = "row text-center" },
                    content = function()

                        ui.container {
                            attr = { class = "inline-block", style = "margin: 5px;" },
                            content = function()
                                ui.link {
                                    attr = { class = "btn btn-primary btn-large table-cell fixclick" },
                                    module = "auditor",
                                    view = "download",
                                    content = function()
                                        ui.heading { level = 5, attr = { class = "" }, content = "Download Data" }
                                    end
                                }
                            end
                        }
                        ui.container {
                            attr = { class = "inline-block", style = "margin: 5px;" },
                            content = function()
                                ui.link {
                                    attr = { class = "btn btn-primary btn-large table-cell fixclick" },
                                    module = "auditor",
                                    view = "member_edit",
                                    content = function()
                                        ui.heading { level = 5, attr = { class = "" }, content = _ "Nuovo utente" }
                                    end
                                }
                            end
                        }
                        ui.container {
                            attr = { class = "inline-block", style = "margin: 5px;" },
                            content = function()
                                ui.link {
                                    attr = { class = "btn btn-primary btn-large table-cell fixclick" },
                                    module = "index",
                                    action = "logout",
                                    content = function()
                                        ui.heading { level = 5, attr = { class = "" }, content = _ "Logout" }
                                    end
                                }
                            end
                        }
                    end
                }
            end
        }
    end
}

ui.container {
    attr = { class = "row spaceline2" },
    content = function()
        ui.container {
            attr = { class = "col-md-12 alert alert-simple issue_box paper text-center" },
            content = function()
                local members_selector = Member:new_selector()
                members_selector:add_where { "certifier_id = ?", app.session.member_id }
                members_selector:add_order_by { "id" }
                members = members_selector:exec()

                if #members == 0 then
                    ui.heading { level = 5, content = _ "There are no users certified by you" }
                else
                    ui.container {
                        attr = { class = "inline-block" },
                        content = function()

                            ui.paginate {
                                selector = members_selector,
                                per_page = 30,
                                content = function()
                                    ui.list {
                                        records = members,
                                        columns = {
                                            {
                                                field_attr = { style = "padding-left: 5px;padding-right: 5px;text-align: right;border: 1px solid black;" },
                                                label = _ "Id",
                                                name = "id"
                                            },
                                            {
                                                field_attr = { style = "padding-left: 5px;padding-right: 5px;border: 1px solid black;" },
                                                label = _ "Name",
                                                name = "firstname"
                                            },
                                            {
                                                field_attr = { style = "padding-left: 5px;padding-right: 5px;border: 1px solid black;" },
                                                label = _ "Surname",
                                                name = "lastname"
                                            },
                                            {
                                                field_attr = { style = "padding-left: 5px;padding-right: 5px;border: 1px solid black;" },
                                                label = _ "NIN",
                                                name = "nin"
                                            },
                                            {
                                                field_attr = { style = "padding-left: 5px;padding-right: 5px;border: 1px solid black;" },
                                                label = _ "State",
                                                content = function(record)
                                                    if not record.activated then
                                                        ui.field.text { value = "not activated" }
                                                    elseif not record.active then
                                                        ui.field.text { value = "inactive" }
                                                    else
                                                        ui.field.text { value = "active" }
                                                    end
                                                end
                                            },
                                            {
                                                field_attr = { style = "padding-left: 5px;padding-right: 5px;border: 1px solid black;" },
                                                label = _ "Locked?",
                                                content = function(record)
                                                    if record.locked then
                                                        ui.field.text { value = "locked" }
                                                    end
                                                end
                                            },
                                            {
                                                field_attr = { style = "padding-left: 5px;padding-right: 5px;border: 1px solid black;" },
                                                label = _ "Actions",
                                                content = function(record)
                                                    ui.link {
                                                        attr = { class = "btn btn-primary btn-mini btn_mini_margin action admin_only" },
                                                        text = _ "Edit",
                                                        module = "auditor",
                                                        view = "member_edit",
                                                        id = record.id
                                                    }
                                                    ui.link {
                                                        attr = { class = "btn btn-primary btn-mini btn_mini_margin  action admin_only" },
                                                        text = _ "Idcard scans",
                                                        module = "auditor",
                                                        view = "idcard_scans",
                                                        id = record.id
                                                    }
                                                end
                                            }
                                        }
                                    }
                                end
                            }
                        end
                    }
                end
            end
        }
    end
}

