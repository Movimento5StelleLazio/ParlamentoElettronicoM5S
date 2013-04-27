trace.debug("wizard_new_save")
 
local area_id=param.get("area_id")
local unit_id=param.get("unit_id")

local wizard= app.session.member.wizard

if not app.session.member.wizard then
app.session.member.wizard={}
wizard=app.session.member.wizard
end
 
 
local policy_id=param.get("policyChooser")
wizard.area_id=area_id
wizard.unit_id=unit_id
wizard.policy_id=policy_id

trace.debug("wizard.area_id="..app.session.member.wizard.area_id)
trace.debug("wizard.policy_id="..app.session.member.wizard.policy_id)
--trace.debug("wizard_new_issue="..wizard_new_issue)