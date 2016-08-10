slot.set_layout("custom")
local id = param.get_id()
local member = Member:by_id(id)
local member_data = MemberData:by_id(id)

if member and member.certifier_id ~= app.session.member_id then
    slot.put_into("error", _ "This user was not certified by you!")
    return false
end

local confirm_box1 = param.get("confirm_box1", atom.boolean)
local confirm_box2 = param.get("confirm_box2", atom.boolean)
local confirm_box3 = param.get("confirm_box3", atom.boolean)
local confirm_box4 = param.get("confirm_box4", atom.boolean)
local confirm_box5 = param.get("confirm_box5", atom.boolean)
local confirm_box6 = param.get("confirm_box6", atom.boolean)
local confirm_box7 = param.get("confirm_box7", atom.boolean)

if (not member or not member_data) and
        (confirm_box1 ~= true or
                confirm_box2 ~= true or
                confirm_box3 ~= true or
                confirm_box4 ~= true or
                confirm_box5 ~= true or
                confirm_box6 ~= true or
                confirm_box7 ~= true) then


    if confirm_box1 == true or
            confirm_box2 == true or
            confirm_box3 == true or
            confirm_box4 == true or
            confirm_box5 == true or
            confirm_box6 == true or
            confirm_box7 == true then
        slot.put_into("error", _ "Devi confermare tutte le clausole per continuare")
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
                                    ui.heading { level = 3, attr = { class = "uppercase" }, content = _ "Dichiarazioni obbligatorie" }
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
                attr = { class = "col-md-12 alert alert-simple issue_box paper" },
                content = function()
                    ui.form {
                        attr = { class = "", role = "form" },
                        module = "auditor",
                        view = "member_edit",
                        id = member and member.id,
                        readonly = not app.session.member.auditor,
                        content = function()
                            ui.container {
                                attr = { class = "row text-center spaceline2" },
                                content = function()
                                    ui.container {
                                        attr = { class = "col-md-12" },
                                        content = function()
                                            ui.heading { level = 1, content = _("Tu #{realname}, in qualita' di certificatore per il P.E.O. attesti che il cittadino che si vuole registrare:", { realname = app.session.member.realname }) }
                                            ui.field.boolean { style = "radio", label_attr = { class = "auditor_confirm_label spaceline2" }, label = _ "E' (o era) presente fisicamente insieme a te al momento della registrazione e il suo aspetto fisico corrisponde alla Foto e alla Descrizione del Documento di Identita' presentato", name = "confirm_box1" }
                                            ui.field.boolean { style = "radio", label_attr = { class = "auditor_confirm_label spaceline2" }, label = _ "Dichiara di essere cittadino Italiano maggiorenne", name = "confirm_box2" }
                                            ui.field.boolean { style = "radio", label_attr = { class = "auditor_confirm_label spaceline2" }, label = _ "Dichiara di essere cittadino con la residenza (indicata dal documento di identita') nella stessa regione/comune/municipio dove e'  attivo il Parlamento Elettronico Online", name = "confirm_box3" }
                                            ui.field.boolean { style = "radio", label_attr = { class = "auditor_confirm_label spaceline2" }, label = _ "Dichiara di essere utente registrato e certificato sul sito http://www.beppegrillo.it/movimento/", name = "confirm_box4" }
                                            ui.field.boolean { style = "radio", label_attr = { class = "auditor_confirm_label spaceline2" }, label = _ "Dichiara di possedere l'indirizzo email che fornira' al sistema", name = "confirm_box5" }
                                            ui.field.boolean { style = "radio", label_attr = { class = "auditor_confirm_label spaceline2" }, label = _ "Dichiara avere un Documento di Identita' valido", name = "confirm_box6" }
                                            ui.field.boolean { style = "radio", label_attr = { class = "auditor_confirm_label spaceline2" }, label = _ "Dichiara di avere con se la Tessera del Codice Fiscale o la Tessera Sanitaria con indicato il CF", name = "confirm_box7" }
                                            ui.tag {
                                                tag = "button",
                                                attr = { type = "submit", class = "btn btn-primary btn-large fixclick spaceline3" },
                                                content = function()
                                                    ui.heading { level = 4, attr = { class = "inline-block" }, content = _ "Confirm" }
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
                                        if member then
                                            slot.put(_("Edit member: #{firstname} #{lastname}", { firstname = member.firstname, lastname = member.lastname }))
                                            slot.put(" (Id:" .. member.id .. ")")
                                        else
                                            slot.put(_ "Register new member")
                                        end
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
            attr = { class = "col-md-12 alert alert-simple issue_box paper" },
            content = function()
                ui.form {
                    module = "auditor",
                    action = "member_update",
                    id = member and member.id,
                    readonly = not app.session.member.auditor,
                    routing = {
                        ok = {
                            mode = "redirect",
                            modules = "auditor",
                            view = "index"
                        }
                    },
                    content = function()
                        ui.field.hidden { name = "confirm_box1", value = confirm_box1 or false }
                        ui.field.hidden { name = "confirm_box2", value = confirm_box2 or false }
                        ui.field.hidden { name = "confirm_box3", value = confirm_box3 or false }
                        ui.field.hidden { name = "confirm_box4", value = confirm_box4 or false }
                        ui.field.hidden { name = "confirm_box5", value = confirm_box5 or false }
                        ui.field.hidden { name = "confirm_box6", value = confirm_box6 or false }
                        ui.field.hidden { name = "confirm_box7", value = confirm_box7 or false }

                        ui.heading { level = 2, attr = { class = "text-center" }, content = _ "Personal data" }
                        ui.field.text {
                            record = member,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "Name" },
                            label = _ "Name",
                            name = "firstname",
                            value = param.get("firstname")
                        }
                        ui.field.text {
                            record = member,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "Surname" },
                            label = _ "Surname",
                            name = "lastname",
                            value = param.get("lastname")
                        }
                        ui.field.text {
                            record = member,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", maxlength = "16", placeholder = _ "NIN" },
                            label = _ "NIN",
                            name = "nin",
                            value = param.get("nin")
                        }
                        ui.field.text {
                            record = member_data,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = "email@example.org" },
                            label = _ "Email",
                            name = "email",
                            value = param.get("email")
                        }
                        ui.field.text {
                            record = member_data,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "City" },
                            label = _ "Birthplace",
                            name = "birthplace",
                            value = param.get("birthplace")
                        }
                        ui.field.text {
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", maxlength = "4", placeholder = _ "yyyy" },
                            label = _ "Year of birth",
                            name = "birthyear",
                            value = param.get("birthyear", atom.integer) or (member_data and member_data.birthdate.year)
                        }
                        ui.field.text {
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", maxlength = "2", placeholder = _ "mm" },
                            label = _ "Month of birth",
                            name = "birthmonth",
                            value = param.get("birthmonth", atom.integer) or (member_data and member_data.birthdate.month)
                        }
                        ui.field.text {
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", maxlength = "2", placeholder = _ "dd" },
                            label = _ "Day of birth",
                            name = "birthday",
                            value = param.get("birthday", atom.integer) or (member_data and member_data.birthdate.day)
                        }
                        ui.field.text {
                            record = member_data,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "ID card number" },
                            label = _ "ID card number",
                            name = "idcard",
                            value = param.get("idcard")
                        }
                        ui.field.text {
                            record = member_data,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "Token Serial" },
                            label = _ "Token serial",
                            name = "token_serial",
                            value = param.get("token_serial")
                        }

                        --[[
                          Residence
                        --]]
                        ui.heading { level = 2, attr = { class = "text-center" }, content = _ "Residence" }
                        ui.field.text {
                            record = member_data,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "Residence address" },
                            label = _ "Residence address",
                            name = "residence_address",
                            value = param.get("residence_address")
                        }
                        ui.field.text {
                            record = member_data,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "Residence city" },
                            label = _ "Residence city",
                            name = "residence_city",
                            value = param.get("residence_city")
                        }
                        ui.field.text {
                            record = member_data,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "Residence province" },
                            label = _ "Residence province",
                            name = "residence_province",
                            value = param.get("residence_province")
                        }
                        ui.field.text {
                            record = member_data,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "Residence postcode" },
                            label = _ "Residence postcode",
                            name = "residence_postcode",
                            value = param.get("residence_postcode")
                        }

                        --[[
                          Domicile
                        --]]
                        ui.heading { level = 2, attr = { class = "text-center" }, content = _ "Domicile" }
                        ui.field.text {
                            record = member_data,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "Domicile address" },
                            label = _ "Domicile address",
                            name = "domicile_address",
                            value = param.get("domicile_address")
                        }
                        ui.field.text {
                            record = member_data,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "Domicile city" },
                            label = _ "Domicile city",
                            name = "domicile_city",
                            value = param.get("domicile_city")
                        }
                        ui.field.text {
                            record = member_data,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "Domicile province" },
                            label = _ "Domicile province",
                            name = "domicile_province",
                            value = param.get("domicile_province")
                        }
                        ui.field.text {
                            record = member_data,
                            label_attr = { class = "auditor_input_label" },
                            attr = { class = "auditor_input", placeholder = _ "Domicile postcode" },
                            label = _ "Domicile postcode",
                            name = "domicile_postcode",
                            value = param.get("domicile_postcode")
                        }
                        local unit_group_selector = UnitGroup:new_selector()
                        unit_group_selector:add_where("name LIKE 'Comune di %'")
                        unit_group_selector:add_order_by('name')
                        unit_groups = unit_group_selector:exec()

                        ui.field.select {
                            label = _ "Unit",
                            name = "unit_group_id",
                            foreign_records = unit_groups,
                            foreign_id = 'id',
                            foreign_name = 'name',
                            attr = { class = "auditor_input" },
                            selected_record = param.get("unit_group_id", atom.integer),
                            label_attr = { class = "auditor_input_label" }
                        }
                        --[[
                        ui.field.text{
                          record = member,
                          label_attr={class="auditor_input_label"},
                          attr={class="auditor_input",placeholder=_"Municipality ID"},
                          label = _"Unit",
                          name = "unit_group_id",
                          value = param.get("unit_group_id",atom.integer)
                        }
                        --]]


                        if not member or not member.activated then
                            ui.field.boolean { label_attr = { class = "auditor_input_label" }, label = _ "Send invite?", name = "invite_member" }
                        end

                        if member and member.activated then
                            ui.field.boolean { label_attr = { class = "auditor_input_label" }, label = _ "Lock member?", name = "locked" }
                        end
                        --[[
                        ui.field.boolean{
                          label_attr={class="auditor_input_label"},
                          label = _"Member inactive?", name = "deactivate",
                          readonly = member and member.active, value = member and member.active == false
                        }
                        --]]

                        ui.container {
                            attr = { class = "row text-center spaceline2" },
                            content = function()
                                ui.container {
                                    attr = { class = "col-md-6 col-md-offset-3" },
                                    content = function()
                                        ui.tag {
                                            tag = "button",
                                            attr = { type = "submit", class = "btn btn-primary btn-large" },
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
