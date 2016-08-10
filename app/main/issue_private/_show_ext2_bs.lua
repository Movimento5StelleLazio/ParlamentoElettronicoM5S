local issue = param.get("issue", "table")
local initiative_limit = param.get("initiative_limit", atom.integer)
local for_member = param.get("for_member", "table")
local for_listing = param.get("for_listing", atom.boolean)
local for_initiative = param.get("for_initiative", "table")
local for_initiative_id = for_initiative and for_initiative.id or nil
local state = param.get("state")
local orderby = param.get("orderby") or ""
local desc = param.get("desc", atom.boolean)
local interest = param.get("interest")
local scope = param.get("scope")
local view = param.get("view")
local ftl_btns = param.get("ftl_btns", atom.boolean)


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


-- Uncomment the following to use svgz instead of svg
local svgz = ""
--local svgz = "z"
ui.container {
    attr = { class = "col-md-12 well-blue" },
    content = function()
        ui.container {
              attr = { class = "row" },
              content = function()
		             ui.container {
		                 attr = { class = "col-md-12 text-center" },
		                 content = function()
		                     ui.link {
		                         content = function()
		                             ui.heading { attr = { class = "label label-warning" },level = 1, content = "Questione o Problema N° " .. issue.id .. " - " .. (issue.title or _ "No title for this issue") }
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
		                    attr = { class = "row spaceline hidden-xs hidden-sm" },
		                    content = function()
		                        ui.container {
		                            attr = { class = "col-md-7" },
		                            content = function()
		                                ui.heading { level = 3, attr = { class = "label label-warning-tbox" }, content = "Breve descrizione" }
		                            end
		                        }
		
		                        ui.container {
		                            attr = { class = "row" },
		                            content = function()
		                                ui.tag { tag = "p", attr = { class = "col-md-12 well-inside paper" }, content = issue.brief_description or _ "No description available" }
		                            end
		                        }
		                    end
		                }
		                --        local links = {}
		
                     ui.container {
                         attr = { class = "col-md-12" },
                         content = function()
                             local content
                             --if #issue.initiatives == 1 then
                             --    content = #issue.initiatives .. _ " INITIATIVE TO RESOLVE THE ISSUE"
                             --else
                             content = #issue.initiatives .. _ " INITIATIVES TO RESOLVE THE ISSUE"
                             --end
                             ui.heading { level = 3, attr = { class = "label label-warning-tbox" }, content = content }
                         end
                     }
		                ui.container {
		                    attr = { class = "row" },
		                    content = function()
		                        ui.container {
		                            attr = { class = "col-md-12 well-inside paper" },
		                            content = function()
		                                local initiatives_selector = issue:get_reference_selector("initiatives")
		                                local highlight_string = param.get("highlight_string")
		                                if highlight_string then
		                                    initiatives_selector:add_field({ '"highlight"("initiative"."name", ?)', highlight_string }, "name_highlighted")
		                                end
		                                execute.view {
		                                    module = "initiative",
		                                    view = "_list_ext_bs",
		                                    params = {
		                                        issue = issue,
		                                        initiatives_selector = initiatives_selector,
		                                        highlight_initiative = for_initiative,
		                                        highlight_string = highlight_string,
		                                        no_sort = true,
		                                        limit = (for_listing or for_initiative) and 5 or nil,
		                                        hide_more_initiatives = false,
		                                        limit = 10,
		                                        for_member = for_member
		                                    }
		                                }
		                            end
		                        }
		                    end
		                }


                    --                        if app.session.member_id and direct_voter then
                    --                            ui.container {
                    --                                attr = { id = "issue_vote_box_" .. issue.id, class = "col-md-8 issue_vote_box" },
                    --                                content = function()
                    --                                --local initiative = Initiative:new_selector():add_where("issue_id="..issue.id):exec()
                    --
                    --                                    ui.tag { tag = "p", attr = { class = "issue_vote_txt" }, content = _ "YOUR VOTE IS" }
                    --                                    local vote = (Vote:new_selector():add_where("issue_id = " .. issue.id .. " AND member_id = " .. app.session.member.id):optional_object_mode():exec()).grade
                    --                                    trace.debug("vote: " .. tostring(vote))
                    --                                    if vote == 1 then
                    --                                        ui.container {
                    --                                            attr = { class = "issue_thumb_cont_up" },
                    --                                            content = function()
                    --                                                ui.tag { tag = "p", attr = { class = "issue_vote_txt" }, content = _ "YES" }
                    --                                                ui.image { static = "svg/thumb_up.svg" .. svgz, attr = { class = "thumb" } }
                    --                                            end
                    --                                        }
                    --                                    else
                    --                                        ui.container {
                    --                                            attr = { class = "issue_thumb_cont_down" },
                    --                                            content = function()
                    --                                                ui.tag { tag = "p", attr = { class = "issue_vote_txt" }, content = _ "NO" }
                    --                                                ui.image { static = "svg/thumb_down.svg" .. svgz, attr = { class = "thumb" } }
                    --                                            end
                    --                                        }
                    --                                    end
                    --                                end
                    --                            }
                    --                        end
                  ui.container {
                      attr = { class = "row" },
                      content = function()
                          ui.link {
                              attr = { id = "issue_see_det_" .. issue.id, class = "col-md-12 text-center" },
                              module = "issue_private",
                              view = "show_ext_bs",
                              id = issue.id,
                              params = {
                                  view = "area_private",
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
ui.container {
	attr = { class = "row spaceline2" },
	content = function()
	    ui.tag { tag = "hr", attr = { class = "" } }
	end
}


