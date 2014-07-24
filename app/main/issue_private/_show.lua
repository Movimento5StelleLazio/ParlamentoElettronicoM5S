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


local class = "issue"
if issue.is_interested then
  class = class .. " interested"
elseif issue.is_interested_by_delegation_to_member_id then
  class = class .. " interested_by_delegation"
end

ui.container{ attr = { class = class }, content = function()

  execute.view{ module = "delegation", view = "_info", params = { issue = issue, member = for_member } }

  if for_listing then
    ui.container{ attr = { class = "content" }, content = function()
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

  local links = {}
  
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

  ui.container{ attr = { class = "initiative_list content" }, content = function()

    local initiatives_selector = issue:get_reference_selector("initiatives")
    local highlight_string = param.get("highlight_string")
    if highlight_string then
      initiatives_selector:add_field( {'"highlight"("initiative"."name", ?)', highlight_string }, "name_highlighted")
    end
    execute.view{
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
  end }
end }

