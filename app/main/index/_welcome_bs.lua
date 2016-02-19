slot.set_layout("custom")

if not app.session.member_id then
                    ui.container {
                        attr = { class = "row-fluid minustop" },
                        content = function()
                             ui.container {
                                attr = { class = "span4 offset4 text-center" },
                                content = function()
												ui.image {
                                			attr = { class = "" },
                                			static = "parlamento_icon_small.png"
                            			}
                                end
                            }
                                end
                            }
                    ui.container {
                        attr = { class = "row-fluid" },
                        content = function()
                            
                            ui.container {
                                attr = { class = "span8 offset2 text-center" },
                                content = function()
                                    ui.heading {
                                        level = 1,
                                        content = function()
                                            slot.put(_ "PARLAMENTO ELETTRONICO ONLINE")
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
                            datacontent = _ "Se sei su queste pagine per la prima volta, BENVENUTO! Per poter comprendere e navigare nei contenuti di Parelon, in ogni box troverai l'icona di aiuto, che ti supporterà con suggerimenti e tutorial, anche video. In questa prima pagina trovi due pulsanti principali, Assemblea Pubblica e Assemblea Interna.<br>".."<a class ='btn btn-primary large_btn fixclick'  href='https://www.parelon.com/?project=primo-accesso&lang=it' target='_blank'><h3>Vai ai Tutorial</h3></a>",
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
                                                    local status_selector = db:new_selector():from("area"):add_field("area.id"):add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.state = 'admission')", "issues_new_count"):add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.state = 'discussion')", "issues_discussion_count"):add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.state = 'verification')", "issues_frozen_count"):add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.state = 'voting')", "issues_voting_count"):add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.fully_frozen NOTNULL AND issue.closed NOTNULL)", "issues_finished_count"):add_field("(SELECT COUNT(*) FROM issue WHERE issue.area_id = area.id AND issue.fully_frozen ISNULL AND issue.closed NOTNULL)", "issues_canceled_count"):join("issue", nil, { "area.id = issue.area_id AND area.active = TRUE" }):join("unit", nil, "unit.id = area.unit_id"):join("membership", nil, { "membership.area_id = area.id AND membership.member_id = ?", app.session.member.id }):add_group_by("area.id"):exec()
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
                                                                                module = "issue",
                                                                                view = "list",
                                                                                params = {
                                                                                	filter_unit = "my_areas",
                                                                                	tab = "open",
                                                                                	filter_interest = "area",
                                                                                	filter = "new"
                                                                                },
                                                                                attr = { class = "span9 text-center spaceline" },
                                                                                content = function()
                                                                                    ui.heading {
                                                                                        level = 4,
                                                                                        attr = { class = "btn btn-primary large_btn_console" },
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
                                                                                module = "issue",
                                                                                view = "list",
                                                                                params = {
                                                                                	filter_unit = "my_areas",
                                                                                	tab = "open",
                                                                                	filter_interest = "area",
                                                                                	filter = "accepted"
                                                                                },
                                                                                attr = { class = "span9 text-center spaceline" },
                                                                                content = function()
                                                                                    ui.heading {
                                                                                        level = 4,
                                                                                        attr = { class = "btn btn-primary large_btn_console" },
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
                                                                                module = "issue",
                                                                                view = "list",
                                                                                params = {
                                                                                	filter_unit = "my_areas",
                                                                                	tab = "open",
                                                                                	filter_interest = "area",
                                                                                	filter = "half_frozen"
                                                                                },
                                                                                attr = { class = "span9 text-center spaceline" },
                                                                                content = function()
                                                                                    ui.heading {
                                                                                        level = 4,
                                                                                        attr = { class = "btn btn-primary large_btn_console" },
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
                                                                                module = "issue",
                                                                                view = "list",
                                                                                params = {
                                                                                	filter_unit = "my_areas",
                                                                                	tab = "open",
                                                                                	filter_interest = "area",
                                                                                	filter = "frozen"
                                                                                },
                                                                                attr = { class = "span9 text-center spaceline" },
                                                                                content = function()
                                                                                    ui.heading {
                                                                                        level = 4,
                                                                                        attr = { class = "btn btn-primary large_btn_console" },
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
                                                                                module = "issue",
                                                                                view = "list",
                                                                                params = {
                                                                                	filter_unit = "my_areas",
                                                                                	tab = "open",
                                                                                	filter_interest = "area",
                                                                                	filter = "finished"
                                                                                },
                                                                                attr = { class = "span9 text-center spaceline" },
                                                                                content = function()
                                                                                    ui.heading {
                                                                                        level = 4,
                                                                                        attr = { class = "btn btn-primary large_btn_console" },
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
                                                                                module = "issue",
                                                                                view = "list",
                                                                                params = {
                                                                                	filter_unit = "my_areas",
                                                                                	tab = "open",
                                                                                	filter_interest = "area",
                                                                                	filter = "canceled"
                                                                                },
                                                                                attr = { class = "span9 text-center spaceline" },
                                                                                content = function()
                                                                                    ui.heading {
                                                                                        level = 4,
                                                                                        attr = { class = "btn btn-primary large_btn_console" },
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
        		ui.container {
        				attr = { class = "well span6" },
        				content = function()
        						execute.view {  module = 'index', view = 'login', params = { module = 'index', view = 'index', id = param.get_id() } }
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
                                                    ui.tag { tag = "p", content = _ "Non sei ancora registrato? Clicca qui:" }
                                                end
                                            }
                                        end
                                    }
                                    ui.container {
                                        attr = { class = "row-fluid text-center" },
                                        content = function()
                                            ui.container {
                                                attr = { class = "span12 spaceline" },
                                                content = function()
                                                    ui.link {
                                                        content = function()
                                                            slot.put(_"<a class ='btn btn-primary large_btn fixclick' href='https://www.parelon.com/?project=sincronizzare-il-token&lang=it' target='_blank'><h3>Registrati</h3></a>")
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
                                                    ui.tag { tag = "p", content = _ "Son più di due mesi che non ti vediamo qui, devi risincronizzare il token:" }
                                                end
                                            }
                                        end
                                    }
                                    ui.container {
                                        attr = { class = "row-fluid text-center" },
                                        content = function()
                                            ui.container {
                                                attr = { class = "span12 spaceline" },
                                                content = function()
                                                    ui.link {
                                                        content = function()
                                                            slot.put(_"<a class ='btn btn-primary large_btn fixclick' href='https://www.parelon.com/?page_id=604&lang=it' target='_blank'><h3>Sincronizza</h3></a>")
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
