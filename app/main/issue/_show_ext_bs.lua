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
  ui.container{ attr = { class = "span12"}, content = function()
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span6 issue_state_info_box"}, content = function()
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
        end }
      end }
      ui.container{ attr = { class = "span6"}, content = function()
        ui.link{
          attr = { id = "issue_see_det_"..issue.id, class = "btn btn-primary details_btn pull-right" },
          module = "issue",
          view = "show_ext",
          id = issue.id,
          content = function()
            ui.heading{level=5,content=_"SEE DETAILS"}
          end
        }
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
            ui.link{
              module = "unit", view = "show_ext_bs", id = issue.area.unit_id,
              attr = { class = "label label-success" }, text = issue.area.unit.name
            }
            slot.put(" ")
            ui.link{
              module = "area", view = "show_ext_bs", id = issue.area_id,
              attr = { class = "label label-important" }, text = issue.area.name
            }
          end }
        end }
        ui.container{ attr = { class = "row-fluid"}, content = function()
          ui.container{ attr = { class = "span12"}, content = function()
            ui.link{
              attr = { class = "issue_id" },
              text = _("#{policy_name} ##{issue_id}", {
                policy_name = issue.policy.name,
                issue_id = issue.id
              }),
              module = "issue",
              view = "show_ext",
              id = issue.id
            }
          end }
        end }

        ui.container{attr = {class="row-fluid"}, content =function()
          ui.container{attr = {class="span12"}, content =function()
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
  end }
end }


--[[
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

    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.tag { tag="p", attr = { class="issue_title" }, content = "Q"..issue.id.." - "..issue.title }
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
    end }

    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
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
    end }

    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        if #issue.initiatives == 1 then
          ui.tag{ tag="p", attr = {class = "initiative_count_txt"}, content = #issue.initiatives.._" INITIATIVE TO RESOLVE THE ISSUE"  }
        else
          ui.tag{ tag="p", attr = {class = "initiative_count_txt"}, content = #issue.initiatives.._" INITIATIVES TO RESOLVE THE ISSUE"  }
        end
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
          attr = { id = "issue_see_det_"..issue.id, class = "btn btn-primary btn-large" },
          module = "issue",
          view = "show_ext",
          id = issue.id,
          content = function()
            ui.heading{level=4,content=_"SEE DETAILS"}
          end
        }
      end }
    end }

  end }
end }
--]]
