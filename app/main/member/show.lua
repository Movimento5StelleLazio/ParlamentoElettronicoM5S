slot.set_layout("custom")

local member = Member:by_id(param.get_id())

if not member or not member.activated then
    error("access denied")
end

app.html_title.title = member.name
app.html_title.subtitle = _("Member")

ui.title(function()
    ui.container {
        attr = { class = "row" },
        content = function()
            ui.container {
                attr = { class = "col-md-3  col-sm-4 text-center hidden-xs" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-back fixclick" },
                        module = "index",
                        view = "index",
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            ui.container {
                attr = { class = "col-md-8 col-xs-12 col-sm-8 well-inside paper spaceline" },
                content = function()
                    ui.container {
                        attr = { class = "row text-center" },
                        content = function()
                                    ui.heading {
                                        level = 1,
                                        attr = { class = "fittext1 uppercase " },
                                        content = _("#{member}", { member = member.name })
                                    }

                        end
                    }
                end
            }
            ui.container {
                attr = { class = "col-xs-12 visible-xs text-center" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-back fixclick" },
                        module = "index",
                        view = "index",
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            ui.container {
                attr = { class = "col-md-1 text-center spaceline hidden-xs hidden-sm" },
                content = function()
                    ui.field.popover {
                        attr = {
                            dataplacement = "left",
                            datahtml = "true";
                            datatitle = _ "Box di aiuto per la pagina",
                            datacontent = _ "Stai visualizzando il <i>profilo utente</i>. Qui puoi <i>modificare il tuo profilo</i>, il tuo avatar, <i>ignorare</i> un utente, <i>aggiungerlo ai tuoi contatti</i> per invitarlo come co-autore, <i>visualizzare</i> ogni dettaglio dell'attività tua o di un altro utente.",
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
    ui.container {
        attr = { class = "row spaceline text-center" },
        content = function()
            ui.link {
                attr = { class = "btn btn-primary large_btn fixclick margin_line spaceline" },
                content = _ "Show member history",
                module = "member",
                view = "history",
                id = member.id
            }
            if not member.active then
                ui.tag {
                    attr = { class = "btn btn-primary  large_btn interest deactivated_member_info margin_line spaceline" },
                    content = _ "This member is inactive"
                }
            end
            if member.locked then
                ui.tag {
                    attr = { class = "btn btn-primary  large_btn interest deactivated_member_info margin_line spaceline" },
                    content = _ "This member is locked"
                }
            end
            if app.session.member_id and not (member.id == app.session.member.id) then
                --TODO performance
                local contact = Contact:by_pk(app.session.member.id, member.id)
                if contact then
                    ui.link {
                        attr = { class = "btn btn-primary  large_btnfixclick margin_line spaceline" },
                        text = _ "Remove from contacts",
                        module = "contact",
                        action = "remove_member",
                        id = contact.other_member_id,
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
                elseif member.activated then
                    ui.link {
                        attr = { class = "btn btn-primary  large_btn fixclick margin_line spaceline" },
                        text = _ "Add to my contacts",
                        module = "contact",
                        action = "add_member",
                        id = member.id,
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
                local ignored_member = IgnoredMember:by_pk(app.session.member.id, member.id)
                if ignored_member then
                    ui.tag {
                        attr = { class = "interest" },
                        content = _ "You have ignored this member"
                    }
                    ui.link {
                        attr = { class = "col-md-3 btn btn-primary  large_btn fixclick margin_line spaceline" },
                        text = _ "Stop ignoring member",
                        module = "member",
                        action = "update_ignore_member",
                        id = member.id,
                        params = { delete = true },
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
                elseif member.activated then
                    ui.link {
                        attr = { class = "interest btn btn-primary  large_btn fixclick margin_line spaceline" },
                        text = _ "Ignore member",
                        module = "member",
                        action = "update_ignore_member",
                        id = member.id,
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
            if member.id == app.session.member_id then
                ui.link {
                    attr = { class = "btn btn-primary  large_btn fixclick margin_line spaceline" },
                    content = _ "Edit profile",
                    module = "member",
                    view = "edit"
                }
                ui.link {
                    attr = { class = "btn btn-primary  large_btn fixclick margin_line spaceline" },
                    content = _ "Upload avatar/photo",
                    module = "member",
                    view = "edit_images"
                }
            end
        end
    }
end)

execute.view {
    module = "member",
    view = "_show",
    params = { member = member }
}

