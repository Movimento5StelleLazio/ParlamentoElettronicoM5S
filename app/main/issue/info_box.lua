slot.set_layout("custom")
local issue = param.get("issue", "table")

if issue.state == "admission" then
    event_name = _ "New issue"
    event_image = nil
elseif issue.state == "discussion" then
    event_name = _ "Discussion started"
    event_image = "comments.png"
elseif issue.state == "verification" then
    event_name = _ "Verification started"
    event_image = "lock.png"
elseif issue.state == "voting" then
    event_name = _ "Voting started"
    event_image = "email_open.png"
elseif issue.state == "committee" then
    event_name = _ "Committee started"
    event_image = "lock.png"
elseif issue.state == "committee_voting" then
    event_name = _ "Committee voting started"
    event_image = "email_open.png"
elseif issue.closed then
    event_image = "cross.png"
    if issue.state == "finished_with_winner" then
        event_name = _ "Finished (with winner)"
        event_image = "award_star_gold_2.png"
    elseif issue.state == "finished_without_winner" then
        event_name = _ "Finished (without winner)"
        event_image = "cross.png"
    elseif issue.state == 'canceled_revoked_before_accepted' then
        event_name = _ "Canceled (before accepted due to revocation)"
    elseif issue.state == 'canceled_issue_not_accepted' then
        event_name = _ "Canceled (issue not accepted)"
    elseif issue.state == 'canceled_after_revocation_during_discussion' then
        event_name = _ "Canceled (during discussion due to revocation)"
    elseif issue.state == 'canceled_after_revocation_during_verification' then
        event_name = _ "Canceled (during verification due to revocation)"
    elseif issue.state == 'canceled_no_initiative_admitted' then
        event_name = _ "Canceled (no initiative admitted)"
    end
end
    ui.container {
    attr = { class = "col-md-4 col-md-offset-2 col-sm-12 col-xs-12  label label-info spaceline spaceline-bottom text-center" },
    content = function()
			ui.tag {
				 content = function()

				  slot.put(event_name or "")
				 end
			}

    end
}
ui.tag {
    tag = "div",
    attr = { class = "col-md-4 col-sm-12 col-xs-12   label label-info spaceline text-center spaceline-bottom " },
    content = function()
        if issue.closed then
            ui.tag { content = format.interval_text(issue.closed_ago, { mode = "ago" }) }
        elseif issue.state_time_left then
            if issue.state_time_left:sub(1, 1) == "-" then
                if issue.state == "admission" then
                    ui.tag { content = _("Discussion starts soon") }
                elseif issue.state == "discussion" then
                    ui.tag { content = _("Verification starts soon") }
                elseif issue.state == "verification" then
                    ui.tag { content = _("Voting starts soon") }
                elseif issue.state == "voting" then
                    ui.tag { content = _("Counting starts soon") }
                end
            else
                ui.tag { attr = { class = "" }, content = format.interval_text(issue.state_time_left, { mode = "time_left" }) }
            end
        end
    end
}