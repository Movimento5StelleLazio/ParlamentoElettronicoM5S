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
  vote_link_text = direct_voter and _"Change vote" or _"Vote now"
elseif vote_comment_able then
  vote_link_text = direct_voter and _"Update voting comment"
end  


local class = "issue_ext2"
if issue.is_interested then
  class = class .. " interested"
elseif issue.is_interested_by_delegation_to_member_id then
  class = class .. " interested_by_delegation"
end

local arrow_offset = 31
local admission_offset, discussion_offset, verification_offset, voting_offset, committee_offset, committee_voting_offset, finished_offset = 55,58,72,64,58,64,66 

-- Uncomment the following to use svgz instead of svg
local svgz = ""
--local svgz = "z"

if issue.state == "admission" then
  event_name = _"New issue"
  admission_offset = 37
elseif issue.state == "discussion" then
  event_name = _"Discussion started"
  event_image = "comments.png"
  discussion_offset = 37
  arrow_offset = 98
elseif issue.state == "verification" then
  event_name = _"Verification started"
  event_image = "lock.png"
  verification_offset = 53
  arrow_offset = 161
elseif issue.state == "voting" then
  event_name = _"Voting started"
  event_image = "email_open.png"
  voting_offset = 46
  arrow_offset = 224
elseif issue.state == "committee" then
  event_name = _"Committee started"
  event_image = "lock.png"
  committee_offset = 49
  arrow_offset = 298
elseif issue.state == "committee_voting" then
  event_name = _"Committee voting started"
  event_image = "email_open.png"
  committee_voting_offset = 49
  arrow_offset = 361
elseif issue.closed  then
  event_image = "cross.png"
  if issue.state == "finished_with_winner" then 
    event_name = _"Finished (with winner)" 
    event_image = "award_star_gold_2.png"
  elseif issue.state == "finished_without_winner" then
    event_name = _"Finished (without winner)"
    event_image = "cross.png"   
  elseif issue.state == 'canceled_revoked_before_accepted' then
    event_name = _"Canceled (before accepted due to revocation)"
  elseif issue.state == 'canceled_issue_not_accepted' then
    event_name = _"Canceled (issue not accepted)"
  elseif issue.state == 'canceled_after_revocation_during_discussion' then
    event_name = _"Canceled (during discussion due to revocation)"
  elseif issue.state == 'canceled_after_revocation_during_verification' then
    event_name = _"Canceled (during verification due to revocation)"
  elseif issue.state == 'canceled_no_initiative_admitted' then
    event_name = _"Canceled (no initiative admitted)"
  end
  finished_offset = 49
  arrow_offset = 432
end

ui.container{ attr = { class = "row-fluid"}, content = function()
  ui.container{ attr = { class = "span12"}, content = function()
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span3 alert alert-simple"}, content = function()
        ui.container{ attr = { class = "row-fluid"}, content = function()
          ui.container{ attr = { class = "span1"}, content = function()
            if event_image then
              ui.image{ attr = { class = ""}, static = "icons/16/" .. event_image }
            end
          end }
          ui.container{ attr = { class = "span11"}, content = function()
            ui.heading{ level=6, content = event_name or ""}
          end }
        end }
        --ui.tag{ tag = "p", attr = { class = 'issue_state_txt' }, content = issue.state_name or ""}
        ui.tag{ tag = "p", attr = { class = "issue_state_time" }, content = function()
          if issue.closed then
            slot.put(" &middot; ")
            ui.tag{ content = format.interval_text(issue.closed_ago, { mode = "ago" }) }
          elseif issue.state_time_left then
            slot.put(" &middot; ")
            if issue.state_time_left:sub(1,1) == "-" then
              if issue.state == "admission" then
                ui.tag{ content = _("Discussion starts soon") }
              elseif issue.state == "discussion" then
                ui.tag{ content = _("Verification starts soon") }
              elseif issue.state == "verification" then
                ui.tag{ content = _("Voting starts soon") }
              elseif issue.state == "voting" then
                ui.tag{ content = _("Counting starts soon") }
              end
            else
              ui.tag{ content = format.interval_text(issue.state_time_left, { mode = "time_left" }) }
            end
          end
        end }
      end }
      ui.container{ attr = { class = "span9"}, content = function()
        ui.container{ attr = { id = "phases_box_"..issue.id, class = "phases_box"}, content = function()
          ui.image{  attr = { id = "phase_arrow_"..issue.id, class = "phase_arrow", style = "margin-left: "..arrow_offset.."px;" }, static="svg/phase_arrow.svg"..svgz }
          ui.image{  attr = { id = "phases_bar_"..issue.id, class = "phases_bar" }, static = "svg/phases_bar.svg"..svgz }
          ui.image{  attr = { id = "admission_"..issue.id, class = "admission", style = "margin-top: "..admission_offset.."px;" }, static="svg/admission.svg"..svgz }
          ui.image{  attr = { id = "discussion_"..issue.id, class = "discussion", style = "margin-top: "..discussion_offset.."px;" }, static="svg/discussion.svg"..svgz }
          ui.image{  attr = { id = "verification_"..issue.id, class = "verification", style = "margin-top: "..verification_offset.."px;" }, static="svg/verification.svg"..svgz }
          ui.image{  attr = { id = "voting_"..issue.id, class = "voting", style = "margin-top: "..voting_offset.."px;" }, static="svg/voting.svg"..svgz }
          ui.image{  attr = { id = "committee_"..issue.id, class = "committee", style = "margin-top: "..committee_offset.."px;" }, static="svg/committee.svg"..svgz }
          ui.image{  attr = { id = "committee_voting_"..issue.id, class = "committee_voting", style = "margin-top: "..committee_voting_offset.."px;" }, static="svg/voting.svg"..svgz }
          ui.image{  attr = { id = "finished_"..issue.id, class = "finished", style = "margin-top: "..finished_offset.."px;" }, static="svg/finished.svg"..svgz }
        end}
      end }
    end }
  end }
end }

ui.container{ attr = { class = "issue_box"}, content = function()

ui.container{ attr = { class = class }, content = function()
  execute.view{ module = "delegation", view = "_info", params = { issue = issue, member = for_member } }


  if for_listing then
    ui.container{ attr = { class = "content" }, content = function()
      ui.tag { tag="p", attr = { class="issue_title" }, content = "Q"..issue.id.." - "..issue.title }
      ui.tag { tag="p", attr = { class="issue_brief_description" }, content = issue.brief_description }
      ui.link{
        module = "unit", view = "show", id = issue.area.unit_id,
        attr = { class = "unit_link" }, text = issue.area.unit.name
      }
      slot.put(" ")
      ui.link{
        module = "area", view = "show", id = issue.area_id,
        attr = { class = "area_link" }, text = issue.area.name
      }
    end }
  end

  ui.container{ attr = { class = "title" }, content = function()
    
    ui.link{
      attr = { class = "issue_id" },
      text = _("#{policy_name} ##{issue_id}", {
        policy_name = issue.policy.name,
        issue_id = issue.id
      }),
      module = "issue",
      view = "show",
      id = issue.id
    }
  end }
  
--[[
  ui.tag{
    attr = { class = "content issue_policy_info" },
    tag = "div",
    content = function()
    
      ui.tag{ attr = { class = "event_name" }, content = issue.state_name }

      if issue.closed then
        slot.put(" &middot; ")
        ui.tag{ content = format.interval_text(issue.closed_ago, { mode = "ago" }) }
      elseif issue.state_time_left then
        slot.put(" &middot; ")
        if issue.state_time_left:sub(1,1) == "-" then
          if issue.state == "admission" then
            ui.tag{ content = _("Discussion starts soon") }
          elseif issue.state == "discussion" then
            ui.tag{ content = _("Verification starts soon") }
          elseif issue.state == "verification" then
            ui.tag{ content = _("Voting starts soon") }
          elseif issue.state == "voting" then
            ui.tag{ content = _("Counting starts soon") }
          end
        else
          ui.tag{ content = format.interval_text(issue.state_time_left, { mode = "time_left" }) }
        end
      end

    end
  }
--]]

  local links = {}
  
--[[
  if vote_link_text then
    links[#links+1] ={
      content = vote_link_text,
      module = "vote",
      view = "list",
      params = { issue_id = issue.id }
    }
  end
  
  if voteable and not direct_voter then
    if not issue.member_info.non_voter then
      links[#links+1] ={
        content = _"Do not vote directly",
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
      links[#links+1] = { attr = { class = "action" }, content = _"Do not vote directly" }
      links[#links+1] ={
        in_brackets = true,
        content = _"Cancel [nullify]",
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
          links[#links+1] = { content = _"You were interested" }
        else
          links[#links+1] = { content = _"You are interested" }
        end
      end
      
      if not issue.closed and not issue.fully_frozen then
        if issue.member_info.own_participation then
          links[#links+1] = {
            in_brackets = true,
            text    = _"Withdraw",
            module  = "interest",
            action  = "update",
            params  = { issue_id = issue.id, delete = true },
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
        elseif app.session.member:has_voting_right_for_unit_id(issue.area.unit_id) then
          links[#links+1] = {
            text    = _"Add my interest",
            module  = "interest",
            action  = "update",
            params  = { issue_id = issue.id },
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
          links[#links+1] = { text = _"Delegate issue", module = "delegation", view = "show", params = { issue_id = issue.id, initiative_id = for_initiative_id } }
        else
          links[#links+1] = { text = _"Change issue delegation", module = "delegation", view = "show", params = { issue_id = issue.id, initiative_id = for_initiative_id } }
        end
      end
    end

    if config.issue_discussion_url_func then
      local url = config.issue_discussion_url_func(issue)
      links[#links+1] = {
        attr = { target = "_blank" },
        external = url,
        content = _"Discussion on issue"
      }
    end

    if config.etherpad and app.session.member then
      links[#links+1] = {
        attr = { target = "_blank" },
        external = issue.etherpad_url,
        content = _"Issue pad"
      }
    end


    if app.session.member_id and app.session.member:has_voting_right_for_unit_id(issue.area.unit_id) then
      if not issue.fully_frozen and not issue.closed then
      links[#links+1] = {
          attr   = { class = "action" },
          text   = _"Create alternative initiative",
          module = "initiative",
          view   = "new",
          params = { issue_id = issue.id }
        }
      end
    end

  end
    
  ui.container{ attr = { class = "content actions" }, content = function()
    for i, link in ipairs(links) do
      if link.in_brackets then
        slot.put(" (")
      elseif i > 1 then
        slot.put(" &middot; ")
      end
      if link.module or link.external then
        ui.link(link)
      else
        ui.tag(link)
      end
      if link.in_brackets then
        slot.put(")")
      end
    end
  end }

  if not for_listing then
    if issue.state == "canceled_issue_not_accepted" then
      local policy = issue.policy
      ui.container{
        attr = { class = "not_admitted_info" },
        content = _("This issue has been canceled. It failed the quorum of #{quorum}.", { quorum = format.percentage(policy.issue_quorum_num / policy.issue_quorum_den) })
      }
    elseif issue.state:sub(1, #("canceled_")) == "canceled_" then
      ui.container{
        attr = { class = "not_admitted_info" },
        content = _("This issue has been canceled.")
      }
    end
  end
--]]

  if #issue.initiatives == 1 then
    ui.tag{ tag="p", attr = {class = "initiative_count_txt"}, content = #issue.initiatives.._" INITIATIVE TO RESOLVE THE ISSUE"  }
  else
    ui.tag{ tag="p", attr = {class = "initiative_count_txt"}, content = #issue.initiatives.._" INITIATIVES TO RESOLVE THE ISSUE"  }
  end


--[[  
  -- Quorum Bar
    ui.container{ attr = { class = "initiative_quorum_box" }, content = function()
      local policy = issue.policy
      ui.tag{ 
        tag = "p", 
        attr = { class = "initiative_quorum_txt" }, 
        content = _("Quorum (#{quorum})", {quorum = format.percentage(policy.issue_quorum_num / policy.issue_quorum_den) }) 
      }
      ui.container {
        attr = { class = "initiative_quorum_bar" },
        content = function()
        end
      }
    end }
--]]

  ui.container{ attr = { class = "initiative_list_ext content" }, content = function()

    local initiatives_selector = issue:get_reference_selector("initiatives")
    local highlight_string = param.get("highlight_string")
    if highlight_string then
      initiatives_selector:add_field( {'"highlight"("initiative"."name", ?)', highlight_string }, "name_highlighted")
    end
    execute.view{
      module = "initiative",
      view = "_list_ext",
      params = {
        issue = issue,
        initiatives_selector = initiatives_selector,
        highlight_initiative = for_initiative,
        highlight_string = highlight_string,
        no_sort = true,
        limit = (for_listing or for_initiative) and 5 or nil,
        hide_more_initiatives=false,
        limit=25,
        for_member = for_member
      }
    }
  end }
end }

if app.session.member_id and issue.closed then
  ui.container {
    attr = { id = "issue_vote_box_"..issue.id, class = "issue_vote_box" },
    content = function()
      ui.tag{tag = "p", attr = {class="issue_vote_txt"}, content = _"YOUR VOTE IS" }
      if direct_voter then
        ui.container{attr = {class="issue_thumb_cont_up"}, content =function()
          ui.tag{tag = "p", attr = {class="issue_vote_txt"}, content = _"YES" }
          ui.image{ static="svg/thumb_up.svg"..svgz, attr= { class = "thumb"}  }
        end}
      else 
        ui.container{attr = {class="issue_thumb_cont_down"}, content =function()
          ui.tag{tag = "p", attr = {class="issue_vote_txt"}, content = _"NO" }
          ui.image{ static="svg/thumb_down.svg"..svgz, attr= { class = "thumb"}  }
        end}
      end   
    end
  }
end


ui.link{ 
  attr = { id = "issue_see_det_"..issue.id, class = "button orange issue_see_det" },
  module = "issue",
  view = "show_ext",
  id = issue.id,
  content= _"SEE DETAILS"
}

end }

