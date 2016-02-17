local initiative_id = param.get("initiative_id", atom.integer) or 0
if initiative_id == 0 then
    initiative_id = param.get_id()
end

local initiative = Initiative:by_id(initiative_id)
local issue = Issue:by_id(initiative.issue_id)
trace.debug("issue = " .. tostring(issue.id))
trace.debug("initiative = " .. tostring(initiative.id))
trace.debug("issue.area_id = " .. tostring(issue.area_id))
local area = Area:by_id(issue.area_id)
trace.debug("area = " .. tostring(area.id))
local unit = Unit:by_id(area.unit_id)
trace.debug("unit = " .. tostring(unit.id))

execute.view {
    module = "initiative",
    view = "_show_bs",
    params = { initiative = initiative }
}
