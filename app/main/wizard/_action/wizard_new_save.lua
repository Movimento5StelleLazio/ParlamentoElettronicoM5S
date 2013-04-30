trace.debug("wizard_new_save")
 
local area_id=param.get("area_id")
local unit_id=param.get("unit_id")
local page=param.get("page",atom.integer)
trace.debug("page="..page)
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
    
    trace.debug("app.session.member.wizard.area_id="..app.session.member.wizard.area_id)
    trace.debug("app.session.member.wizard.policy_id="..app.session.member.wizard.policy_id)
    --trace.debug("wizard_new_issue="..wizard_new_issue)
end

 

if page==2 then
    local question_title=param.get("question_title")
    wizard.question_title=question_title
    trace.debug("wizard.question_title="..app.session.member.wizard.question_title)
end

 
if page==3 then

local question_short_description=param.get("question_short_description")
    wizard.question_short_description=question_short_description
    trace.debug("wizard.question_short_description="..app.session.member.wizard.question_short_description)

end


if page==4 then

local question_keywords=param.get("question_keywords")
    wizard.question_keywords=question_keywords
    trace.debug("wizard.question_keywords="..app.session.member.wizard.question_keywords)

end


if page==5 then
    local problem_description=param.get("problem_description")
    wizard.problem_description=problem_description
    trace.debug("wizard.problem_description"..app.session.member.wizard.problem_description)


end

if page==6 then
    local target_description=param.get("target_description")
    wizard.target_description=target_description
    trace.debug("wizard.target_description="..app.session.member.wizard.target_description)
end

if page==7 then

    local issue_title=param.get("issue_title")
    wizard.issue_title=issue_title
    trace.debug("issue_title="..app.session.member.wizard.issue_title)
end

if page==8 then
    local issue_description=param.get("issue_description")
    wizard.issue_description=issue_description
    trace.debug("issue_description="..app.session.member.wizard.issue_description)
end

if page==9 then
    local issue_draft=param.get("issue_draft")
    wizard.issue_draft=issue_draft
    trace.debug("issue_draft="..app.session.member.wizard.issue_draft)
end

if page==10 then

 

end

if page==11 then

end

if page==12 then

end



