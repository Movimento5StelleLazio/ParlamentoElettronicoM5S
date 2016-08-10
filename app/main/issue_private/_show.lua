local issue = param.get("issue", "table")
local initiative_limit = param.get("initiative_limit", atom.integer)
local for_member = param.get("for_member", "table")
local for_listing = param.get("for_listing", atom.boolean)
local for_initiative = param.get("for_initiative", "table")
local for_initiative_id = for_initiative and for_initiative.id or nil

local direct_voter
if app.session.member_id then
    direct_voter = issue.member_info.direct_voted
end

local voteable = app.session.member_id and issue.state == 'voting' and
        app.session.member:has_voting_right_for_unit_id(issue.area.unit_id)

local vote_comment_able = app.session.member_id and issue.closed and direct_voter

local vote_link_text
if voteable then
    vote_link_text = direct_voter and _ "Change vote" or _ "Vote now"
elseif vote_comment_able then
    vote_link_text = direct_voter and _ "Update voting comment"
end


local class = "row"
if issue.is_interested then
    class = class .. "row"
elseif issue.is_interested_by_delegation_to_member_id then
    class = class .. " interested_by_delegation"
end

ui.container {
    attr = { class = "well-inside paper" },
    content = function()

        ui.container {
            attr = { class = "row spaceline text-center" },
            content = function()
			       execute.view { module = "delegation", view = "_info", params = { issue = issue, member = for_member } }

        if for_listing then
				ui.container {
                attr = { class = "col-md-10 col-md-offset-1 col-sm-12 col-xs-12 text-center label label-warning h1" },
                content = function()
                	  ui.image { attr = { class = "icon-small" }, static = "parlamento_icon_small.png" }
                    ui.link {
                        module = "unit_private",
                        view = "show",
                        id = issue.area.unit_id,
                        attr = { class = "unit_link" },
                        text = issue.area.unit.name
                    }
                    slot.put(" - ")
                    ui.link {
                        module = "area_private",
                        view = "show",
                        id = issue.area_id,
                        attr = { class = "area_link" },
                        text = issue.area.name
                    }                   
                end
            }
        end
		  ui.container {
			   attr = { class = "col-md-10 col-md-offset-1 col-sm-10 col-sm-offset-1 col-xs-12 text-center" },
			   content = function()

			       local initiatives_selector = issue:get_reference_selector("initiatives")
			       local highlight_string = param.get("highlight_string")
			       if highlight_string then
			           initiatives_selector:add_field({ '"highlight"("initiative"."name", ?)', highlight_string }, "name_highlighted")
			       end
			       execute.view {
			           module = "initiative",
			           view = "_list",
			           params = {
			               issue = issue,
			               initiatives_selector = initiatives_selector,
			               highlight_initiative = for_initiative,
			               highlight_string = highlight_string,
			               no_sort = true,
			               limit = (for_listing or for_initiative) and 5 or nil,
			               for_member = for_member
			           }
			       }
			   end
		  }            
		  ui.container {
			   attr = { class = "col-md-10 col-md-offset-1 text-center label label-success spaceline" },
			   content = function()
			   ui.image { attr = { class = "icon-small" }, static = "png/committee_big.png" }
			   ui.tag {content = _ " STATUS: "}
		       ui.tag {content = issue.state_name }
            end
        }
		  ui.container {
			   attr = { class = "col-md-5 col-md-offset-1 col-sm-6 col-xs-12 label label-info spaceline" },
			   content = function()
                if issue.closed then
                    slot.put("")
                	  ui.image { attr = { class = "icon-small" }, static = "png/clock-time.png" }
                    ui.tag {content = format.interval_text(issue.closed_ago, { mode = "ago" }) }
                elseif issue.state_time_left then
                    slot.put("")
                    if issue.state_time_left:sub(1, 1) == "-" then
                        if issue.state == "admission" then
                            ui.image { attr = { class = "icon-small" }, static = "png/clock-time.png" }
                            ui.tag { content = _("Discussion starts soon") }
                        elseif issue.state == "discussion" then
                            ui.image { attr = { class = "icon-small" }, static = "png/clock-time.png" }
                            ui.tag { content = _("Verification starts soon") }
                        elseif issue.state == "verification" then 
                            ui.image { attr = { class = "icon-small" }, static = "png/clock-time.png" }                            
                            ui.tag { content = _("Voting starts soon") }
                        elseif issue.state == "voting" then
                            ui.image { attr = { class = "icon-small" }, static = "png/clock-time.png" }
                            ui.tag { content = _("Counting starts soon") }
                        end
                    else
                        ui.image { attr = { class = "icon-small" }, static = "png/clock-time.png" }                        
                        ui.tag { content = format.interval_text(issue.state_time_left, { mode = " time_left" }) }
                    end
                end
            end
        }  
  			 ui.container {
				   attr = { class = "col-md-5 col-sm-6 col-xs-12 label label-info spaceline spaceline-bottom" },
				   content = function()
				    ui.image { attr = { class = "icon-small" }, static = "png/voting.png" }
	             ui.link {
	                 text = _("#{policy_name} ##{issue_id}", {
	                     policy_name = issue.policy.name,
	                     issue_id = issue.id
	                 }),
	                 module = "issue_private",
	                 view = "show",
	                 id = issue.id
	            }
	      end
	      }      

        local links = {}

        if vote_link_text then

            links[#links + 1] = {
					 attr = { class = "btn btn-primary xlarge_btn filter_btn fixclick spaceline" }, 
                content = vote_link_text,
                module = "vote",
                view = "list",
                params = { issue_id = issue.id }
            }
        end

        if voteable and not direct_voter then
            if not issue.member_info.non_voter then
                links[#links + 1] = {
					     attr = { class = "btn btn-primary xlarge_btn filter_btn fixclick spaceline" }, 
                    content = _ "Do not vote directly",
                    module = "vote",
                    action = "non_voter",
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
            else
                links[#links + 1] = { attr = { class = "action" }, content = _ "Do not vote directly" }
                links[#links + 1] = {
					     attr = { class = "btn btn-primary xlarge_btn filter_btn fixclick spaceline" }, 
                    in_brackets = true,
                    content = _ "Cancel [nullify]",
                    module = "vote",
                    action = "non_voter",
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
        end

        if not for_member or for_member.id == app.session.member_id then

            if app.session.member_id then

                if issue.member_info.own_participation then
                    if issue.closed then
                    
                    

                        links[#links + 1] = {attr = { class = "col-md-5 col-md-offset-1 label label-success spaceline",style = "margin-right: 10px;" },content = _ "You were interested" } 
                  
              
                    else

                        links[#links + 1] = { attr = { class = "col-md-5 col-md-offset-1 label label-success spaceline", style = "margin-right: 10px;" },content = _ "You are interested" }
 
                       end
  					   end
                if not issue.closed and not issue.fully_frozen then
                    if issue.member_info.own_participation then
				        ui.container {
				            content = function() 
                        links[#links + 1] = {
                            attr = { class = "col-md-5 label label-danger spaceline  spaceline-bottom"},
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
                        links[#links + 1] = {
                            attr = { class = "btn btn-primary large_btn filter_btn fixclick spaceline spaceline-bottom" },
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
                end

                if not issue.closed and app.session.member:has_voting_right_for_unit_id(issue.area.unit_id) then
                    if issue.member_info.own_delegation_scope ~= "issue" then
                        links[#links + 1] = { attr = { class = " btn btn-primary large_btn filter_btn fixclick  spaceline3" }, text = _ "Delegate issue", module = "delegation", view = "show", params = { issue_id = issue.id, initiative_id = for_initiative_id } }
                    else
                        links[#links + 1] = { attr = { class = "btn btn-primary large_btn filter_btn fixclick  spaceline3" }, text = _ "Change issue delegation", module = "delegation", view = "show", params = { issue_id = issue.id, initiative_id = for_initiative_id } }
                    end
                end
            end

            if config.issue_discussion_url_func then
                local url = config.issue_discussion_url_func(issue)
                links[#links + 1] = {
                    attr = { class = "btn btn-primary large_btn filter_btn fixclick spaceline", target = "_blank" },
                    external = url,
                    content = _ "Discussion on issue"
                }
            end

            if config.etherpad and app.session.member then
                links[#links + 1] = {
                    attr = { class = "btn btn-primary large_btn filter_btn fixclick spaceline", target = "_blank" },
                    external = issue.etherpad_url,
                    content = _ "Issue pad"
                }
            end

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
            if app.session.member_id and app.session.member:has_voting_right_for_unit_id(issue.area.unit_id) then
                if not issue.fully_frozen and not issue.closed then
                    links[#links + 1] = {
                        attr = { class = "btn btn-primary large_btn filter_btn fixclick action spaceline" },
                        text = _ "Create alternative initiative",
                        module = "wizard",
                        view = "page_bs7",
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
                    }
                end
            end
        end
                for i, link in ipairs(links) do
                    if link.in_brackets then
                        slot.put("")
                    elseif i > 1 then
                        slot.put("")
                    end
                    if link.module or link.external then
                        ui.link(link)
                    else
                        ui.tag(link)
                    end
                    if link.in_brackets then
                        slot.put("")
                    end
                end
        if not for_listing then
            if issue.state == "canceled_issue_not_accepted" then
                local policy = issue.policy
                ui.container {
                    attr = { class = "not_admitted_info" },
                    content = _("This issue has been canceled. It failed the quorum of #{quorum}.", { quorum = format.percentage(policy.issue_quorum_num / policy.issue_quorum_den) })
                }
            elseif issue.state:sub(1, #("canceled_")) == "canceled_" then
                ui.container {
                    attr = { class = "not_admitted_info" },
                    content = _("This issue has been canceled.")
                }
            end
        end

					 --[[] ui.container {
						   attr = { class = "row" },
						   content = function()

						       local initiatives_selector = issue:get_reference_selector("initiatives")
						       local highlight_string = param.get("highlight_string")
						       if highlight_string then
						           initiatives_selector:add_field({ '"highlight"("initiative"."name", ?)', highlight_string }, "name_highlighted")
						       end
						       execute.view {
						           module = "initiative",
						           view = "_list",
						           params = {
						               issue = issue,
						               initiatives_selector = initiatives_selector,
						               highlight_initiative = for_initiative,
						               highlight_string = highlight_string,
						               no_sort = true,
						               limit = (for_listing or for_initiative) and 5 or nil,
						               for_member = for_member
						           }
						       }
						   end
					  } ]]

    end
}
    end
}
