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
                                        content = _ "Edit my profile"
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
                            datacontent = _ "Qui puoi modificare il tuo profilo. Quando hai finito le modifiche, clicca su <i>Salva</i> per applicarle.",
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

 ui.container {
        attr = { class = "row" },
        content = function()
         ui.container {
		        attr = { class = "well" },
		        content = function()

						ui.form {
						    record = app.session.member,
						    attr = { class = "vertical" },
						    module = "member",
						    action = "update",
						    routing = {
						        ok = {
						            mode = "redirect",
						            module = "member",
						            view = "show",
						            id = app.session.member_id
						        }
						    },
						    content = function()
						        ui.field.text { label = _ "Identification", name = "identification", readonly = true }
						        ui.field.text { label = _ "Organizational unit", name = "organizational_unit", readonly = config.locked_profile_fields.organizational_unit }
						        ui.field.text { label = _ "Internal posts", name = "internal_posts", readonly = config.locked_profile_fields.internal_posts }
						        ui.field.text { label = _ "Real name", name = "realname", readonly = config.locked_profile_fields.realname }
						        ui.field.text { label = _ "Birthday" .. " YYYY-MM-DD ", name = "birthday", attr = { id = "profile_birthday" }, readonly = config.locked_profile_fields.birthday }
						        ui.script { static = "gregor.js/gregor.js" }
						        util.gregor("profile_birthday", "document.getElementById('timeline_search_date').form.submit();")
						        ui.field.text { label = _ "Address", name = "address", multiline = true, readonly = config.locked_profile_fields.address }
						        ui.field.text { label = _ "email", name = "email", readonly = config.locked_profile_fields.email }
						        ui.field.text { label = _ "xmpp", name = "xmpp_address", readonly = config.locked_profile_fields.xmpp_address }
						        ui.field.text { label = _ "Website", name = "website", readonly = config.locked_profile_fields.website }
						        ui.field.text { label = _ "Phone", name = "phone", readonly = config.locked_profile_fields.phone }
						        ui.field.text { label = _ "Mobile phone", name = "mobile_phone", readonly = config.locked_profile_fields.mobile_phone }
						        ui.field.text { label = _ "Profession", name = "profession", readonly = config.locked_profile_fields.profession }
						        ui.field.text { label = _ "External memberships", name = "external_memberships", multiline = true, readonly = config.locked_profile_fields.external_memberships }
						        ui.field.text { label = _ "External posts", name = "external_posts", multiline = true, readonly = config.locked_profile_fields.external_posts }
						
						        ui.field.select {
						            label = _ "Wiki engine for statement",
						            name = "formatting_engine",
						            foreign_records = {
						                { id = "rocketwiki", name = "RocketWiki" },
						                { id = "compat", name = _ "Traditional wiki syntax" }
						            },
						            attr = { id = "formatting_engine" },
						            foreign_id = "id",
						            foreign_name = "name",
						            value = param.get("formatting_engine")
						        }
						        ui.tag {
						            tag = "div",
						            content = function()
						                ui.tag {
						                    tag = "label",
						                    attr = { class = "ui_field_label " },
						                    content = function() slot.put("&nbsp;") end,
						                }
						                ui.tag {
						                    content = function()
						                        ui.link {
						                            text = _ "Syntax help",
						                            module = "help",
						                            view = "show",
						                            id = "wikisyntax",
						                            attr = { onClick = "this.href=this.href.replace(/wikisyntax[^.]*/g, 'wikisyntax_'+getElementById('formatting_engine').value)" }
						                        }
						                        slot.put(" ")
						                        ui.link {
						                            text = _ "(new window)",
						                            module = "help",
						                            view = "show",
						                            id = "wikisyntax",
						                            attr = { target = "_blank", onClick = "this.href=this.href.replace(/wikisyntax[^.]*/g, 'wikisyntax_'+getElementById('formatting_engine').value)" }
						                        }
						                    end
						                }
						            end
						        }
						        ui.field.text {
						            label = _ "Statement",
						            name = "statement",
						            multiline = true,
						            attr = { style = "height: 50ex;" },
						            value = param.get("statement")
						        }
						
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
    end
}
    end
}