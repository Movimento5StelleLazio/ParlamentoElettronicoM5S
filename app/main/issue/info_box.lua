slot.set_layout("m5s_bs")
local issue = Issue:by_id(param.get_id())

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



ui.container{ attr = { class = "issue_state_info_box2"}, content = function()
  ui.container{ attr = { class = "row-fluid"}, content = function()
    ui.container{ attr = { class = "span12"}, content = function()
      ui.heading{ level=6, attr={class="fittext_info_box1"}, content = function()
        if event_image then
          ui.image{ attr = { class = ""}, static = "icons/16/" .. event_image }
        end
        slot.put(event_name or "")
      end }

    end }
  end }
  ui.container{ attr = { class = "row-fluid"}, content = function()
    ui.container{ attr = { class = "span12"}, content = function()
      ui.tag{ tag = "p", attr={class="fittext_info_box2"}, content = function()
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

ui.script{static = "js/jquery.fittext.js"}
ui.script{script = "jQuery('.fittext_info_box1').fitText(1.0, {minFontSize: '12px', maxFontSize: '22px'}); " }
ui.script{script = "jQuery('.fittext_info_box2').fitText(1.0, {minFontSize: '10px', maxFontSize: '18px'}); " }

