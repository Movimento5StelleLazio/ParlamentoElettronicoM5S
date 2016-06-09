slot.set_layout("custom")
local member_id = param.get_id()
local member = Member:by_id(member_id)

if not member then
    slot.put_into("error", _ "User does not exists")
    return false
end

if member and member.certifier_id ~= app.session.member_id then
    slot.put_into("error", _ "This user was not certified by you!")
    return false
end

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
                            attr = { class = "col-md-3 text-center" },
                            content = function()
                                ui.link {
                                    attr = { class = "btn btn-primary btn-large fixclick" },
                                    module = "auditor",
                                    view = "index",
                                    content = function()
                                        ui.heading {
                                            level = 5,
                                            attr = { class = "" },
                                            content = function()
                                                ui.image { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" }
                                                slot.put(_ "Back")
                                            end
                                        }
                                    end
                                }
                            end
                        }
                        ui.container {
                            attr = { class = "col-md-9 text-center" },
                            content = function()
                                ui.heading { level = 1, attr = { class = "uppercase" }, content = _ "Auditor Panel" .. " ID:" .. app.session.member_id }
                                ui.heading {
                                    level = 3,
                                    attr = { class = "" },
                                    content = function()
                                        slot.put(_("Upload scans for member: #{firstname} #{lastname}", { firstname = member.firstname, lastname = member.lastname }))
                                        slot.put(" (Id:" .. member_id .. ")")
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
                ui.container {
                    attr = { class = "row text-center" },
                    content = function()
                        ui.container {
                            attr = { class = "inline-block text-left" },
                            content = function()
                                ui.heading {
                                    level = 5,
                                    content = function()
                                        slot.put("Scansioni obbligatorie da caricare:",
                                            "<ul>",
                                            "<li>Documento d'identit&agrave (fronte)</li>",
                                            "<li>Documento d'identit&agrave (retro)</li>",
                                            "<li>Foto del documento d'identit&agrave</li>",
                                            "<li>Codice Fiscale e/o Tessera Sanitaria</li>",
                                            "</ul>")
                                    end
                                }
                            end
                        }
                    end
                }
                ui.form {
                    record = app.session.member,
                    attr = {
                        class = "vertical spaceline2",
                        enctype = 'multipart/form-data'
                    },
                    module = "auditor",
                    action = "update_scans",
                    routing = {
                        ok = {
                            mode = "redirect",
                            module = "auditor",
                            view = "index",
                            id = app.session.member_id
                        }
                    },
                    content = function()
                    --[[
                    execute.view{
                      module = "member_image",
                      view = "_show",
                      params = {
                        member = app.session.member,
                        image_type = "avatar"
                      }
                    }
                    --]]
                    -- 'id_front','id_rear','id_picture','nin','health_insurance'
                        ui.field.hidden { name = "member_id", value = member_id }
                        ui.image { attr = { class = "idcard_scan" }, module = "idcard_scan", view = "show", id = member_id, params = { scan_type = "id_front" } }
                        ui.field.image { field_name = "id_front", label = _ "Idcard scan (front)" }
                        ui.image { attr = { class = "idcard_scan spaceline3" }, module = "idcard_scan", view = "show", id = member_id, params = { scan_type = "id_rear" } }
                        ui.field.image { field_name = "id_rear", label = _ "Idcard scan (rear)" }
                        ui.image { attr = { class = "idcard_scan spaceline3" }, module = "idcard_scan", view = "show", id = member_id, params = { scan_type = "id_picture" } }
                        ui.field.image { field_name = "id_picture", label = _ "Idcard picture scan" }
                        ui.image { attr = { class = "idcard_scan spaceline3" }, module = "idcard_scan", view = "show", id = member_id, params = { scan_type = "nin" } }
                        ui.field.image { field_name = "nin", label = _ "NIN card scan" }
                        ui.image { attr = { class = "idcard_scan spaceline3" }, module = "idcard_scan", view = "show", id = member_id, params = { scan_type = "health_insurance" } }
                        ui.field.image { field_name = "health_insurance", label = _ "Health Insurance card scan" }

                        ui.container {
                            attr = { class = "row text-center spaceline2" },
                            content = function()
                                ui.container {
                                    attr = { class = "col-md-6 col-md-offset-3" },
                                    content = function()
                                        ui.tag {
                                            tag = "button",
                                            attr = { type = "submit", class = "btn btn-primary btn-large fixclick" },
                                            content = function()
                                                ui.heading { level = 4, attr = { class = "inline-block" }, content = _ "Save" }
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
    end
}
