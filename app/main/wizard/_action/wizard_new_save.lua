trace.debug("wizard_new_save")
 
local area_id=param.get("area_id")
local unit_id=param.get("unit_id")
local page=param.get("page")

local wizard= app.session.member.wizard

if not app.session.member.wizard then
    app.session.member.wizard={}
    wizard=app.session.member.wizard
end
 
if page==1 then
local policy_id=param.get("policyChooser")
wizard.area_id=area_id
wizard.unit_id=unit_id
wizard.policy_id=policy_id

trace.debug("wizard.area_id="..app.session.member.wizard.area_id)
trace.debug("wizard.policy_id="..app.session.member.wizard.policy_id)
--trace.debug("wizard_new_issue="..wizard_new_issue)
end


if page==2 then

end

if page==3 then

end
if page==4 then

end
if page==5 then

end
if page==6 then

end
if page==7 then

end
if page==8 then

end
if page==9 then

end

if page==10 then

end

if page==11 then

end

if page==12 then

end

