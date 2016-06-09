trace.debug("templateTypePaste=" .. param.get("templateTypePaste"))
trace.debug("deactive=" .. tostring(param.get("deactive", atom.boolean)))

local deactive = param.get("deactive", atom.boolean)
local unitId = param.get("unit_id")
local templateId = param.get("templateTypePaste")
local areas = Area:build_selector({ unit_id = unitId }):exec()
trace.debug("areas.length=" .. #areas)

if deactive then
    -- disattiva tutte le aree precedenti 
    trace.debug("disattivazione delle aree in corso...")
    trace.debug("unitId=" .. unitId)
    for i, area in ipairs(areas) do
        area.active = false
        area:save()
    end
end



local newArea
local newAreaAllowedPolicy
local templateAreas = TemplateArea:build_selector({ templateId = templateId }):exec()

local templateAreaPolicy
local templateAreaPolicySelector
local numConflicts = 0
for t, templateArea in ipairs(templateAreas) do
    newArea = Area:new()
    newArea.unit_id = unitId
    newArea.active = templateArea.active

    newArea.name = templateArea.name
    for q, _area in ipairs(areas) do

        if _area.name == templateArea.name then
            trace.debug("templateArea.name=" .. templateArea.name)
            numConflicts = numConflicts + 1
            newArea.name = templateArea.name .. "_" .. numConflicts
        end
    end

    newArea.description = templateArea.description
    newArea:save()

    trace.debug("templateArea.id=" .. templateArea.id)
    trace.debug("newArea.id=" .. newArea.id)

    templateAreaPolicySelector = TemplateAreaAllowedPolicy:build_selector({ area_id = templateArea.id }):exec()
    newAreaAllowedPolicy = AllowedPolicy:new()

    if #templateAreaPolicySelector > 0 then
        templateAreaPolicy = templateAreaPolicySelector[1]
        trace.debug("templateAreaPolicy=" .. templateAreaPolicy.policy_id)

        trace.debug("templateAreaPolicy.template_area_id=" .. newArea.id)
        trace.debug("templateAreaPolicy.policy_id=" .. templateAreaPolicy.policy_id)



        newAreaAllowedPolicy.area_id = newArea.id
        newAreaAllowedPolicy.policy_id = templateAreaPolicy.policy_id
        newAreaAllowedPolicy.default_policy = templateAreaPolicy.default_policy
        newAreaAllowedPolicy:save()
    end
end


slot.put_into("notice", _ "Areas have been added")
