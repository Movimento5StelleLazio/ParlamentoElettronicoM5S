                  ui.container {
                        attr = { class = "dropdown" },
                        content = function()
                            ui.tag {
										tag = "button",
                                attr = { datatoggle = "dropdown", class = "spaceline btn btn-default dropdown-toggle", type(button) },
                                content = function()
                                    if app.session.member_id then
                                        execute.view {
                                            module = "member_image",
                                            view = "_show",
                                            params = {
                                                member = app.session.member,
                                                image_type = "avatar",
                                                show_dummy = true,
                                                class = "micro_avatar",
                                            }
                                        }
                                        slot.put("&nbsp;" .. app.session.member.name)
                                    else
                                        --								ui.tag{ tag ="i" , attr = { class = "iconic black flag" }, content=""}
                                        slot.put("&nbsp;" .. _ "Login")
                                    end
                                end
                            }
										ui.tag {
										    tag = "ul",
										    attr = { class = "dropdown-menu" },
										    content = function()
										
										        if app.session.member_id then
										            ui.tag {
										                tag = "li",
										                content = function()
										
										                    ui.link {
										                        text = _ "Show profile",
										                        module = "member",
										                        view = "show",
										                        id = app.session.member_id
										                    }
										                end
										            }
										
										            ui.tag {
										                tag = "li",
										                content = function()
										
										                    ui.link {
										                        content = function()
										                            slot.put(_ "Edit profile")
										                        end,
										                        module = "member",
										                        view = "edit"
										                    }
										                end
										            }
										
										            ui.tag {
										                tag = "li",
										                content = function()
										
										                    ui.link {
										                        content = function()
										                            slot.put(_ "Upload avatar/photo")
										                        end,
										                        module = "member",
										                        view = "edit_images"
										                    }
										                end
										            }
										
										            ui.tag {
										                tag = "li",
										                content = function()
										
										                    ui.link {
										                        content = _ "Contacts",
										                        module = 'contact',
										                        view = 'list'
										                    }
										                end
										            }
										
										            ui.tag {
										                tag = "li",
										                content = function()
										
										                    ui.link {
										                        text = _ "Settings",
										                        module = "member",
										                        view = "settings"
										                    }
										                end
										            }
										
										            ui.tag {
										                tag = "li",
										                content = function()
										
										                    ui.link {
										                        text = _ "Logout",
										                        attr = { style = "font-weight: bold;" },
										                        module = 'index',
										                        action = 'logout',
										                        routing = {
										                            default = {
										                                mode = "redirect",
										                                module = "index",
										                                view = "index"
										                            }
										                        }
										                    }
										                end
										            }
										        else
										            ui.tag {
										                tag = "li",
										                content = function()
										
										                    ui.link {
										                        text = _ "Login",
										                        attr = { style = "font-weight: bold;" },
										                        module = 'index',
										                        view = 'login',
										                        routing = {
										                            ok = {
										                                mode = "forward",
										                                module = request.get_module(),
										                                view = request.get_view()
										                            },
										                            error = {
										                                mode = "redirect",
										                                module = "index",
										                                view = "login"
										                            }
										                        }
										                    }
										                end
										            }
										        end
										
										        ui.tag {
										            tag = "li",
										            content = function()
										
										                ui.link {
										                    text = _ "Show members",
										                    module = "member",
										                    view = "list"
										                }
										            end
										        }
										
										        for i, lang in ipairs(config.enabled_languages) do
										
										            local langcode
										
										            locale.do_with({ lang = lang }, function()
										                langcode = _("[Name of Language]")
										            end)
										
										            ui.tag {
										                tag = "li",
										                content = function()
										                    ui.link {
										                        content = langcode,
										                        module = "index",
										                        action = "set_lang",
										                        params = { lang = lang },
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
										        end
										    end
}                        
end
                    }