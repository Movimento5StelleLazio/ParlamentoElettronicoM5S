slot.set_layout("custom")

local type_id = param.get_id()
local state = param.get("state") or "any"
local scope = param.get("scope") or "all_units"
local orderby = param.get("orderby") or "event"
local desc = param.get("desc", atom.boolean) or false
local interest = param.get("interest") or "any"
local member = app.session.member
local ftl_btns = param.get("ftl_btns", atom.boolean) or false
ui.title(function()

    ui.container {
        attr = { class = "row" },
        content = function()                
            ui.container {
                attr = { class = "col-md-3 text-center hidden-xs col-sm-4" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary fixclick btn-back" },
                        module = "index",
                        view = "index",
                        params = { initiative_id = param.get_id() },
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            ui.container {
                attr = { class = "spaceline col-md-6 well-inside paper text-center col-xs-12 col-sm-8" },
                content = function()
                    ui.heading {
                        level = 1,
                        content = function()
                            slot.put(_("Welcome <strong>#{realname}.</strong>", { realname = (app.session.member.realname and app.session.member.realname or app.session.member.login) }))
                        end
                    }

                    ui.heading { level = 6, content = _("Ti trovi ora nell' Assemblea pubblica", { realname = (app.session.member.realname and app.session.member.realname or app.session.member.login) }) }
                end
            }
            --[[ mobile button-back ]]
             ui.container {
                attr = { class = "col-md-12 text-center hidden-sm hidden-md hidden-lg" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary fixclick btn-back" },
                        module = "index",
                        view = "index",
                        params = { initiative_id = param.get_id() },
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            --[[ End mobile button-back ]]
            ui.container {
                attr = { class = "col-md-3 col-sm-12 hidden-xs text-right" },
                content = function()
                    ui.field.popover {
                        attr = {
                            dataplacement = "left",
                            datahtml = "true";
                            datatitle = _ "Box di aiuto per la pagina",
                            datacontent = _ "<h3 class='spaceline-bottom'>Video tutorial</h3><iframe width='560' height='315' src='https://www.youtube.com/embed/OfUpzqDV7Pc' frameborder='0' allowfullscreen></iframe>",
                            datahtml = "true",
                            class = "text-center"
                        },
                        content = function()
                            ui.image { attr = { class = "icon-medium " },static = "png/tutor.png" }
                        end
                    }
                end
            }
        end
    }
end)

-- Right selector
local issues_selector_myinitiatives = Issue:new_selector()
execute.chunk {
    module = "issue",
    chunk = "_filters_ext",
    params = {
        state = state,
        orderby = orderby,
        desc = desc,
        scope = scope,
        interest = interest,
        selector = issues_selector_myinitiatives
    }
}
--[[
if selector then 
  issues_selector_myinitiatives = selector
  selector = nil
else
  slot.put_into("error", "No selector returned from filter")
end
--]]

-- Left selector
local issues_selector_voted = Issue:new_selector()
execute.chunk {
    module = "issue",
    chunk = "_filters_ext",
    params = {
        state = state,
        orderby = orderby,
        desc = desc,
        scope = scope,
        interest = "voted",
        selector = issues_selector_voted
    }
}
--[[
if selector then
  issues_selector_voted = selector
  selector = nil
else
  slot.put_into("error", "No selector returned from filter")
end
--]]

 ui.container {
    attr = { class = "row" },
    content = function()
        ui.container {
            attr = { class = "col-md-12 well text-center" },
            content = function()
                ui.container {
                    attr = { class = "row" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-12" },
                            content = function()
                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "col-md-12 well-inside paper" },
                                            content = function()
                                                ui.heading { level = 2, content = _ "What you want to do?" }
                                                ui.heading { level = 6, content = _ "Puoi leggere, valutare ed integrare le proposte redatte dai cittadini, presentare una tua proposta, votare quelle attualmente in discussione:" }
                                            end
                                        }
                                    end
                                }
                                ui.container {
                                    attr = { class = "row text-center spaceline-bottom" },
                                    content = function()

                                        ui.container {
                                            attr = { class = "col-md-6 col-sm-6 col-xs-12 spaceline" },
                                            content = function()
                                                ui.link {
                                                    attr = { class = "btn btn-primary large_btn" },
                                                    module = "unit",
                                                    view = "show_ext_bs",
                                                    params = { filter = "my_areas" },
                                                    content = function()
                                                        ui.heading { level = 3, content = _ "Homepage read new issues" }
                                                    end
                                                }
                                            end
                                        }

                                        ui.container {
                                            attr = { class = "col-md-6 col-sm-6 col-xs-12 spaceline" },
                                            content = function()
                                                ui.link {
                                                    attr = { class = "btn btn-primary large_btn" },
                                                    module = "unit",
                                                    view = "show_ext_bs",
                                                    params = { create = true, filter = "my_areas" },
                                                    content = function()
                                                        ui.heading { level = 3, content = _ "Homepage write new issue" }
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

btns = {
    default_state = 'any',
    state = {
        {
            "any",
            "open",
            "admission",
            "discussion",
            "verification"
        },
        {
            "voting",
            "committee",
            "closed",
            "canceled"
        }
    },
    default_scope = "all_units",
    scope = {
        {
            "all_units",
            "my_units",
            "citizens"
        },
        {
            "electeds",
            "others"
        }
    }
}


--[[ui.container{attr={class="row"},content=function()
  ui.container{attr={class="col-md-12 text-center"},content=function()
    execute.chunk{
      module = "issue" ,
      chunk = "_filters_btn2_bs" ,
      params = {
        state = state,
        orderby = orderby,
        desc = desc,
        scope = scope,
        btns = btns,
        ftl_btns = ftl_btns
      }
    }
  end }
end }]]

if not issues_selector_voted or not issues_selector_myinitiatives then
    return true
end
ui.container {
	attr = { class = "row" },
	content = function()
	ui.container {
		attr = { class = "col-lg-6 col-md-6 col-sm-12 col-xs-12" },
		content = function()
			ui.container {
				attr = { class = "panel-group", id = "accordion", role = "tablist", ariamultiselectable = "true" },
				content = function()
					ui.container {
						attr = { class = "panel panel-default"},
						content = function()	  
							ui.container {
								attr = { class = "btn btn-primary large_btn ", role="tab", id="headingOne"},
								content = function()						                     
								ui.heading { 
									level = 3, attr = { datatoggle="collapse", class = "panel-title", href="#issue_voted", ariaexpanded="true", ariacontrols="issue_voted"},  
									}
									ui.image { static = "png/arrow-down-icon.png" }					                                   
									ui.link {content = _ " LE TUE VOTAZIONI"}
									
							end
							}
							ui.container {
									attr = { id="issue_voted", class="panel-collapse collapse",  role="tabpanel", arialabelledby="headingOne"},
									content = function()
										ui.container {
												attr = { class="panel-body"},
												content = function()
			                                ui.container {
			                                    attr = { class = "row" },
			                                    content = function()
			                                        execute.view {
			                                            module = "issue",
			                                            view = "_list_ext2_bs",
			                                            params = {
			                                                state = state,
			                                                orderby = orderby,
			                                                desc = desc,
			                                                scope = scope,
			                                                interest = interest,
			                                                list = "voted",
			                                                ftl_btns = ftl_btns,
			                                                for_member = member,
			                                                for_details = false,
			                                                selector = issues_selector_voted
			                                            }
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
	ui.container {
		attr = { class = "col-lg-6 col-md-6 col-sm-12 col-xs-12 spaceline spaceline-bottom" },
		content = function()
			ui.container {
				attr = { class = "panel-group", id = "accordion", role = "tablist", ariamultiselectable = "true" },
				content = function()
					ui.container {
						attr = { class = "panel panel-default"},
						content = function()	  
							ui.container {
								attr = { class = "btn btn-primary large_btn", role="tab", id="headingTwo"},
								content = function()						                     
								ui.heading { 
									level = 3, attr = { datatoggle="collapse", class = "panel-title", href="#issue_proposal", ariaexpanded="true", ariacontrols="issue_proposal"},  
									}
									ui.image { static = "png/arrow-down-icon.png" }					                                   
									ui.link {content = _ " LE TUE PROPOSTE"}
									
							end
							}
							ui.container {
									attr = { id="issue_proposal", class="panel-collapse collapse",  role="tabpanel", arialabelledby="headingTwo"},
									content = function()
									ui.container {
											attr = { class="panel-body"},
											content = function()
	                                ui.container {
	                                    attr = { class = "row" },
	                                    content = function()
	                                        execute.view {
	                                            module = "issue",
	                                            view = "_list_ext2_bs",
	                                            params = {
	                                                state = state,
	                                                orderby = orderby,
	                                                desc = desc,
	                                                scope = scope,
	                                                interest = interest,
	                                                list = "proposals",
	                                                ftl_btns = ftl_btns,
	                                                for_member = member,
	                                                for_details = false,
	                                                selector = issues_selector_myinitiatives
	                                            }
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
