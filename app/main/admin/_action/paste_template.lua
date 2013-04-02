trace.debug("templateTypePaste="..param.get("templateTypePaste"))
trace.debug("deactive="..tostring(param.get("deactive",atom.boolean)))

local deactive=param.get("deactive",atom.boolean)
local unitId=param.get("unit_id")
local templateId=param.get("templateTypePaste")
local areas=Area:build_selector({unit_id=unitId}):exec()
trace.debug("areas:"..#areas)

if deactive then
    -- disattiva tutte le aree precedenti 
    trace.debug("disattivazione delle aree in corso...")
    trace.debug("unitId="..unitId)
    for i,area in ipairs(areas) do
        area.active=false
        area:save()
    end
end

 

local newArea
local newAreaAllowedPolicy=AllowedPolicy:new()
local templateAreas=TemplateArea:build_selector({templateId=templateId}):exec()

local templateAreaPolicy 
local templateAreaPolicySelector
local numConflicts=0
for t,templateArea in ipairs(templateAreas) do
    newArea= Area:new()
    newArea.unit_id=unitId
    newArea.active=templateArea.active
    trace.debug("areas.length:"..#areas)
    newArea.name=templateArea.name
    for q,_area in ipairs(areas) do
       
        if _area.name ==  templateArea.name then 
            trace.debug("templateArea.name="..templateArea.name)
            numConflicts=numConflicts+1
            newArea.name=templateArea.name.."_"..numConflicts
            
        end
    
    end
    
    newArea.description=templateArea.description
    newArea:save()
    
    trace.debug("templateArea.id="..templateArea.id)
    
    templateAreaPolicySelector=TemplateAreaAllowedPolicy:build_selector({area_id=templateArea.id}):exec()
    
    if #templateAreaPolicySelector>0 then
   -- trace.debug("templateAreaPolicy="..templateAreaPolicy)        
       templateAreaPolicy=templateAreaPolicySelector[1]
        
        local duplicateAllowedPolicy=AllowedPolicy:by_pk(templateAreaPolicy.template_area_id,templateAreaPolicy.policy_id)
        
        if not duplicateAllowedPolicy then
        newAreaAllowedPolicy.area_id=templateAreaPolicy.template_area_id
        newAreaAllowedPolicy.policy_id=templateAreaPolicy.policy_id
        newAreaAllowedPolicy.default_policy=templateAreaPolicy.default_policy
        newAreaAllowedPolicy:save()
        end
    end
end


slot.put_into("notice", _"Areas have been added")
