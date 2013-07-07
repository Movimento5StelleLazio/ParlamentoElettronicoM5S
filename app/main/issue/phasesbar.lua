slot.set_layout("m5s_bs")
local state=param.get("state") or "closed"

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

local class = "phases_box phasesbar_autoresize"

ui.container{ attr = { class = "phases_in_box"}, content = function()
  ui.container{ attr = { class = class}, content = function()
    ui.image{  attr = { class = "phase_arrow", type="image/svg+xml", style = "margin-left: "..arrow_offset.."px;".."margin-top:"..arrow_margintop.."px;" }, static="svg/phase_arrow.svg"..svgz }
    ui.image{  attr = { class = "phases_bar", type="image/svg+xml" }, static = "svg/phases_bar_it.svg"..svgz }
    ui.image{  attr = { class = "admission", type="image/svg+xml", style = admission_offset }, static="svg/admission.svg"..svgz }
    ui.image{  attr = { class = "discussion", type="image/svg+xml", style = discussion_offset }, static="svg/discussion.svg"..svgz }
    ui.image{  attr = { class = "verification", type="image/svg+xml", style = verification_offset }, static="svg/verification.svg"..svgz }
    ui.image{  attr = { class = "voting", type="image/svg+xml", style = voting_offset }, static="svg/voting.svg"..svgz }
    ui.image{  attr = { class = "committee", type="image/svg+xml", style = committee_offset }, static="svg/committee.svg"..svgz }
    ui.image{  attr = { class = "committee_voting", type="image/svg+xml", style = committee_voting_offset }, static="svg/voting.svg"..svgz }
    ui.image{  attr = { class = "finished", type="image/svg+xml", style = finished_offset }, static="svg/finished.svg"..svgz }
  end }
end }

ui.script{static = "js/jquery.sizes.js"}
ui.script{static = "js/jquery.scalebar.js"}
ui.script{script = "jQuery('.phasesbar_autoresize').scalebar(); " }
