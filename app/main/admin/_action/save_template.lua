local templateType = param.get("templateTypeSave") -- template id from the select input
local templateName = param.get("templateNameSave")
local templateDescription = param.get("templateDescriptionSave")
local unit_id = param.get("unit_id")

local areas = Area:build_selector { unit_id = unit_id }:exec()



trace.debug("saving  templateType:" .. templateType)
trace.debug("saving  templateName:" .. templateName)
trace.debug("saving  templateDescription:" .. templateDescription)
trace.debug("saving  unit_id:" .. unit_id)
--trace.debug("saving  areas:".._areas)

local index = Template:get_all_templates()
local templateNameDuplicate = Template:get_templates_by_name(templateName)

local template = Template:new()
local area_id
template.id = #index + 1
if #templateNameDuplicate > 0 then
    template.name = templateName .. "_1"
else
    template.name = templateName
end
template.description = templateDescription
template:save()

-- table tamplate_area
local templateArea
local templateAreaAllowedPolicy
local templatesLength = db:query("SELECT * FROM template_area")


local areaCompleta

for i, _area in ipairs(areas) do
    templateArea = TemplateArea:new()

    trace.debug("area_id=" .. #templatesLength + i)
    trace.debug("areaCompleta:active=" .. tostring(_area.active))

    templateArea.id = #templatesLength + i
    templateArea.template_id = template.id
    templateArea.name = _area.name
    templateArea.active = _area.active
    templateArea.description = _area.description
    templateArea:save()

    trace.debug("query: SELECT * FROM allowed_policy WHERE area_id=" .. _area.id)
    local allowPolicy = db:query({ "SELECT * FROM allowed_policy WHERE area_id=?", _area.id })
    trace.debug("#allowPolicy=" .. #allowPolicy)

    if #allowPolicy == 1 then
        trace.debug("allowPolicy.area_id=" .. tostring(allowPolicy[1].area_id))
        trace.debug("allowPolicy.policy_id=" .. tostring(allowPolicy[1].policy_id))
        trace.debug("allowPolicy.default_policy=" .. tostring(allowPolicy[1].default_policy))

        -- table tamplate_area_policy
        templateAreaAllowedPolicy = TemplateAreaAllowedPolicy:new()
        templateAreaAllowedPolicy.template_area_id = templateArea.id
        templateAreaAllowedPolicy.policy_id = allowPolicy[1].policy_id
        templateAreaAllowedPolicy.default_policy = allowPolicy[1].default_policy
        templateAreaAllowedPolicy:save()
    end
end


--test output operazione
slot.put_into("notice", _ "Template has been added")
