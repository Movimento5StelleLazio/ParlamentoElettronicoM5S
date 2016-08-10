slot.set_layout("custom")
trace.debug("requested redirect")
local issue_id = param.get_id()
if issue_id == 0 then
    local tmp = param.get("issue_id", atom.integer)
    if tmp and tmp ~= 0 then
        issue_id = tmp
    end
end

trace.debug("issue " .. tostring(issue_id))
local issue = Issue:by_id(issue_id)
local state = param.get("state")
local orderby = param.get("orderby") or ""
local desc = param.get("desc", atom.boolean)
local interest = param.get("interest")
local scope = param.get("scope")
local view = param.get("view")
local ftl_btns = param.get("ftl_btns", atom.boolean)
local init_ord = param.get("init_ord") or "supporters"

if issue.area.unit.public == false then
    request.redirect {
        module = "issue_private",
        view = "show_ext_bs",
        id = param.get_id(),
        params = param.get_all_cgi()
    }
    return
end

local function round(num, idp)
    return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

local return_view, return_module
local return_btn_txt = _ "Back to previous page"
if view == "homepage" then
    return_module = "index"
    return_view = "homepage_bs"
    return_btn_txt = _ "Back to homepage"
elseif view == "area" then
    return_module = "area"
    return_view = "show_ext_bs"
    return_btn_txt = _ "Back to issue listing"
elseif view == "area_private" then
    return_module = "area_private"
    return_view = "show_ext_bs"
    return_btn_txt = _ "Back to issue listing"
end

if app.session.member_id then
    issue:load_everything_for_member_id(app.session.member_id)
end

if not app.html_title.title then
    app.html_title.title = _("Issue ##{id}", { id = issue.id })
end

local url = request.get_absolute_baseurl() .. "issue/show_ext_bs/" .. tostring(issue.id) .. ".html"
trace.debug("url: " .. url)

ui.title(function()
    ui.container {
        attr = { class = "row" },
        content = function()
            ui.container {
                attr = { class = "col-md-3 col-sm-4 col-xs-12 text-center" },
                content = function()
                    if app.session.member then
                        ui.link {
                            attr = { class = "btn btn-primary fixclick btn-back h2" },
                            module = "area",
                            id = issue.area.id,
                            view = "show_ext_bs",
                            params = param.get_all_cgi(),
                            image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                            content = return_btn_txt
                        }
                    end
                end
            }
            ui.container {
                attr = { class = "col-md-8 col-sm-8 col-xs-12 text-center label label-warning spaceline"},
                content = function()
                            ui.container {
                                content = function()
                                    ui.heading { level = 1, attr = { class = "fittext1 uppercase " }, content = _ "Details for issue Q" .. issue.id }
                                end
                            }
                end
            }

            ui.container {
                attr = { class = "col-md-1 hidden-xs hidden-sm text-right spaceline"},
                content = function()
                    ui.field.popover {
                        attr = {
                            dataplacement = "bottom",
                            datahtml = "true";
                            datatitle = _ "Box di aiuto per la pagina",
                            datacontent = _ "Ti trovi nei dettagli della QUESTIONE, con le informazioni integrali. Al box SOLUZIONI PROPOSTE puoi leggere la, o le PROPOSTE presentate per risolvere la QUESTIONE, o presentrare una tua PROPOSTA alternativa.<div class='spaceline'> <iframe width='560' height='315' src='https://www.youtube.com/embed/DPWS4mtPbnM' frameborder='0' allowfullscreen></iframe></div>",
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
        attr = {class = "row spaceline"},
        content = function()
            ui.container { 
            	attr = { id = "social_box",  class = "col-md-4 col-xs-12 col-sm-12 text-center spaceline" }, 
            	content = function() 
            	slot.put('<div data-url="' .. url .. '" class="addthis_sharing_toolbox"></div>')
            	end 
         	}
            
            ui.container {
                attr = { class = "col-md-8 col-sm-12  col-xs-12" },
                content = function()
                    
                    ui.heading { level = 6, attr = { class = "" }, content = _ "Issue link (copy the link and share to the web):" }
                    slot.put("<input id='issue_url_box' type='text' value=" .. url .. ">")
                end
            }           
        end
    }
end)

ui.container {
    attr = { class = "row" },
    content = function()
        ui.container {
            attr = { class = "col-md-12 well-blue" },
            content = function()
	              ui.container {
	                  attr = { class = "row text-center" },
	                  content = function()
	                      ui.tag {
	                          tag = "strong",
	                          attr = { class = "col-md-8 col-md-offset-2 label label-warning text-center" },
	                          content = function()
	                              ui.heading {
	                                  level = 1,
	                                  content = (issue.title or _ "No title for the issue!")
	                              }
	                          end
	                      }
	                  end
                }
 ui.container {
     attr = { class = "row text-center" },
     content = function()
        ui.container {
            attr = { class = "col-md-12 well-inside paper" },
            content = function() 
                ui.container {
                    attr = { class = "row text-center" },
                    content = function()
                        ui.container {
                            content = function()
                                execute.view { module = "issue", view = "info_box", params = { issue = issue } }
                            end
                        }
                    end
                }
                  ui.container {
                     attr = { class = "row spaceline5 hidden-sm hidden-xs" },
                     content = function()
							end
					  }
					  	ui.container {
                     attr = { class = "row spaceline2 hidden-lg hidden-md" },
                     content = function()
							end
					  }
                ui.container {
                    attr = { class = "row" },
                    content = function()
								  ui.container {
										attr = { class = "col-md-1 hidden-xs hidden-sm" },
										content = function()
											 ui.image { static = "spacer.png" }
										end
								  }
				               ui.container {
				                   attr = { class = "col-md-9 col.xs-12 col-sm-12" },
				                   content = function()
				                       execute.view { module = "issue", view = "phasesbar", params = { state = issue.state } }
				                   end
				               }
								  ui.container {
										attr = { class = "col-md-2 hidden-xs hidden-sm" },
										content = function()
											 ui.image { static = "spacer.png" }
										end
								  }
                      end
                  }
                    ui.container {
                              attr = { class = "row spaceline5 hidden-md hidden-lg" },
                              content = function()

								end
						  }
						 ui.container {
                              attr = { class = "row spaceline2 hidden-lg hidden-md" },
                              content = function()

								end
						  }
	            end
          }
        end
    }		  
										  
										                          
                --[[slot.put("<span class='st_sharethis_vcount' displayText='ShareThis'></span>\n"..
                          "<span class='st_facebook_vcount' displayText='Facebook'></span>\n"..
                          "<span class='st_twitter_vcount' displayText='Tweet'></span>\n"..
                          "<span class='st_plusone_vcount' displayText='Google +1'></span>\n"..
                          "<span class='st_linkedin_vcount' displayText='LinkedIn'></span>\n"..
                          "<span class='st_pinterest_vcount' displayText='Pinterest'></span>\n"..
                          "<span class='st_email_vcount' displayText='Email'></span>")]]
                ui.container {
                    attr = { class = "row spaceline2" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-12" },
                            content = function()
                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12" },
                                            content = function()
                                                ui.heading { level = 3, attr = { class = "label label-warning-tbox spaceline" }, content = _ "Brief description" }
                                            end
                                        }
                                    end
                                }
                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12 well-inside paper" },
                                            content = function()
                                                ui.tag { tag = "p", attr = { class = "issue_brief_description initiative_list_box" }, content = issue.brief_description or _ "No description available" }
                                            end
                                        }
                                    end
                                }


                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12" },
                                            content = function()
                                                ui.heading {
                                                    level = 3,
                                                    attr = { class = "label label-warning-tbox spaceline" },
                                                    content = function()
                                                        ui.tag { content = _ "Keywords" }
                                                    end
                                                }
                                            end
                                        }
                                    end
                                }
                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12 well-inside paper" },
                                            content = function()
                                            --[[ui.container{ attr = { class = "row"}, content = function()

                                              ui.container{ attr = { class = "col-md-12"}, content = function()
                                                  ui.tag{ content = _"(Press a keyword to see all issues created until today discussing that topic)" }
                                                  -end }
                                                  end }]]
                                                ui.container {
                                                    attr = { class = "row" },
                                                    content = function()

                                                        ui.container {
                                                            attr = { class = "col-md-12" },
                                                            content = function()
                                                                local keywords = Keyword:by_issue_id(issue.id)
                                                                if keywords and #keywords > 0 then
                                                                    for k = 1, #keywords do
                                                                        if not keywords[k].technical_keyword then
                                                                            ui.tag {
                                                                                tag = "span",
                                                                                attr = { class = "btn btn-danger btn-small filter_btn nowrap" },
                                                                                content = function()
                                                                                    ui.heading { level = 5, attr = { class = "uppercase" }, content = keywords[k].name }
                                                                                end
                                                                            }
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        }
                                                    end
                                                }
                                            end
                                        }
                                    end
                                }
                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12" },
                                            content = function()
                                                ui.heading {
                                                    level = 3,
                                                    attr = { class = "label label-warning-tbox spaceline" },
                                                    content = function()
                                                        ui.tag { content = _ "Technical competence fields:" }
                                                    end
                                                }
                                                ui.container {
                                                    attr = { class = "row" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "col-md-12 well-inside paper" },
                                                            content = function()
                                                            --[[ui.tag{ content = _"(Press an area of competence to see all issues created until today concerning that area)" }]]

                                                                local keywords = Keyword:by_issue_id(issue.id)
                                                                if keywords and #keywords > 0 then
                                                                    for k = 1, #keywords do
                                                                        if keywords[k].technical_keyword then
                                                                            ui.link {
                                                                                attr = { class = "btn btn-info btn-small filter_btn nowrap" },
                                                                                content = function()
                                                                                    ui.heading { level = 5, attr = { class = "uppercase" }, content = keywords[k].name }
                                                                                end
                                                                            }
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        }
                                                    end
                                                }
                                            end
                                        }
                                    end
                                }

                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12" },
                                            content = function()
                                                ui.heading { level = 3, attr = { class = "label label-warning-tbox spaceline" }, content = _ "Detailed problem description" }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "col-md-12 well-inside paper initiative_list_box" },
                                            content = function()
                                                ui.tag { content = issue.problem_description or _ "No description available" }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "col-md-12" },
                                            content = function()
                                                ui.heading { level = 3, attr = { class = "label label-warning-tbox spaceline" }, content = _ "Aim description" }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "col-md-12 well-inside paper initiative_list_box" },
                                            content = function()
                                                ui.tag { content = issue.aim_description or _ "No description available" }
                                            end
                                        }
                                    end
                                }

                                if app.session.member and not issue.closed then


                                    ui.container {
                                        attr = { class = "row text-center" },
                                        content = function()
                                            ui.container {
                                                attr = { class = "col-md-8 col-md-offset-1 label label-warning-tbox spaceline" },
                                                content = function()
                                                    ui.tag { tag = "h3", content = _ "SUPPORT THE ISSUE" }
                                                end
                                            }
                                        end
                                    }                                            
                                                    ui.container {
                                                        attr = { class = "row" },
                                                        content = function()
                                                    ui.container {
                                                        attr = { class = " col-md-12 well-inside paper" },
                                                        content = function()
                                                                    if not issue.closed and not issue.fully_frozen and issue.state ~= "voting" then
                                                                        if issue.member_info.own_participation then
                                                            ui.container {
                                                                attr = { class = "col-md-4 col-md-offset-2 spaceline" },
                                                                content = function()
                                                                            ui.image { attr = { style = "height: 50px" }, static = "png/thumb_up.png" }
                                                                            ui.tag { tag = "span", content = "  " }
                                                                            ui.link {
                                                                                attr = { class = "label label-danger" },
                                                                                in_brackets = true,
                                                                                text = _ "Withdraw",
                                                                                module = "interest",
                                                                                action = "update",
                                                                                params = { issue_id = issue.id, delete = true },
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
                                                                        elseif app.session.member:has_voting_right_for_unit_id(issue.area.unit_id) then
                                                            ui.container {
                                                                attr = { class = "col-md-4 col-md-offset-2 spaceline"  },
                                                                content = function()
                                                                            ui.image { attr = { style = "height: 50px" }, static = "png/thumb_down.png" }
                                                                            ui.tag { tag = "span", content = "  " }
                                                                            ui.link {
                                                                                attr = { class = "label label-success" },
                                                                                text = _ "Add my interest",
                                                                                module = "interest",
                                                                                action = "update",
                                                                                params = { issue_id = issue.id },
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
							                                            ui.container {
							                                                attr = { class = "col-md-3 col-md-offset-3 text-right hidden-xs hidden-sm " },
							                                                content = function()
							                                                    ui.field.popover {
							                                                        attr = {
							                                                            dataplacement = "bottom",
							                                                            datahtml = "true";
							                                                            datatitle = _ "Box di aiuto per la pagina",
							                                                            datacontent = _("Puoi sostenere oppure ritirare il sostegno alla questione.<br /><i>Sostenere</i> la questione non vuol dire <i>votare sì</i>: vuol dire solo ritenere che il problema sollevato <i>merita</i> di essere discusso."),
							                                                            datahtml = "true",
							                                                            class = "text-center"
							                                                        },
							                                                        content = function()
							                                                            ui.container {
							                                                                attr = { class = "row" },
							                                                                content = function()
							                                                                    ui.image { attr = { class = "icon-medium" },static = "png/tutor.png" }
							                                                                --								    ui.heading{level=3 , content= _"What you want to do?"}
							                                                                end
							                                                            }
							                                                        end
							                                                    }
							                                                end
							                                            }
                                                                    elseif issue.state == 'voting' then
                                                                        ui.container {
                                                                            attr = { class = "row" },
                                                                            content = function()
                                                                        ui.container {
                                                                            attr = { class = "col-md-7 col-sm-12 col-xs-12 spaceline label label-danger" },
                                                                            content = function()
                                                                                ui.heading { level = 2, content = "La proposta è passata alla fase di votazione: clicca sul pulsante per votare o cambiare il tuo voto" }
                                                                            end
                                                                        }
                                                                        ui.container {
                                                                            attr = { class =  "col-md-1 hidden-sm hidden-xs  spaceline3" },
                                                                            content = function()
                                                                                ui.image { attr = { class = "icon-medium" },static = "svg/arrow-right.svg" }
                                                                            end
                                                                        }

                                                                        ui.container {
                                                                            attr = { class = "col-md-4 col-sm-12 col-xs-12 " },
                                                                            content = function()
						                                                                ui.container {
						                                                                    attr = { class = "row" },
						                                                                    content = function()
												                                                       ui.container {
									                                                                    attr = { class = "col-md-12 text-center" },
									                                                                    content = function()
							                                                                    		     ui.image { static = "png/voting.png"}
									                                                                    end
									                                                                }				
									                                                                ui.container {
									                                                                    attr = { class = "col-md-12 text-center" },
									                                                                    content = function()
								                                                                          ui.link {
								                                                                              attr = { id = "issue_see_det_" .. issue.id },
								                                                                              module = "vote",
								                                                                              view = "list",
								                                                                              id = issue.id,
								                                                                              params = { issue_id = issue.id },
								                                                                              content = function()                                                                    
								                                                                                    ui.heading { level = 2, attr = { class = "spaceline btn btn-large btn-primary" }, content = _ "Vote now" }
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
                                                                    else
                                                                        ui.heading { level = 3, content = _ "This issue is closed." }
                                                                    end

                                                end
                                            }
                                                end
                                            }
                                end
                                ui.container {
                                    attr = { class = "row spaceline" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12 well" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "row" },
                                                    content = function()
					                                        ui.container {
					                                            attr = { class = "col-md-10 col-md-offset-1 col-xs-12 col-sm-12" },
					                                            content = function()
					                                                ui.heading { level = 1, attr = { class = "label label-warning-tbox spaceline"}, content = _ "Proposed solutions" }
					                                            end
					                                        }
                                                        ui.container {
                                                            attr = { class = "col-md-10 col-md-offset-1 text-center col-xs-12 col-sm-12 well-inside paper" },
                                                            content = function()
                                                                if #issue.initiatives == 1 then
                                                                    content = _ "initiative"
                                                                else
                                                                    content = _ "initiatives"
                                                                end

                                                                ui.tag {
                                                                    content = function()
                                                                        if issue.state == 'admission' then
                                                                            slot.put(_("Vi sono attualmente #{count} proposte per risolvere la questione sollevata.<br />Leggi le proposte integrali, decidi a quale dare il tuo sostegno o presenta una proposta alternativa <br /> Almeno una proposta tra quelle presentate deve raggiungere il quorum di sostenitori entro #{days} affinche' la questione venga ammessa alla fase successiva.", { count = #issue.initiatives, days = format.interval_text(issue.state_time_left) }))
                                                                        else
                                                                            slot.put(_("Vi sono attualmente #{count} proposte per risolvere la questione sollevata.<br />Leggi le proposte integrali, decidi a quale dare il tuo sostegno o presenta una proposta alternativa.", { count = #issue.initiatives }))
                                                                        end
                                                                    end
                                                                }
                                                            end
                                                        }


                                                    end
                                                }


                                                ui.container {
                                                    attr = { class = "row" },
                                                    content = function()
                                                        local quorum_percent = issue.policy.issue_quorum_num * 100 / issue.policy.issue_quorum_den
                                                        local quorum_supporters
                                                        if issue.population and issue.population > 0 then
                                                            quorum_supporters = math.ceil(issue.population * quorum_percent / 100)
                                                        else
                                                            quorum_supporters = 0
                                                        end
                                                        ui.container {
                                                            attr = { class = "row spaceline" },
                                                            content = function()
                                                                ui.container {
                                                                    attr = { class = "col-md-12" },
                                                                    content = function()
                                                                        ui.container {
                                                                            attr = { class = "row" },
                                                                            content = function()
                                                                                ui.container {
                                                                                    attr = { class = "col-md-10 col-md-offset-1 text-center label label-info" },
                                                                                    content = function()
                                                                                        ui.tag { tag = "h3", content = "LEGGI I TESTI INTEGRALI DELLE PROPOSTE PRESENTATE" }
                                                                                    end
                                                                                }
                                                                            end
                                                                        }
                                                                        ui.container {
                                                                            attr = { class = "row spaceline spaceline-bottom text-center" },
                                                                            content = function()
                                                                                local btna, btnb = "", ""
                                                                                if init_ord == "supporters" then btna = " active"
                                                                                end
                                                                                if init_ord == "event" then btnb = " active"
                                                                                end

                                                                                ui.link {
                                                                                    attr = { class = "col-md-6 col-xs-12 col-sm-6 text-center" .. btna },
                                                                                    module = request.get_module(),
                                                                                    id = issue.id,
                                                                                    view = request.get_view(),
                                                                                    params = { state = state, orderby = orderby, desc = desc, interest = interest, scope = scope, view = view, ftl_btns = ftl_btns, init_ord = "supporters" },
                                                                                    content = function()
                                                                                        ui.heading { level = 3, attr = { class = "btn btn-primary btn-large fixclick " }, content = _ "ORDER BY NUMBER OF SUPPORTERS" }
                                                                                    end
                                                                                }
                                                                                ui.link {
                                                                                    attr = { class = "col-md-6 col-xs-12 col-sm-6 text-center" .. btnb },
                                                                                    module = request.get_module(),
                                                                                    id = issue.id,
                                                                                    view = request.get_view(),
                                                                                    params = { state = state, orderby = orderby, desc = desc, interest = interest, scope = scope, view = view, ftl_btns = ftl_btns, init_ord = "event" },
                                                                                    content = function()
                                                                                        ui.heading { level = 3, attr = { class = "btn btn-primary btn-large fixclick" }, content = _ "ORDER BY LAST EVENT DATE" }
                                                                                    end
                                                                                }
                                                                            end
                                                                        }
                                                                    end
                                                                }
                                                            end
                                                        }
                                            --[[            ui.container {
                                                            attr = { class = "row" },
                                                            content = function()
                                                                ui.container {
                                                                    attr = { class = "col-md-2 col-md-offset-3" },
                                                                    content = function()
                                                                        ui.container {
                                                                            attr = { class = "initiative_quorum_out_box" },
                                                                            content = function()
                                                                                ui.container {
                                                                                    attr = { id = "quorum_box", class = "initiative_quorum_box", style = "left:" .. 2 + quorum_percent .. "%" },
                                                                                    content = function()
                                                                                        ui.container {
                                                                                            attr = { id = "quorum_txt" },
                                                                                            content = function()
                                                                                                slot.put(" " .. "Quorum" .. " " .. quorum_percent .. "%" .. "<br>" .. "    (" .. quorum_supporters .. " " .. _ "supporters" .. ")")
                                                                                            end
                                                                                        }
                                                                                    end
                                                                                }
                                                                            end
                                                                        }
                                                                    end
                                                                }
                                                            end
                                                        } ]]


                                                        ui.container {
                                                            attr = { class = "row" },
                                                            content = function()
                                                                ui.container {
                                                                    attr = { class = "col-md-12 initiative_list_box" },
                                                                    content = function()

                                                                        local initiatives_selector = issue:get_reference_selector("initiatives")
                                                                        local highlight_string = param.get("highlight_string")
                                                                        if highlight_string then
                                                                            initiatives_selector:add_field({ '"highlight"("initiative"."name", ?)', highlight_string }, "name_highlighted")
                                                                        end

                                                                        execute.view {
                                                                            module = "initiative",
                                                                            view = "_list_ext2_bs",
                                                                            id = issue.id,
                                                                            params = {
                                                                                --                issue = issue,
                                                                                --                initiatives_selector = initiatives_selector,
                                                                                --                highlight_initiative = for_initiative,
                                                                                --                highlight_string = highlight_string,
                                                                                --                no_sort = true,
                                                                                --                limit = (for_listing or for_initiative) and 5 or nil,
                                                                                --                hide_more_initiatives=false,
                                                                                --                limit=25,
                                                                                for_details = true,
                                                                                --                for_member = for_member,
                                                                                init_ord = init_ord
                                                                            }
                                                                        }
                                                                    end
                                                                }
                                                            end
                                                        }
                                                        ui.container {
                                                            attr = { class = "col-md-4 col-md-offset-8 col-xs-12 col-sm-12 spaceline" },
                                                            content = function()
                                                                local area = Area:by_id(issue.area_id)
                                                                local unit = Unit:by_id(area.unit_id)
                                                                local issue_keywords = ""
                                                                local keywords = Keyword:by_issue_id(issue.id)
                                                                if keywords and #keywords > 0 then
                                                                    for k = 1, #keywords do
                                                                        if not keywords[k].technical_keyword then
                                                                            issue_keywords = issue_keywords .. keywords[k].name
                                                                            if k ~= #keywords then
                                                                                issue_keywords = issue_keywords .. ","
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                                ui.link {
                                                                    attr = { class = "btn btn-primary btn-create spaceline-bottom fixclick" },
                                                                    module = "wizard",
                                                                    params = {
                                                                        issue_id = issue.id,
                                                                        area_id = area.id,
                                                                        area_name = area.name,
                                                                        unit_id = unit.id,
                                                                        unit_name = unit.name,
                                                                        policy_id = issue.policy_id,
                                                                        issue_title = issue.title,
                                                                        issue_brief_description = issue.brief_description,
                                                                        issue_keywords = issue_keywords,
                                                                        problem_description = issue.problem_description,
                                                                        aim_description = issue.aim_description
                                                                    },
                                                                    view = "page_bs7",
                                                                    content = function()
                                                                        ui.container {
                                                                            attr = { class = "row" },
                                                                            content = function()
                                                                                ui.container {
                                                                                    attr = { class = "col-md-3 col-xs-2 col-sm-2" },
                                                                                    content = function()
                                                                                        ui.image { attr = { class = "pen_paper icon-medium" }, static = "svg/pen_paper.svg" }
                                                                                    end
                                                                                }
                                                                                ui.container {
                                                                                    attr = { class = "col-md-9 col-xs-10 col-sm-10" },
                                                                                    content = function()
                                                                                        ui.heading { level = 3, attr = { class = "text-center" }, content = _ "Create your own alternative initiative" }
                                                                                    end
                                                                                }
                                                                            end
                                                                        }
                                                                    end
                                                                }
                                                            end
                                                        }
                                                        if #issue.initiatives > 1 then
                                                            ui.container {
                                                                attr = { class = "row spaceline" },
                                                                content = function()
                                                                    ui.link {
                                                                        attr = { class = "col-md-3 offset9 btn btn-primary btn-large large_btn fixclick text-center" },
                                                                        module = "initiative",
                                                                        view = "compare",
                                                                        params = { issue_id = param.get_id() },
                                                                        image = { static = "png/diff.png" },
                                                                        content = _ "Compare initiatives"
                                                                    }
                                                                end
                                                            }
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
                    attr = { class = "row spaceline" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-12" },
                            content = function()
                                ui.heading { level = 3, attr = { class = "label label-warning-tbox spaceline" }, content = _ "General data" }
                            end
                        }
                    end
                }
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
                                            attr = { class = "col-md-12 well-inside paper" },
                                            content = function()
                                                execute.view { module = "issue", view = "info_data", params = { issue = issue } }
                                            end
                                        }
                                    end
                                }
                            end
                        }
                    end
                }
                if app.session.member then
                    local interested_members_selector = issue:get_reference_selector("interested_members_snapshot"):join("issue", nil, "issue.id = direct_interest_snapshot.issue_id"):add_field("direct_interest_snapshot.weight"):add_where("direct_interest_snapshot.event = issue.latest_snapshot_event")
                    local population_members_selector = issue:get_reference_selector("population_members_snapshot"):join("issue", nil, "issue.id = direct_population_snapshot.issue_id"):add_field("direct_population_snapshot.weight"):add_where("direct_population_snapshot.event = issue.latest_snapshot_event")

                    ui.container {
                        attr = { class = "row spaceline2" },
                        content = function()
                            ui.container {
                                attr = { class = "col-md-12" },
                                content = function()
                                    ui.heading { level = 3, attr = { class = "label label-warning-tbox spaceline" }, content = _ "Interested members" }
                                end
                            }
                            ui.container {
                                attr = { class = "row" },
                                content = function()
                                    execute.view {
                                        module = "member",
                                        view = "_list",
                                        params = {
                                            issue = issue,
                                            members_selector = interested_members_selector
                                        }
                                    }
                                end
                            }
                            ui.container {
                                attr = { class = "row" },
                                content = function()
                                    ui.container {
                                        attr = { class = "col-md-12" },
                                        content = function()
                                            ui.heading { level = 3, attr = { class = "label label-warning-tbox spaceline" }, content = _ "Population members" }
                                        end
                                    }
                                    ui.container {
                                        attr = { class = "row" },
                                        content = function()
                                            execute.view {
                                                module = "member",
                                                view = "_list",
                                                params = {
                                                    issue = issue,
                                                    members_selector = population_members_selector
                                                }
                                            }
                                        end
                                    }
                                end
                            }
                            ui.container {
                                attr = { class = "row spaceline" },
                                content = function()
                                    ui.container {
                                        attr = { class = "col-md-12" },
                                        content = function()
                                            ui.heading { level = 3, attr = { class = "label label-warning-tbox spaceline" }, content = _ "Details" }
                                        end
                                    }
                                    ui.container {
                                        attr = { class = "row" },
                                        content = function()
			                                    ui.container {
			                                        attr = { class = "col-md-12 well-inside paper" },
			                                        content = function()
			                                            execute.view {
			                                                module = "issue",
			                                                view = "_details",
			                                                params = { issue = issue }
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
            end
        }
    end
}

ui.script { static = "js/jquery.quorum_bar.js" }
ui.script { script = "jQuery('#quorum_box').quorum_bar(); " }

