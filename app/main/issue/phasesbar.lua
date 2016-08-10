slot.set_layout("custom")
local state = param.get("state") or "closed"

local arrow_offset = 16
local arrow_margintop = -3
local admission_offset, discussion_offset, verification_offset, voting_offset, committee_offset, committee_voting_offset, finished_offset

-- Uncomment the following to use svgz instead of svg
local svgz = ""
--local svgz = "z"

if state == "admission" then
    admission_offset = "margin-top: 29px;"
elseif state == "discussion" then
    discussion_offset = "margin-top: 25px;"
    arrow_offset = 83
elseif state == "verification" then
    verification_offset = "margin-top: 42px;height: 27px;margin-left: 168px;"
    arrow_offset = 146
elseif state == "voting" then
    voting_offset = "margin-top: 35px;"
    arrow_offset = 209
elseif state == "committee" then
    committee_offset = "margin-top: 36px;"
    arrow_offset = 281
elseif state == "committee_voting" then
    committee_voting_offset = "margin-top: 38px;"
    arrow_offset = 344
    arrow_margintop = -8
else
    finished_offset = "margin-top: 38px;margin-left: 432px;height: 41px;"
    arrow_offset = 416
end

-- local class = 
ui.container {
    attr = { class = "phases_in_box " },
    content = function()
        ui.container {
            attr = { class = "phases_box phasesbar_autoresize" },
            content = function()
                if state == "finished_without_winner" or state == "finished_with_winner" then
                    state = "closed"
                end
                ui.image { attr = { class = "phase_bar img-responsive" }, static = "png/bar_" .. state .. ".png" }
            --                ui.image { attr = { class = "phase_arrow", style = "margin-left: " .. arrow_offset .. "px;" .. "margin-top:" .. arrow_margintop .. "px;" }, static = "png/phase_arrow.png" }
            --                ui.image { attr = { class = "phases_bar", }, static = "png/phases_bar_it.png" }
            --                ui.image { attr = { class = "admission", style = admission_offset }, static = "png/admission.png" }
            --                ui.image { attr = { class = "discussion", style = discussion_offset }, static = "png/discussion.png" }
            --                ui.image { attr = { class = "verification", style = verification_offset }, static = "png/verification.png" }
            --                ui.image { attr = { class = "voting", style = voting_offset }, static = "png/voting.png" }
            --                ui.image { attr = { class = "committee", style = committee_offset }, static = "png/committee.png" }
            --                ui.image { attr = { class = "committee_voting", style = committee_voting_offset }, static = "png/voting.png" }
            --                ui.image { attr = { class = "finished", style = finished_offset }, static = "png/finished.png" }
            end
        }
    end
}
ui.script { static = "js/jquery.sizes.js" }
ui.script { static = "js/jquery.scalebar.js" }
ui.script { script = "jQuery('.phasesbar_autoresize').scalebar(); " }
