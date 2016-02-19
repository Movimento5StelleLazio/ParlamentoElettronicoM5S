slot.select('navbar', function()
    ui.container {
        attr = { class = "row-fluid" },
        content = function()
            ui.container {
                attr = { class = "span5" },
                content = function()
                    ui.link {
                        module = 'index',
                        view = 'index',
                        image = { static = "logo_withe.png" },
                        text = ""
                    }
					end
				}
            ui.container {
                attr = { class = "span4 text-right spaceline" },
                content = function()
						ui.link {
							content = function()
							slot.put(_"<a class='color-menu' href='https://www.parelon.com/?project=sincronizzare-il-token&lang=it' target='_blank'>Registrati</a><a class='color-menu' href='https://www.parelon.com' target='_blank'> | Chi siamo</a><a class='color-menu'  href='https://www.parelon.com/?project=primo-accesso&lang=it' target='_blank'> | Tutorial</a><a class='color-menu'  href='https://www.kapipal.com/d92dbc7a90f540d7b98f55c11ba15ab2' target='_blank'> | Fai una donazione</a>")
						end
						}
					end
				}
            ui.container {
                attr = { class = "span3" },
                content = function()
                    ui.container {
                        attr = { class = "nav pull-left" },
                        content = function()
                            ui.tag {
                                tag = "a",
                                attr = { datatoggle = "dropdown", class = "pull-left spaceline label label-warning fixclick btn-dropdown-toggle" },
                                module = "index",
                                view = "menu_ext",
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
                            execute.view { module = "index", view = "_menu_ext" }
                        end
                    }
                        end
                    }


                end
            }

end)

slot.select("footer_bs", function()
    if app.session.member_id and app.session.member.admin then
        ui.link {
            text = _ "Admin",
            module = 'admin',
            view = 'index'
        }
        slot.put(" &middot; ")
    end
    ui.link {
        text = _ "About site",
        module = 'index',
        view = 'about'
    }
    if config.use_terms then
        slot.put(" &middot; ")
        ui.link {
            text = _ "Use terms",
            module = 'index',
            view = 'usage_terms'
        }
    end
    slot.put(" &middot; ")
    ui.tag { content = _ "This site is using" }
    slot.put(" ")
    ui.link {
        text = _ "LiquidFeedback",
        external = "http://www.public-software-group.org/liquid_feedback"
    }
end)

execute.inner()
