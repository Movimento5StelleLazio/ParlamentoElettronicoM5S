slot.set_layout("custom")

if not app.session.member_id then
    ui.container {
        attr = { class = "row-fluid" },
        content = function()
            ui.container {
                attr = { class = "text-center span8 offset2 well-title" },
                content = function()
                    ui.container {
                        attr = { class = "row-fluid" },
                        content = function()
                            ui.container {
                                attr = { class = "span12" },
                                content = function()
                                    ui.heading {
                                        level = 1,
                                        content = function()
                                            slot.put(_ "5 STARS MOVEMENT E-PARLIAMENT REGIONE LAZIO")
                                        end
                                    }
                                end
                            }
                        end
                    }
                    ui.container {
                        attr = { class = "row-fluid" },
                        content = function()
                            ui.container {
                                attr = { class = "span12" },
                                content = function()
                                    ui.heading {
                                        level = 5,
                                        content = function()
                                            ui.tag { attr = { class = "pull-right" }, tag = "small", content = "Versione 0.5" }
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

if app.session.member_id then
    --util.help("index.index", _"Home")
    local member = Member:by_id(app.session.member.id)
    execute.view {
        module = "index",
        view = "_notifications"
    }

    ui.container {
        attr = { class = "row-fluid" },
        content = function()
            ui.script { static = "js/position.js" }

            local curLogin = member:get_login_data('last')

            -- Demo data start
            --------------------------------------------------------------------------
            --[[if not curLogin or not curLogin.geolat or not curLogin.geolng or not curLogin.login_time  then
              curLogin = { member_id = member.id, geolat = "41.87499810", geolng = "12.51125750", login_time = atom.timestamp:load("2013-07-10 18:05:55") }
            end]]
            --------------------------------------------------------------------------
            -- Stop demo data

            if curLogin and curLogin.geolat and curLogin.geolng and curLogin.login_time then

                trace.debug("curLogin.geolat:" .. curLogin.geolat .. " curLogin.geolng:" .. curLogin.geolng)
                ui.container {
                    attr = { class = "row-fluid" },
                    content = function()
                        ui.container {
                            attr = { class = "span12 alert location_data text-center" },
                            content = function()

                                ui.container {
                                    attr = { class = "row-fluid" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "span9 text-center" },
                                            content = function()

                                                ui.container {
                                                    attr = { class = "row-fluid" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "span12 text-left" },
                                                            content = function()
                                                                ui.heading {
                                                                    level = 4,
                                                                    content = function()
                                                                        trace.debug(member.realname .. " " .. member.login)
                                                                        slot.put(_("Welcome <strong>#{realname}</strong>.", { realname = (member.realname ~= "" and member.realname or member.login) }))
                                                                        ui.tag { tag = "span", attr = { id = "current_location" }, content = "" }
                                                                        ui.script { script = 'getLocation("current_location", " ' .. _ "You're connected from" .. '");' }
                                                                    end
                                                                }
                                                            end
                                                        }
                                                    end
                                                }

                                            --[[ui.container{attr = {class = "row-fluid" },content = function()
                                              ui.container{ attr = { class  = "span12 text-right" }, content = function()
                                                ui.heading{level=6,content=function()
                                                  slot.put(_"If it is not so, press here:")
                                                  ui.image{ attr = { class="arrow_small"}, static="svg/arrow-right.svg"}
                                                end }
                                              end }
                                            end }]]
                                            end
                                        }

                                    --[[ui.container{ attr = { class  = "span3 text-right" }, content = function()
                                      ui.anchor{
                                        attr = {
                                          href = "#",
                                          class = "btn btn-primary fixclick",
                                          onclick = "alert('Posizione aggiornata! (Non implementato)');"
                                        },
                                        content=function()
                                          ui.heading{level=3 ,content= _"Correct your position"}
                                        end
                                      }
                                      ui.script{script = "jQuery('.fittext_report').fitText(1.0, {minFontSize: '19px', maxFontSize: '28px'}); " }
                                    end }]]
                                    end
                                }
                            end
                        }
                    end
                }
            else
                ui.container {
                    attr = { class = "row-fluid" },
                    content = function()
                        ui.container {
                            attr = { class = "span12 well text-center" },
                            content = function()
                                ui.container {
                                    attr = { class = "row-fluid" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "span5 offset1 spaceline" },
                                            content = function()
                                                ui.heading {
                                                    level = 1,
                                                    content = function()
                                                        slot.put(_("Welcome <strong>#{realname}</strong>.", { realname = (member.realname ~= "" and member.realname or member.login) }))
                                                    end
                                                }
                                            end
                                        }
                                    end
                                }

                            --[[
                            ui.container{attr = {class = "row-fluid" },content = function()
                              ui.container{ attr = { class  = "span12" }, content = function()
                                ui.heading{level=5,content=function()
                                  slot.put( _"Locazione utente non rilevata" )
                                end }
                              end }
                            end }
                            --]]
                            end
                        }
                    end
                }
            end

            --[[local lastLogin = member:get_login_data()
            if lastLogin and lastLogin.geolat and lastLogin.geolng and lastLogin.login_time then

              ui.container{attr = {class = "row-fluid spaceline" },content = function()
                ui.container{ attr = { class  = "span12 alert location_data2 text-center" }, content = function()
                  ui.container{attr = {class = "row-fluid" },content = function()

                    ui.container{ attr = { class  = "span9 text-center" }, content = function()
                      ui.container{attr = {class = "row-fluid" },content = function()

                        ui.container{ attr = { class  = "span12 text-left" }, content = function()
                          ui.heading{level=4,content=function()
                              ui.tag{
                                content= _("Your last login was on #{last_login_date} at #{last_login_time}", {
                                  last_login_date = format.date(lastLogin.login_time),
                                  last_login_time = format.time(lastLogin.login_time)
                                })
                              }
                              slot.put("&nbsp;")
                              ui.tag{ tag="span", attr = { id = "last_location"}, content="" }
                              ui.script{ script = 'getLastLocation('..lastLogin.geolat..','..lastLogin.geolng..',"last_location", "'..  _"from " ..'");'}
                          end }
                        end }

                      end }

                      --[ [ui.container{attr = {class = "row-fluid" },content = function()
                        ui.container{ attr = { class  = "span12 text-right" }, content = function()
                          ui.heading{level=6,content=function()
                            slot.put(_"You didn't logged in from this location? Report it immediatly:")
                            ui.image{ attr = { class="arrow_small"}, static="svg/arrow-right.svg"}
                          end }
                        end }
                      end }] ]

                    end }

                    --[ [ui.container{ attr = { class  = "span3 text-right" }, content = function()
                      ui.anchor{
                        attr = {
                          href = "#",
                          class = "btn btn-primary fixclick",
                          onclick = "alert('Dato sospetto segnalato! (Non implementato)' );"
                        },
                        content=function()
                          ui.heading{level=3, content= _"Report suspect data"}
                        end
                      }
                      ui.script{script = "jQuery('.fittext_report').fitText(1.0, {minFontSize: '19px', maxFontSize: '28px'}); " }

                    end }] ]
                  end }

                end }
              end }

                  else

                  ui.container{attr = {class = "row-fluid spaceline" },content = function()
                ui.container{ attr = { class  = "span12 alert location_data2 text-center" }, content = function()
                  ui.container{attr = {class = "row-fluid" },content = function()

                    ui.container{ attr = { class  = "span9 text-center" }, content = function()
                      ui.container{attr = {class = "row-fluid" },content = function()

                        ui.container{ attr = { class  = "span12 text-left" }, content = function()
                          ui.heading{level=4,content=function()
                            if lastLogin and lastLogin.login_time then
                              ui.tag{ content= _("This is your first connection") }
                            end
                          end }
                        end }

                      end }

                      --[ [ui.container{attr = {class = "row-fluid" },content = function()
                        ui.container{ attr = { class  = "span12 text-right" }, content = function()
                          ui.heading{level=6,content=function()
                            slot.put(_"You didn't logged in from this location? Report it immediatly:")
                            ui.image{ attr = { class="arrow_small"}, static="svg/arrow-right.svg"}
                          end }
                        end }
                      end }] ]

                    end }

                    --[ [ui.container{ attr = { class  = "span3 text-right" }, content = function()
                      ui.anchor{
                        attr = {
                          href = "#",
                          class = "btn btn-primary fixclick",
                          onclick = "alert('Dato sospetto segnalato! (Non implementato)' );"
                        },
                        content=function()
                          ui.heading{level=3, content= _"Report suspect data"}
                        end
                      }
                      ui.script{script = "jQuery('.fittext_report').fitText(1.0, {minFontSize: '19px', maxFontSize: '28px'}); " }

                    end }] ]
                  end }

                end }
              end }

            end]]
            ui.container {
                attr = { class = "offset5 span4 text-right spaceline " },
                content = function()
                    ui.heading { level = 3, content = "La prima volta? clicca qui:" }
                end
            }
            ui.container {
                attr = { class = "span1 text-left spaceline" },
                content = function()
                    ui.image { attr = { class = "arrow_medium" }, static = "svg/arrow-right.svg" }
                end
            }
            ui.container {
                attr = { class = "span1 text-left " },
                content = function()
                    ui.field.popover {
                        attr = {
                            dataplacement = "left",
                            datahtml = "true";
                            datatitle = _ "Box di aiuto per la pagina",
                            datacontent = _ "Se sei su queste pagine per la prima volta, BENVENUTO! Per poter comprendere e navigare nei contenuti di Parelon, in ogni box troverai l'icona di aiuto, che ti supporterà con suggerimenti e tutorial, anche video. In questa prima pagina trovi due pulsanti principali, Regione Lazio ed Interna, siamo ancora in dubbio se lasciare un' assemblea interna, lo sperimenteremo con voi, per ora vi invito ad andare sull' Assemblea della Regione Lazio e seguire poi il Tutorial.",
                            class = "text-center"
                        },
                        content = function()

                            ui.image { static = "png/tutor.png" }
                        --								    ui.heading{level=3 , content= _"What you want to do?"}
                        end
                    }
                end
            }

            ui.container {
                attr = { class = "row-fluid spaceline" },
                content = function()
                    ui.container {
                        attr = { class = "span10 offset1 text-center" },
                        content = function()
                            ui.heading { level = 2, attr = { class = "uppercase" }, content = _ "Choose the assembly you want to participate:" }
                        end
                    }
                end
            }

            -- inizio icone
            ui.container {
                attr = { class = "row-fluid" },
                content = function()
                    ui.container {
                        attr = { class = "span6 text-center" },
                        content = function()
                            ui.image {
                                attr = { class = "img_assembly_small" },
                                static = "parlamento_icon_small.png"
                            }
                        end
                    }
                    ui.container {
                        attr = { class = "span6 text-center" },
                        content = function()
                            ui.image {
                                attr = { class = "img_assembly_small" },
                                static = "parlamento_icon_small.png"
                            }
                        end
                    }
                end
            }
            --  fine icone
            --  Bottoni

            ui.container {
                attr = { class = "row-fluid text-center" },
                content = function()
                    ui.container {
                        attr = { class = "span6" },
                        content = function()
                            ui.link {
                                attr = { class = "btn btn-primary btn-large large_btn fixclick" },
                                module = "index",
                                view = "homepage_bs",
                                content = function()
                                    ui.heading { level = 3, content = _ "PUBLIC ASSEMBLY" }
                                end
                            }
                        end
                    }

                    ui.container {
                        attr = { class = "span6" },
                        content = function()
                            ui.link {
                                attr = { class = "btn btn-primary btn-large large_btn fixclick" },
                                module = "index",
                                view = "homepage_private_bs",
                                content = function()
                                    ui.heading { level = 3, content = _ "INTERNAL ASSEMBLY" }
                                end
                            }
                        end
                    }
                end
            }
            -- cruscotto di stato
            ui.container {
                attr = { class = "row-fluid" },
                content = function()
                    ui.container {
                        attr = { class = "span12 well spaceline3" },
                        content = function()
                            ui.container {
                                attr = { class = "row-fluid" },
                                content = function()
                                    ui.heading {
                                        attr = { class = "span10 offset1 text-center" },
                                        level = 3,
                                        content = _ "The summary of the status of all the issues in you are interested in is this:"
                                    }
                                end
                            }
                            ui.container {
                                attr = { class = "row-fluid" },
                                content = function()
                                    ui.container {
                                        attr = { class = "span12 well-inside paper" },
                                        content = function()
                                            ui.container {
                                                attr = { class = "row-fluid" },
                                                content = function()
                                                    local issues_new_count = 0.0
                                                    local issues_discussion_count = 0.0
                                                    local issues_frozen_count = 0.0
                                                    local issues_voting_count = 0.0
                                                    local issues_finished_count = 0.0
                                                    local issues_canceled_count = 0.0
                                                    local status_selector = db:new_selector():from("area"):add_field("area.id"):add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.state = 'admission')", "issues_new_count"):add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.state = 'discussion')", "issues_discussion_count"):add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.state = 'verification')", "issues_frozen_count"):add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.state = 'voting')", "issues_voting_count"):add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.fully_frozen NOTNULL AND issue.closed NOTNULL)", "issues_finished_count"):add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.fully_frozen ISNULL AND issue.closed NOTNULL)", "issues_canceled_count"):join("issue", nil, { "area.id = issue.area_id AND area.active = TRUE" }):join("unit", nil, "unit.id = area.unit_id AND unit.public "):join("membership", nil, { "membership.area_id = area.id AND membership.member_id = ?", app.session.member.id }):add_group_by("area.id"):exec()
                                                    for i, k in ipairs(status_selector) do
                                                        issues_new_count = issues_new_count + k.issues_new_count
                                                        issues_discussion_count = issues_discussion_count + k.issues_discussion_count
                                                        issues_frozen_count = issues_frozen_count + k.issues_frozen_count
                                                        issues_voting_count = issues_voting_count + k.issues_voting_count
                                                        issues_finished_count = issues_finished_count + k.issues_finished_count
                                                        issues_canceled_count = issues_canceled_count + k.issues_canceled_count
                                                    end

                                                    ui.container {
                                                        attr = { class = "row-fluid" },
                                                        content = function()
                                                            ui.container {
                                                                attr = { class = "span4" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { class = "row-fluid spaceline-bottom" },
                                                                        content = function()
                                                                            ui.container {
                                                                                attr = { class = "span2 offset1 spaceline" },
                                                                                content = function()
                                                                                    ui.image {
                                                                                        static = "png/new-proposal.png"
                                                                                    }
                                                                                end
                                                                            }
                                                                            ui.link {
                                                                                module = "unit",
                                                                                view = "show_ext_bs",
                                                                                params = { filter = "my_areas" },
                                                                                attr = { class = "span9 text-center spaceline" },
                                                                                content = function()
                                                                                    ui.heading {
                                                                                        level = 4,
                                                                                        attr = { class = "btn btn-primary large_btn" },
                                                                                        content = _("#{count} new", { count = issues_new_count })
                                                                                    }
                                                                                end
                                                                            }
                                                                        end
                                                                    }
                                                                end
                                                            }
                                                            ui.container {
                                                                attr = { class = "span4" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { class = "row-fluid spaceline-bottom" },
                                                                        content = function()
                                                                            ui.container {
                                                                                attr = { class = "span2 offset1 spaceline" },
                                                                                content = function()
                                                                                    ui.image {
                                                                                        static = "png/discussion.png"
                                                                                    }
                                                                                end
                                                                            }
                                                                            ui.link {
                                                                                module = "unit",
                                                                                view = "show_ext_bs",
                                                                                params = { filter = "my_areas" },
                                                                                attr = { class = "span9 text-center spaceline" },
                                                                                content = function()
                                                                                    ui.heading {
                                                                                        level = 4,
                                                                                        attr = { class = "btn btn-primary large_btn" },
                                                                                        content = _("#{count} in discussion", { count = issues_discussion_count })
                                                                                    }
                                                                                end
                                                                            }
                                                                        end
                                                                    }
                                                                end
                                                            }
                                                            ui.container {
                                                                attr = { class = "span4" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { class = "row-fluid spaceline-bottom" },
                                                                        content = function()
                                                                            ui.container {
                                                                                attr = { class = "span2 offset1 spaceline" },
                                                                                content = function()
                                                                                    ui.image {
                                                                                        static = "png/verification.png"
                                                                                    }
                                                                                end
                                                                            }
                                                                            ui.link {
                                                                                module = "unit",
                                                                                view = "show_ext_bs",
                                                                                params = { filter = "my_areas" },
                                                                                attr = { class = "span9 text-center spaceline" },
                                                                                content = function()
                                                                                    ui.heading {
                                                                                        level = 4,
                                                                                        attr = { class = "btn btn-primary large_btn" },
                                                                                        content = _("#{count} in verification", { count = issues_frozen_count })
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
                                                        attr = { class = "row-fluid" },
                                                        content = function()
                                                            ui.container {
                                                                attr = { class = "span4" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { class = "row-fluid spaceline-bottom" },
                                                                        content = function()
                                                                            ui.container {
                                                                                attr = { class = "span2 offset1 spaceline" },
                                                                                content = function()
                                                                                    ui.image {
                                                                                        static = "png/voting.png"
                                                                                    }
                                                                                end
                                                                            }
                                                                            ui.link {
                                                                                module = "unit",
                                                                                view = "show_ext_bs",
                                                                                params = { filter = "my_areas" },
                                                                                attr = { class = "span9 text-center spaceline" },
                                                                                content = function()
                                                                                    ui.heading {
                                                                                        level = 4,
                                                                                        attr = { class = "btn btn-primary large_btn" },
                                                                                        content = _("#{count} in voting", { count = issues_voting_count })
                                                                                    }
                                                                                end
                                                                            }
                                                                        end
                                                                    }
                                                                end
                                                            }
                                                            ui.container {
                                                                attr = { class = "span4" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { class = "row-fluid spaceline-bottom" },
                                                                        content = function()
                                                                            ui.container {
                                                                                attr = { class = "span2 offset1 spaceline" },
                                                                                content = function()
                                                                                    ui.image {
                                                                                        static = "png/finished.png"
                                                                                    }
                                                                                end
                                                                            }
                                                                            ui.link {
                                                                                module = "unit",
                                                                                view = "show_ext_bs",
                                                                                params = { filter = "my_areas" },
                                                                                attr = { class = "span9 text-center spaceline" },
                                                                                content = function()
                                                                                    ui.heading {
                                                                                        level = 4,
                                                                                        attr = { class = "btn btn-primary large_btn" },
                                                                                        content = _("#{count} finished", { count = issues_finished_count })
                                                                                    }
                                                                                end
                                                                            }
                                                                        end
                                                                    }
                                                                end
                                                            }
                                                            ui.container {
                                                                attr = { class = "span4" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { class = "row-fluid spaceline-bottom" },
                                                                        content = function()
                                                                            ui.container {
                                                                                attr = { class = "span2 offset1 spaceline" },
                                                                                content = function()
                                                                                    ui.image {
                                                                                        static = "png/delete.png"
                                                                                    }
                                                                                end
                                                                            }
                                                                            ui.link {
                                                                                module = "unit",
                                                                                view = "show_ext_bs",
                                                                                params = { filter = "my_areas" },
                                                                                attr = { class = "span9 text-center spaceline" },
                                                                                content = function()
                                                                                    ui.heading {
                                                                                        level = 4,
                                                                                        attr = { class = "btn btn-primary large_btn" },
                                                                                        content = _("#{count} canceled", { count = issues_canceled_count })
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
    --[[ execute.view{module="index",view="_registration_info"} ]] --

else
    if config.motd_public then
        local help_text = config.motd_public
        ui.container {
            attr = { class = "wiki motd" },
            content = function()
                slot.put(format.wiki_text(help_text))
            end
        }
    end
    ui.container {
        attr = { class = "row-fluid" },
        content = function()
            ui.form {
                attr = { id = "login_div", class = "well span6" },
                module = 'index',
                action = 'login',
                routing = {
                    ok = {
                        mode = 'redirect',
                        module = param.get("redirect_module") or "index",
                        view = param.get("redirect_view") or "index",
                        id = param.get("redirect_id"),
                    },
                    error = {
                        mode = 'forward',
                        module = 'index',
                        view = 'index',
                    }
                },
                content = function()
                    ui.tag {
                        tag = "fieldset",
                        content = function()
                            ui.container {
                                attr = { class = "row-fluid" },
                                content = function()
                                    ui.tag { tag = "legend", attr = { class = "span12 text-center" }, content = _ "Insert user name and password to access:" }
                                end
                            }

                            ui.container {
                                attr = { class = "row-fluid" },
                                content = function()
                                    ui.tag { tag = "label", attr = { class = "span4" }, content = _ 'login name' }
                                    ui.tag {
                                        tag = "input",
                                        attr = { id = "username_field", type = "text", placeholder = _ 'login name', class = "span8 input-large", name = "login" },
                                        content = ''
                                    }
                                end
                            }

                            ui.container {
                                attr = { class = "row-fluid" },
                                content = function()
                                    ui.tag { tag = "label", attr = { class = "span4" }, content = _ 'Password' }
                                    ui.script { script = 'document.getElementById("username_field").focus();' }
                                    ui.tag { tag = "input", attr = { type = "password", placeholder = _ 'Password', class = "span8 input-large", name = "password" }, content = '' }
                                end
                            }
                            
                            ui.container {
                                attr = { class = "row-fluid" },
                                content = function()
                                    ui.tag { tag = "label", attr = { class = "span4" }, content = _ 'OTP' }
                                    ui.script { script = 'document.getElementById("username_field").focus();' }
                                    ui.tag { tag = "input", attr = { disabled="true", type = "otp", placeholder = _ 'OTP', class = "span8 input-large", name = "otp" }, content = '' }
                                end
                            }

                            ui.container {
                                attr = { class = "row-fluid text-center" },
                                content = function()
                                    ui.container {
                                        attr = { class = "span6 offset3" },
                                        content = function()
                                            ui.tag {
                                                tag = "button",
                                                attr = { type = "submit", class = "btn btn-primary btn-large large_btn spaceline fixclick" },
                                                content = function()
                                                    ui.heading { level = 3, attr = { class = "inline-block" }, content = _ "Login" }
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
                attr = { id = "registration-info", class = "span6" },
                content = function()

                    ui.container {
                        attr = { class = "row-fluid text-center" },
                        content = function()
                            ui.container {
                                attr = { id = "registration", class = "span12 well" },
                                content = function()
                                    ui.container {
                                        attr = { class = "row-fluid text-center" },
                                        content = function()
                                            ui.tag {
                                                attr = { class = "span12 text-center" },
                                                content = function()
                                                    ui.tag { tag = "p", content = _ "Possiedi gia' un codice di invito? Clicca qui:" }
                                                end
                                            }
                                        end
                                    }
                                    ui.container {
                                        attr = { class = "row-fluid text-center" },
                                        content = function()
                                            ui.container {
                                                attr = { id = "registration", class = "span12 spaceline" },
                                                content = function()
                                                    ui.link {
                                                        attr = { class = "btn btn-primary btn-large large_btn fixclick" },
                                                        module = "index",
                                                        view = "register",
                                                        content = function()
                                                            ui.heading { level = 3, content = _ "Registrati" }
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
                        attr = { class = "row-fluid text-center" },
                        content = function()
                            ui.container {
                                attr = { id = "lost_password", class = "span12 well" },
                                content = function()
                                    ui.container {
                                        attr = { class = "row-fluid text-center" },
                                        content = function()
                                            ui.tag {
                                                attr = { class = "span12 text-center" },
                                                content = function()
                                                    ui.tag { tag = "p", content = _ "Hai smarrito la password? Clicca qui:" }
                                                end
                                            }
                                        end
                                    }
                                    ui.container {
                                        attr = { class = "row-fluid text-center" },
                                        content = function()
                                            ui.container {
                                                attr = { id = "lost_password", class = "span12 spaceline" },
                                                content = function()
                                                    ui.link {
                                                        attr = { class = "btn btn-primary large_btn fixclick" },
                                                        module = 'index',
                                                        view = 'reset_password',
                                                        content = function()
                                                            ui.heading { level = 3, content = "Ripristina" }
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
        end
    }
    --  execute.view{module="index",view="_registration_info"}
end
