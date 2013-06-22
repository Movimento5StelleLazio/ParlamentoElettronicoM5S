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


-- Uncomment the following to use svgz instead of svg
local svgz = ""
--local svgz = "z"

if issue.state == "admission" then
  event_name = _"New issue"
elseif issue.state == "discussion" then
  event_name = _"Discussion started"
  event_image = "comments.png"
elseif issue.state == "verification" then
  event_name = _"Verification started"
  event_image = "lock.png"
elseif issue.state == "voting" then
  event_name = _"Voting started"
  event_image = "email_open.png"
elseif issue.state == "committee" then
  event_name = _"Committee started"
  event_image = "lock.png"
elseif issue.state == "committee_voting" then
  event_name = _"Committee voting started"
  event_image = "email_open.png"
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
end

ui.container{ attr = { class = "row-fluid"}, content = function()
  ui.container{ attr = { class = "span12 issue_box"}, content = function()

    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span3 issue_state_info_box2"}, content = function()
        ui.container{ attr = { class = "row-fluid"}, content = function()
          ui.container{ attr = { class = "span12 text-center"}, content = function()
            ui.heading{ level=6, content = function()
              if event_image then
                ui.image{ attr = { class = ""}, static = "icons/16/" .. event_image }
              end
              slot.put(event_name or "")
            end }
          end }
        end }
        ui.container{ attr = { class = "row-fluid"}, content = function()
          ui.container{ attr = { class = "span12 text-center"}, content = function()

            --ui.tag{ tag = "p", attr = { class = 'issue_state_txt' }, content = issue.state_name or ""}
            ui.tag{ tag = "p", content = function()
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
        end }
      end }
      ui.container{ attr = { class = "span9"}, content = function()
        ui.container{ attr = { class = "pull-right"}, content = function()
          execute.view{ module = "issue", view = "phasesbar", params = { sate=issue.state } }       
        end }
      end }
    end }


    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12 alert alert-simple"}, content = function()

        ui.container{ attr = { class = "row-fluid"}, content = function()
          ui.container{ attr = { class = "span12"}, content = function()
            ui.heading { level=5, content = "Q"..issue.id.." - "..issue.title }
          end }
        end }
    
        ui.container{ attr = { class = "row-fluid"}, content = function()
          ui.container{ attr = { class = "span12"}, content = function()
            execute.view{ module = "delegation", view = "_info", params = { issue = issue, member = for_member } }
          end }
        end }
    
        ui.container{ attr = { class = "row-fluid"}, content = function()
          ui.container{ attr = { class = "span12"}, content = function()
            ui.tag { tag="p", attr = { class="issue_brief_description" }, content = issue.brief_description }
          end }
        end }
        ui.container{ attr = { class = "row-fluid"}, content = function()
          ui.container{ attr = { class = "span12"}, content = function()
            ui.link{
              module = "unit", view = "show", id = issue.area.unit_id,
              attr = { class = "label label-success" }, text = issue.area.unit.name
            }
            slot.put(" ")
            ui.link{
              module = "area", view = "show", id = issue.area_id,
              attr = { class = "label label-important" }, text = issue.area.name
            }
          end }
        end }
    
        ui.container{ attr = { class = "row-fluid"}, content = function()
          ui.container{ attr = { class = "span12"}, content = function()
            ui.link{
              attr = { class = "label label-info" },
              text = _("#{policy_name} ##{issue_id}", {
                policy_name = issue.policy.name,
                issue_id = issue.id
              }),
              module = "issue",
              view = "show",
              id = issue.id
            }
          end }
        end }
    
        local links = {}
      
        ui.container{ attr = { class = "row-fluid"}, content = function()
          ui.container{ attr = { class = "span12 initiative_count_txt"}, content = function()
            local content
            if #issue.initiatives == 1 then
              content= #issue.initiatives.._" INITIATIVE TO RESOLVE THE ISSUE"  
            else
              content= #issue.initiatives.._" INITIATIVES TO RESOLVE THE ISSUE" 
            end
            ui.heading{ level=6, content = content }
          end }
        end }
    
        ui.container{attr = {class="row-fluid"}, content =function()
          ui.container{attr = {class="span12 alert alert-simple"}, content =function()
            local initiatives_selector = issue:get_reference_selector("initiatives")
            local highlight_string = param.get("highlight_string")
            if highlight_string then
              initiatives_selector:add_field( {'"highlight"("initiative"."name", ?)', highlight_string }, "name_highlighted")
            end
            execute.view{
              module = "initiative",
              view = "_list_ext_bs",
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
    
      end }
    end }

    ui.container{attr = {class="row-fluid"}, content =function()
      ui.container{attr = {class="span8"}, content =function()
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
      end }
      ui.container{attr = {class="span4"}, content =function()
        ui.link{ 
          attr = { id = "issue_see_det_"..issue.id, class = "btn btn-primary btn-large pull-right issue_see_det_btn" },
          module = "issue",
          view = "show_ext_bs",
          id = issue.id,
          content = function()
            ui.heading{level=5,content=_"SEE DETAILS"}
          end
        }
      end }
    end }

  end }
end }

