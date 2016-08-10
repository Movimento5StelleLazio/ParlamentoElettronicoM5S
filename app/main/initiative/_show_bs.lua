slot.set_layout("custom")

local initiative = param.get("initiative", "table")

local show_as_head = param.get("show_as_head", atom.boolean)

initiative:load_everything_for_member_id(app.session.member_id)

local issue = initiative.issue

-- TODO performance
local initiator
if app.session.member_id then
    initiator = Initiator:by_pk(initiative.id, app.session.member.id)
end

if app.session.member_id then
    issue:load_everything_for_member_id(app.session.member_id)
end

local initiators_members_selector = initiative:get_reference_selector("initiating_members")
  :add_field("initiator.accepted", "accepted")
  :add_order_by("member.name")
if initiator and initiator.accepted then
  initiators_members_selector:add_where("initiator.accepted ISNULL OR initiator.accepted")
else
  initiators_members_selector:add_where("initiator.accepted")
end

local initiators = initiators_members_selector:exec()

local initiatives_selector = initiative.issue:get_reference_selector("initiatives")

local class = "initiative_head"

if initiative.polling then
    class = class .. " polling"
end

app.html_title.title = initiative.name
app.html_title.subtitle = _("Initiative ##{id}", { id = initiative.id })

local state = param.get("state")
local orderby = param.get("orderby") or ""
local desc = param.get("desc", atom.boolean)
local interest = param.get("interest")
local scope = param.get("scope")
local view = param.get("view")
local ftl_btns = param.get("ftl_btns", atom.boolean)
local init_ord = param.get("init_ord") or "supporters"

local function round(num, idp)
    return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

local return_view = "show_ext_bs"
local return_module = "issue"
local return_btn_txt = _ "Back"
local return_id = initiative.issue_id
if app.session.member_id ~= nil then
    if view == "homepage" then
        return_module = "index"
        return_view = "homepage_bs"
        return_btn_txt = _ "Back to homepage"
    elseif view == "area" then
        return_module = "area"
        return_view = "show_ext_bs"
        return_btn_txt = _ "Back to issue listing"
        return_id = issue.area_id
    elseif view == "area_private" then
        return_module = "area_private"
        return_view = "show_ext_bs"
        return_btn_txt = _ "Back to issue listing"
        return_id = issue.area_id
    end
end

local url = request.get_absolute_baseurl() .. "initiative/show/" .. tostring(initiative.id) .. ".html"
trace.debug(url)
--url = string.gsub(url, ":", "\%3A")
--trace.debug(url)
url = encode.url { base = request.get_absolute_baseurl(), module = "initiative", view = "show", params = { initiative_id = initiative.id } }
trace.debug(url)

ui.title(function()
    ui.container {
        attr = { class = "row text-center" },
        content = function()
            ui.container {
                attr = { class = "col-md-3 col-sm-5 col-xs-12" },
                content = function()
                    if app.session.member_id ~= nil then
                        ui.link {
                            attr = { class = "btn btn-primary btn-back h2" },
                            module = return_module,
                            id = return_id,
                            view = return_view,
                            params = param.get_all_cgi(),
                            image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                            content = _ "Back to previous page"
                        }
                    end
                end
            }

            ui.container {
                attr = { class = "col-md-7 col-md-offset-1  col-sm-7 col-xs-12 spaceline" },
                content = function()
                            ui.container {
                                attr = { class = "label label-warning" },
                                content = function()
                                    ui.heading { level = 1, attr = { class = "fittext1 uppercase" }, content = _ "Details for initiative I" .. initiative.id }
                                end
                    }
                end
            }
            ui.container {
                attr = { class = "col-md-1 text-right spaceline hidden-xs hidden-sm" },
                content = function()
                    ui.field.popover {
                        attr = {
                            dataplacement = "left",
                            datahtml = "true";
                            datatitle = _ "Box di aiuto per la pagina",
                            datacontent = _ "Ti trovi nei dettagli della PROPOSTA, con le informazioni integrali, in ogni box i tutor per le funzionalità specifiche<div class='spaceline'><iframe width='560' height='315' src='https://www.youtube.com/embed/5oiC5OhkmIk' frameborder='0' allowfullscreen></iframe></div>",
                            datahtml = "true",
                            class = "text-center"
                        },
                        content = function()
                            ui.image { attr = { class = "icon-medium" }, static = "png/tutor.png" }
                        end
                    }
                end
            }
        end
    }
    ui.container {
        attr = { class = "row"},
        content = function()
            ui.container { 
            	attr = {  id = "social_box", class = "col-md-4 col-xs-12 col-sm-12 spaceline3" }, 
            	content = function() 
            	slot.put('<div data-url="' .. url .. '" class="addthis_sharing_toolbox"></div>')
            	end 
         	}
            
            ui.container {
                attr = { class = "col-md-6 col-md-offset-1 col-xs-12 col-sm-12" },
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
            attr = { class = "col-md-12 well" },
            content = function()
                ui.container {
                    attr = { class = "row text-center" },
                    content = function()
                        if initiative.revoked or initiative.issue.fully_frozen and initiative.issue.closed or initiative.admitted == false then
                            ui.container {
                                attr = { class = "col-md-1 spaceline" },
                                content = function()
                                    if initiative.revoked then
                                        ui.container {
                                            attr = { class = "vertical" },
                                            content = function()
                                                ui.image { attr = { class = "icon-small" }, static = "png/delete.png" }
                                                slot.put(_ "Revoked by authors")
                                            end
                                        }
                                    elseif initiative.issue.fully_frozen and initiative.issue.closed or initiative.admitted == false then
                                        ui.field.rank { attr = { class = "rank" }, value = initiative.rank, eligible = initiative.eligible }
                                    end
                                end
                            }
                        end                                    
                                    
                 ui.container {
                    attr = { class = "col-md-10" },
                    content = function()
                        local title_class = ""
                        if initiative.revoked or initiative.issue.fully_frozen and initiative.issue.closed or initiative.admitted == false then
                            title_class = title_class .. " col-md-10"
                            if initiative.revoked then
                                title_class = title_class .. "col-md-10 revoked"
                            end
                        else title_class = title_class .. " col-md-10"
                        end
                        ui.tag {
                            tag = "div",
                            attr = { class = "label label-warning text-center" },
                            content = function()
                                ui.heading {
                                    level = 2,
                                    content = (initiative.name or _ "No title for the initiative!")
                                }
                            end
                        }
                            end
                        }
                                        ui.container {
                                            attr = { class = "col-md-1 hidden-xs hidden-sm text-center" },
                                            content = function()
                                                ui.field.popover {
                                                    attr = {
                                                        dataplacement = "bottom",
                                                        datahtml = "true";
                                                        datatitle = _ "Box di aiuto per la pagina",
                                                        datacontent = _ "La barra delle fasi la trovi in testa alle questioni ed alle proposte, tienila d' occhio, in quanto ti avvisa quando puoi emendare o votare la proposta. ",
                                                        datahtml = "true",
                                                        class = "text-center"
                                                    },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "row" },
                                                            content = function()
                                                                ui.image { attr = { class = "icon-medium" }, static = "png/tutor.png" }
                                                            end
                                                        }
                                                    end
                                                }
                                            end
                                        }
                    end
                }
 --               ui.container {
   --                 attr = { class = "row" },
     --               content = function()
                        ui.container {
                            attr = { class = "col-md-12 spaceline well-inside paper" },
                            content = function()
                                ui.container {
                                    attr = { class = "row" },
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
				                              attr = { class = "row spaceline3 hidden-lg hidden-md" },
				                              content = function()

												end
										  }
													ui.container {
				                              attr = { class = "row" },
				                              content = function()
																	ui.container {
																		attr = { class = "col-md-2 hidden-xs hidden-sm" },
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
                        end
                        }
                                ui.container {
				                              attr = { class = "row spaceline5 hidden-md hidden-lg" },
				                              content = function()

												end
										  }
										 ui.container {
				                              attr = { class = "row spaceline3 hidden-lg hidden-md" },
				                              content = function()

												end
										  }

--                    end
  --              }
                ui.container {
                    attr = { class = "row" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-12" },
                            content = function()
                                if app.session.member_id ~= nil then
                                    if not issue.closed and not initiative.revoked then
                                        ui.container {
                                            attr = { class = "row" },
                                            content = function()
                                                  ui.heading { level = 3, attr = { class = "col-md-11 col-xs-12 col-sm-12 label label-warning-tbox spaceline" }, content = "Azioni possibili" }
                                                ui.container {
                                                    attr = { class = "col-md-1 text-center hidden-xs hidden-sm" },
                                                    content = function()
                                                        ui.field.popover {
                                                            attr = {
                                                                dataplacement = "bottom",
                                                                datahtml = "true";
                                                                datatitle = _ "Box di aiuto per la pagina",
                                                                datacontent = _("Puoi sostenere, ignorare o proporre emendamenti alla proposta.<br /><i>Sostenere</i> la proposta vuol dire solo ritenere che per te la proposta <i>merita</i> di passare alla fase di votazione.<br />Emendare la proposta ti permette di proporre modifiche parziali da sottoporre al giudizio dell'assemblea. Se ritieni che il tuo emendamento <i>deve/non deve</i> essere accolto verrai identificato come sostenitore potenziale, altrimenti verrai identificato come sostenitore. Un SOSTENITORE partecipa attivamente alla promozione della PROPOSTA"),
                                                                datahtml = "true",
                                                                class = "text-center"
                                                            },
                                                            content = function()
                                                                ui.container {
                                                                    attr = { class = "row" },
                                                                    content = function()
                                                                        ui.image { attr = { class = "icon-medium" },static = "png/tutor.png" }
                                                                    end
                                                                }
                                                            end
                                                        }
                                                    end
                                                }
                                            end
                                        }
                                        if issue.state ~= "voting" then
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
                                                                        attr = { class = "spaceline spaceline-bottom" },
                                                                        content = function()
                                                                            execute.view {
                                                                                module = "supporter",
                                                                                view = "_show_box",
                                                                                params = {
                                                                                    initiative = initiative
                                                                                }
                                                                            }
                                                                        end
                                                                    }

                                                                    ui.container {
                                                                        attr = { class = "col-md-3 spaceline spaceline-bottom" },
                                                                        content = function()
                                                                            ui.link {
                                                                                attr = { class = "btn btn-primary btn_size_fix fixclick" },
                                                                                module = "suggestion",
                                                                                view = "new",
                                                                                params = { initiative_id = initiative.id },
                                                                                text = _ "New suggestion"
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
                                            local direct_voter = issue.member_info.direct_voted
                                            local voteable = issue.state == 'voting' and
                                                    app.session.member:has_voting_right_for_unit_id(issue.area.unit_id)

                                            local vote_comment_able = issue.closed and direct_voter

                                            if voteable then
                                                ui.container {
                                                    attr = { class = "row" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "col-md-12 well-inside paper" },
                                                            content = function()
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
			                                                                    attr = { class = "col-md-1 hidden-sm hidden-xs spaceline3" },
			                                                                    content = function()
			                                                                        ui.image { static = "svg/arrow-right.svg", attr = { class = "icon-medium" }}
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
                                                           end
                                                        }
                                                   end
                                                }
                                            end
                                        end
                                    end
                                end
                                ui.container {
                                    attr = { class = "row spaceline" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-6" },
                                            content = function()
                                                ui.heading { level = 3, attr = { class = "label label-warning-tbox" }, content = _ "Full text" }
                                            end
                                        }
                                        ui.heading {
                                            level = 4,
                                            attr = { class = "col-md-6" },
                                            content = _("Latest draft created at #{date} #{time}", {
                                                date = format.date(initiative.current_draft.created),
                                                time = format.time(initiative.current_draft.created)
                                            })
                                        }
                                    end
                                }
                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12 well-inside paper" },
                                            content = function()
                                                local supporter

                                                if app.session.member_id then
                                                    supporter = app.session.member:get_reference_selector("supporters"):add_where { "initiative_id = ?", initiative.id }:optional_object_mode():exec()
                                                end

                                                if supporter and not initiative.issue.closed then
                                                    local old_draft_id = supporter.draft_id
                                                    local new_draft_id = initiative.current_draft.id
                                                    if old_draft_id ~= new_draft_id then
                                                        ui.container {
                                                            attr = { class = "draft_updated_info" },
                                                            content = function()
                                                                slot.put(_ "The draft of this initiative has been updated!")
                                                                slot.put(" ")
                                                                ui.link {
                                                                    content = _ "Show diff",
                                                                    module = "draft",
                                                                    view = "diff",
                                                                    params = {
                                                                        old_draft_id = old_draft_id,
                                                                        new_draft_id = new_draft_id
                                                                    }
                                                                }
                                                                if not initiative.revoked then
                                                                    slot.put(" ")
                                                                    ui.link {
                                                                        text = _ "Refresh support to current draft",
                                                                        module = "initiative",
                                                                        action = "add_support",
                                                                        id = initiative.id,
                                                                        routing = {
                                                                            default = {
                                                                                mode = "redirect",
                                                                                module = "initiative",
                                                                                view = "show",
                                                                                id = initiative.id
                                                                            }
                                                                        }
                                                                    }
                                                                end
                                                            end
                                                        }
                                                    end
                                                end

                                                if not show_as_head then
                                                    local drafts_count = initiative:get_reference_selector("drafts"):count()

                                                    execute.view {
                                                        module = "draft",
                                                        view = "_show",
                                                        params = {
                                                            draft = initiative.current_draft
                                                        }
                                                    }
                                                    if initiator and initiator.accepted and not initiative.issue.half_frozen and not initiative.issue.closed and not initiative.revoked then
                                                        ui.container {
                                                            attr = { class = "row" },
                                                            content = function()
                                                                ui.link {
                                                                    attr = { class = "col-md-offset-7 btn btn-primary col-md-2 text-center" },
                                                                    content = _ "Edit draft",
                                                                    module = "wizard",
                                                                    view = "page_bs9",
                                                                    mode = "put",
                                                                    params = {
                                                                        draft_id = initiative.current_draft.id,
                                                                        initiative_id = initiative.id,
                                                                        area_id = initiative.issue.area_id,
                                                                        unit_id = initiative.issue.area.unit_id,
                                                                        area_name = initiative.issue.area.name,
                                                                        unit_name = initiative.issue.area.unit.name
                                                                    }
                                                                }

                                                                if drafts_count > 1 then
                                                                    ui.link {
                                                                        attr = { class = "btn btn-primary col-md-offset-1 col-md-2 text-center spaceline-bottom" },
                                                                        mode = "redirect",
                                                                        module = "draft",
                                                                        view = "list",
                                                                        params = { initiative_id = initiative.id },
                                                                        text = _("List all revisions (#{count})", { count = drafts_count })
                                                                    }
                                                                end
                                                            end
                                                        }
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
                    attr = { class = "row spaceline" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-12" },
                            content = function()
                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-10" },
                                            content = function()
                                                ui.heading { level = 3, attr = { class = "label label-warning-tbox" }, content = _ "Attachments" }
                                            end
                                        }
                                    end
                                }
                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12  well-inside paper " },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "row spaceline" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "col-md-6 col-sm-12 col-xs-12 text-center" },
                                                           content = function()
                                        								ui.heading { level = 2, content = _ "PRESENTAZIONE IN VIDEO DELLA PROPOSTA" } 
                                        								end
                                        						}
                               								end
                               						}
                                        			ui.container {
                                                    attr = { class = "row spaceline2" },
                                                    content = function()
	                                                       ui.container {
	                                                            attr = { class = "col-md-6  col-sm-12 col-xs-12 text-center spaceline" },
	                                                           content = function()
	                                                                ui.container {
	                                                                    content = function()
	                                                                    		local resource = Resource:by_initiative_id(initiative.id)
	                                                                        if resource ~= nil then
	                                                                            if resource.url == "" or resource.url == nil then
	                                                                            		ui.image {attr = { class = "img-responsive" }, static = "png/video-player.png" }
	                                                                            elseif string.find(resource.url, "https://www.youtube.com/watch") then
	                                                                                local code = resource.url:sub(resource.url:find("=") + 1)
	                                                                                trace.debug("url: " .. resource.url .. "; code: " .. code)
	                                                                                trace.debug(code)
	                                                                                slot.put('<iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/' .. code .. '\" frameborder=\"0\" allowfullscreen></iframe>')
	                                                                            else
	                                                                                slot.put(_"Wrong link format")
	                                                                            end
	                                                                        else
	                                                                            ui.image { static = "png/video-player.png" }
	                                                                        end
	                                                                    		if initiator and initiator.accepted and not initiative.issue.half_frozen and not initiative.issue.closed and not initiative.revoked then
					                                                                	ui.link {
					                                                                		module = "initiative",
					                                                                		view = "edit_video",
					                                                                		id = initiative.id,
					                                                                		attr = { class = "btn btn-primary btn-large large_btn" },
					                                                                		text = _"Change video url"
					                                                                	}
	                                                                    	end
	                                                                    end
	                                                                }
	                                                            end
	                                                       }
                                                        ui.container {
                                                            attr = { class = "col-md-6 col-sm-12 col-xs-12" },
                                                            content = function()
                                                            execute.view { module = "attachment", view = "list", id = initiative.id }
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

                --//  suggestion area
                ui.container {
                    attr = { class = "row spaceline" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-12" },
                            content = function()
                                if not show_as_head then
                                    execute.view {
                                        module = "suggestion",
                                        view = "_list",
                                        params = {
                                            initiative = initiative,
                                            suggestions_selector = initiative:get_reference_selector("suggestions"),
                                            tab_id = param.get("tab_id")
                                        }
                                    }
                                end
                            end
                        }
                    end
                }
                if app.session.member_id ~= nil then
                    ui.container {
                        attr = { class = "row spaceline" },
                        content = function()
                            ui.container {
                                attr = { class = "col-md-7" },
                                content = function()
                                    ui.heading {
                                        level = 3,
                                        attr = { class = "label label-warning-tbox" },
                                        content = function()
                                            ui.tag { content = _ "Authors" }
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
                                    if #initiators > 0 then
                                        ui.container {
                                            attr = { class = "row" },
                                            content = function()
                                                if #initiators > 1 then
                                                    for i, initiator in ipairs(initiators) do
                                                        slot.put(" ")
                                                        if app.session:has_access("everything") then
                                                            execute.view {
                                                                module = "member",
                                                                view = "_show_thumb",
                                                                params = {
                                                                    member = initiator,
                                                                    initiative = initiative,
                                                                    issue = issue,
                                                                    initiator = initiator
                                                                }
                                                            }                                            

                                                            slot.put(" ")                                                   
                                                        end
                                                    end                                                            

                                                else

                                                    ui.container {
                                                        attr = { class = "row" },
                                                        content = function()
                                                            ui.container {
                                                                attr = { class = "col-md-12" },
                                                                content = function()
                                                                    execute.view { module = "member", view = "_info_data", id = initiators[1].id, params = { module = "initiative", view = "show", content_id = initiative.id } }
                                                                end
                                                            }
                                                        end
                                                    }
                                                end
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "row spaceline" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "row" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "col-md-12" },
                                                            content = function()
                                                                ui.tag { tag = "hr" }
                                                            end
                                                        }
                                                    end
                                                }
-- invited as initiator
  if initiator and initiator.accepted == nil and not initiative.issue.half_frozen and not initiative.issue.closed then
    ui.container{
      attr = { class = "initiator_invite_info" },
      content = function()
        slot.put(_"You are invited to become initiator of this initiative.")
        slot.put(" ")
        ui.link{
	  attr = { class = "btn btn-primary btn_xlarge h3 text-center" },
          image  = { static = "icons/16/tick.png" },
          text   = _"Accept invitation",
          module = "initiative",
          action = "accept_invitation",
          id     = initiative.id,
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
        slot.put(" ")
        ui.link{
	  attr = { class = "btn btn-primary  btn_xlarge h3 text-center" },
          image  = { static = "icons/16/cross.png" },
          text   = _"Refuse invitation",
          module = "initiative",
          action = "reject_initiator_invitation",
          params = {
            initiative_id = initiative.id,
            member_id = app.session.member.id
          },
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
                                                if initiator and initiator.accepted and not initiative.issue.fully_frozen and not initiative.issue.closed and not initiative.revoked then
                                                    ui.link {
                                                        attr = { class = "action btn btn-primary btn_xlarge h3 text-center" },
                                                        content = function()
                                                            slot.put(_ "Invite initiator")
                                                        end,
                                                        module = "initiative",
                                                        view = "add_initiator",
                                                        params = { initiative_id = initiative.id }
                                                    }
                                                    if #initiators > 1 then
							slot.put(" ")
                                                        ui.link {
							    attr = { class = "btn btn-primary btn_xlarge h3 text-center" },
                                                            content = function()
                                                                slot.put(_ "Remove initiator")
                                                            end,
                                                            module = "initiative",
                                                            view = "remove_initiator",
                                                            params = { initiative_id = initiative.id }
                                                        }
                                                    end
                                                end
                                                if initiator and initiator.accepted == false then
						    slot.put(" ")
                                                    ui.link {
							attr = { class = "btn btn-primary btn_xlarge h3 text-center" },
                                                        text = _ "Cancel refuse of invitation",
                                                        module = "initiative",
                                                        action = "remove_initiator",
                                                        params = {
                                                            initiative_id = initiative.id,
                                                            member_id = app.session.member.id
                                                        },
                                                        routing = {
                                                            ok = {
                                                                mode = "redirect",
                                                                module = "initiative",
                                                                view = "show",
                                                                id = initiative.id
                                                            }
                                                        }
                                                    }
                                                end
                                                if (initiative.discussion_url and #initiative.discussion_url > 0) then
                                                    if initiative.discussion_url:find("^https?://") then
                                                        if initiative.discussion_url and #initiative.discussion_url > 0 then
							    slot.put(" ")
                                                            ui.link {
                                                                attr = {
								    class = "btn btn-primary btn_xlarge h3 text-center",
                                                                    target = "_blank",
                                                                    title = _ "Discussion with initiators"
                                                                },
                                                                text = _ "Discuss with initiators",
                                                                external = initiative.discussion_url
                                                            }
                                                        end
                                                    else
                                                        slot.put(encode.html(initiative.discussion_url))
                                                    end
                                                end
                                                if initiator and initiator.accepted and not initiative.issue.half_frozen and not initiative.issue.closed and not initiative.revoked then
						    slot.put(" ")
                                                    ui.link {
							attr = { class = "btn btn-primary btn_xlarge h3 text-center" },
                                                        text = _ "change discussion URL",
                                                        module = "initiative",
                                                        view = "edit",
                                                        id = initiative.id
                                                    }
						    slot.put(" ")
						    ui.link {
                                                        attr = { class = "btn btn-primary btn_xlarge h3 text-center" },
                                                        content = _ "Revoke initiative",
                                                        module = "initiative",
                                                        view = "revoke",
                                                        id = initiative.id,
                                                        image = { attr = { class = "col-md-3 thumb" }, static = "png/cross.png" },
                                                        content = _ "Revoke initiative"
                                                    }
                                                end
                                            end
                                        }
                                    else
                                        ui.heading { level = 6, content = _ "No author for this issue" }
                                    end
                                end
                            }
                        end
                    }
                end     
                ui.container {
                   attr = { class = "col-md-12 well-blue spaceline" },
                   content = function()
                ui.container {
                    attr = { class = "row text-center" },
                    content = function()
		                         ui.container {
		                            attr = { class = "col-md-8 col-md-offset-2 label label-warning" },
		                            content = function()
		                                ui.heading {
		                                    level = 1,
		                                    content = function()
		                                        ui.tag { content = _ "PROBLEMA O QUESTIONE SOLLEVATA:" }
		                                    end
		                                }
		                                ui.tag {
		                                    content = function()
		                                        ui.heading { level = 2, content = issue.title }
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
                                            attr = { class = "col-md-3 label label-info" },
                                            content = function()
                                                ui.heading {
                                                    level = 3,
                                                    attr = { class = "" },
                                                    content = _ "Brief description"
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
                                                ui.container {
                                                    attr = { class = "row" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "col-md-12 initiative_list_box" },
                                                            content = function()
                                                                ui.field.text {
                                                                    value = issue.brief_description
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
                                                ui.link {
                                                    attr = { id = "issue_see_det_" .. issue.id, class = "col-md-4 col-md-offset-4 text-center" },
                                                    module = "issue",
                                                    view = "show_ext_bs",
                                                    id = issue.id,
                                                    params = {
                                                        view = "area",
                                                        state = state,
                                                        orderby = orderby,
                                                        desc = desc,
                                                        interest = interest,
                                                        scope = scope,
                                                        view = view,
                                                        ftl_btns = ftl_btns
                                                    },
                                                    content = function()
                                                        ui.heading { level = 3, attr = { class = "btn btn-primary large_btn" }, content = _ "SEE DETAILS" }
                                                    end
                                                }
                                            end
                                        }
                                    end
                                }

                    end
                }
                --[[ui.container{ attr = { class = "row spaceline"}, content = function()
                            execute.view{
                              module = "committee",
                              view   = "view",
                              params = {
                                state=state,
                                orderby=orderby,
                                desc=desc,
                                scope=scope,
                                interest=interest,
                                list="proposals",
                                ftl_btns=ftl_btns,
                                for_member=member,
                                for_details = false,
                                selector = issues_selector_myinitiatives
                              }
                            }

                end }]]


                ui.container {
                    attr = { class = "row" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-12" },
                            content = function()
                                if not show_as_head then

                                    if app.session.member_id ~= nil then
                                        if initiative.issue.fully_frozen and initiative.issue.closed then
                                            local members_selector = initiative.issue:get_reference_selector("direct_voters"):left_join("vote", nil, { "vote.initiative_id = ? AND vote.member_id = member.id", initiative.id }):add_field("direct_voter.weight as voter_weight"):add_field("coalesce(vote.grade, 0) as grade"):add_field("direct_voter.comment as voter_comment"):left_join("initiative", nil, "initiative.id = vote.initiative_id"):left_join("issue", nil, "issue.id = initiative.issue_id")

                                            ui.container {
                                                attr = { class = "row spaceline" },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "col-md-3" },
                                                        content = function()
                                                            ui.heading {
                                                                level = 3,
                                                                attr = { class = "label label-warning-tbox" },
                                                                content = _ "Voters"
                                                            }
                                                        end
                                                    }
                                                end
                                            }

                                            execute.view {
                                                module = "member",
                                                view = "_list",
                                                params = {
                                                    initiative = initiative,
                                                    for_votes = true,
                                                    members_selector = members_selector,
                                                    paginator_name = "voter"
                                                }
                                            }
                                        end

                                        local members_selector = initiative:get_reference_selector("supporting_members_snapshot"):join("issue", nil, "issue.id = direct_supporter_snapshot.issue_id"):join("direct_interest_snapshot", nil, "direct_interest_snapshot.event = issue.latest_snapshot_event AND direct_interest_snapshot.issue_id = issue.id AND direct_interest_snapshot.member_id = member.id"):add_field("direct_interest_snapshot.weight"):add_where("direct_supporter_snapshot.event = issue.latest_snapshot_event"):add_where("direct_supporter_snapshot.satisfied"):add_field("direct_supporter_snapshot.informed", "is_informed")

                                        if members_selector:count() > 0 then
                                            if issue.fully_frozen then
                                                ui.container {
                                                    attr = { class = "row spaceline" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "col-md-3" },
                                                            content = function()
                                                                ui.heading {
                                                                    level = 3,
                                                                    attr = { class = "label label-warning-tbox" },
                                                                    content = _ "Supporters (before begin of voting)"
                                                                }
                                                            end
                                                        }
                                                    end
                                                }
                                            else
                                                ui.container {
                                                    attr = { class = "row spaceline" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "col-md-10" },
                                                            content = function()
                                                                ui.heading {
                                                                    level = 3,
                                                                    attr = { class = "label label-warning-tbox" },
                                                                    content = _ "Supporters"
                                                                }
                                                            end
                                                        }
                                                    end
                                                }
                                            end

                                            execute.view {
                                                module = "member",
                                                view = "_list",
                                                params = {
                                                    initiative = initiative,
                                                    members_selector = members_selector,
                                                    paginator_name = "supporters"
                                                }
                                            }
                                        else
                                            if issue.fully_frozen then
                                                ui.container {
                                                    attr = { class = "row spaceline" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "col-md-10" },
                                                            content = function()
                                                                ui.heading {
                                                                    level = 3,
                                                                    attr = { class = "label label-warning-tbox" },
                                                                    content = _ "No supporters (before begin of voting)"
                                                                }
                                                            end
                                                        }
                                                    end
                                                }
                                            else
                                                ui.container {
                                                    attr = { class = "row spaceline" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "col-md-10" },
                                                            content = function()
                                                                ui.heading {
                                                                    level = 3,
                                                                    attr = { class = "label label-warning-tbox" },
                                                                    content = _ "No supporters"
                                                                }
                                                            end
                                                        }
                                                    end
                                                }
                                            end
                                        end

                                        local members_selector = initiative:get_reference_selector("supporting_members_snapshot"):join("issue", nil, "issue.id = direct_supporter_snapshot.issue_id"):join("direct_interest_snapshot", nil, "direct_interest_snapshot.event = issue.latest_snapshot_event AND direct_interest_snapshot.issue_id = issue.id AND direct_interest_snapshot.member_id = member.id"):add_field("direct_interest_snapshot.weight"):add_where("direct_supporter_snapshot.event = issue.latest_snapshot_event"):add_where("NOT direct_supporter_snapshot.satisfied"):add_field("direct_supporter_snapshot.informed", "is_informed")
                                        local population_members_selector = issue:get_reference_selector("population_members_snapshot"):join("issue", nil, "issue.id = direct_population_snapshot.issue_id"):add_field("direct_population_snapshot.weight"):add_where("direct_population_snapshot.event = issue.latest_snapshot_event")
                                        if issue.fully_frozen then
                                            ui.container {
                                                attr = { class = "row spaceline" },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "col-md-10" },
                                                        content = function()
                                                            ui.heading {
                                                                level = 3,
                                                                attr = { class = "label label-warning-tbox" },
                                                                content = _ "Potential supporters (before begin of voting)"
                                                            }
                                                        end
                                                    }
                                                end
                                            }
                                        else
                                            ui.container {
                                                attr = { class = "row spaceline" },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "col-md-10" },
                                                        content = function()
                                                            ui.heading {
                                                                level = 3,
                                                                attr = { class = "label label-warning-tbox" },
                                                                content = _ "Potential supporters"
                                                            }
                                                        end
                                                    }
                                                end
                                            }
                                        end
                                        if members_selector:count() > 0 then
                                            execute.view {
                                                module = "member",
                                                view = "_list",
                                                params = {
                                                    initiative = initiative,
                                                    members_selector = members_selector,
                                                    paginator_name = "potential_supporters"
                                                }
                                            }
                                        else
                                            if issue.fully_frozen then
                                                ui.container {
                                                    attr = { class = "row well-inside paper" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "col-md-12" },
                                                            content = function()
                                                                ui.heading {
                                                                    level = 4,
                                                                    content = _ "No potential supporters (before begin of voting)"
                                                                }
                                                            end
                                                        }
                                                    end
                                                }
                                            else
                                                ui.container {
                                                    attr = { class = "row well-inside paper" },
                                                    content = function()
                                                        ui.container {
                                                            attr = { class = "col-md-12" },
                                                            content = function()
                                                                ui.heading {
                                                                    level = 4,
                                                                    content = _ "No potential supporters"
                                                                }
                                                            end
                                                        }
                                                    end
                                                }
                                            end
                                        end

                                        ui.container {
                                            attr = { class = "row spaceline" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "col-md-10" },
                                                    content = function()
                                                        ui.heading { level = 3, attr = { class = "label label-warning-tbox" }, content = _ "Population members" }
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
                                    end
                                    if app.session.member_id ~= nil then
                                        ui.container {
                                            attr = { class = "row spaceline" },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "col-md-10" },
                                                    content = function()
                                                        ui.heading {
                                                            level = 3,
                                                            attr = { class = "label label-warning-tbox" },
                                                            content = _ "Details"
                                                        }
                                                    end
                                                }
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "row" },
                                            content = function() 
			                                        ui.container {
			                                            attr = { class = "col-ms-12 well-inside paper" },
			                                            content = function()                                                                           
						                                        execute.view {
						                                            module = "initiative",
						                                            view = "_details",
						                                            params = {
						                                                initiative = initiative,
						                                                members_selector = members_selector
						                                            }
						                                        } 
			                                        	 end
			                                        }  
	                                        end
                                        }   
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
