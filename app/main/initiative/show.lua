local initiative = Initiative:by_id(param.get("initiative_id", atom.integer))
if not initiative then
    initiative = Initiative:by_id(param.get_id())
end

local issue = Issue:by_id(initiative.issue_id)
trace.debug("issue = "..tostring(issue.id))
trace.debug("initiative = "..tostring(initiative.id))
trace.debug("issue.area_id = "..tostring(issue.area_id))
local area = Area:by_id(issue.area_id)
trace.debug("area = "..tostring(area.id))
local unit = Unit:by_id(area.unit_id)
trace.debug("unit = "..tostring(unit.id))	

if app.session.member or unit.public then
	execute.view {
	    module = "initiative",
	    view = "_show_bs",
	    params = { initiative = initiative }
	}
else
	slot.put_into("error", "You must be logged in to have access to the private area.")
	execute.view {
                module = "index",
                view = "index"
        }
end
