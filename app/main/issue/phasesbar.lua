slot.set_layout("m5s_bs")
local state=param.get("state") or "closed"
local size=param.get("size") or ""

local arrow_offset = 16
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
else 
  finished_offset = "margin-top: 38px;margin-left: 432px;height: 41px;"
  arrow_offset = 416
end

local class= "phases_box"
if size == "large" then
  class = class.." phases_box_large"
end

ui.container{ attr = { class = class}, content = function()
  ui.image{  attr = { class = "phase_arrow", style = "margin-left: "..arrow_offset.."px;" }, static="svg/phase_arrow.svg"..svgz }
  ui.image{  attr = { class = "phases_bar" }, static = "svg/phases_bar_it.svg"..svgz }

  ui.image{  attr = { class = "admission", style = admission_offset }, static="svg/admission.svg"..svgz }
  ui.image{  attr = { class = "discussion", style = discussion_offset }, static="svg/discussion.svg"..svgz }
  ui.image{  attr = { class = "verification", style = verification_offset }, static="svg/verification.svg"..svgz }
  ui.image{  attr = { class = "voting", style = voting_offset }, static="svg/voting.svg"..svgz }
  ui.image{  attr = { class = "committee", style = committee_offset }, static="svg/committee.svg"..svgz }
  ui.image{  attr = { class = "committee_voting", style = committee_voting_offset }, static="svg/voting.svg"..svgz }
  ui.image{  attr = { class = "finished", style = finished_offset }, static="svg/finished.svg"..svgz }
end}
