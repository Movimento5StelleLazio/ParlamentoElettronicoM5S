trace.debug("wizard_new_save")
 
local area_id=param.get("area_id")
local unit_id=param.get("unit_id")
local page=param.get("page",atom.integer)
trace.debug("page="..page)


local policy_id=param.get("policyChooser")
 
if page==1 then
    
   
    trace.debug("policy_id="..policy_id)
    
    --trace.debug("wizard_new_issue="..wizard_new_issue)
    --app.session:save()
end

 

if page==2 then
    local question_title=param.get("question_title")
    question_title=question_title
    
    
    --app.session:save()
end

 
if page==3 then

local question_short_description=param.get("question_short_description")
   question_short_description=question_short_description
     

end


if page==4 then

local question_keywords=param.get("question_keywords")
   question_keywords=question_keywords
   
end


if page==5 then
    local problem_description=param.get("problem_description")
    app.wizard.problem_description=problem_description
    trace.debug("wizard.problem_description"..app.wizard.problem_description)


end

if page==6 then
    local target_description=param.get("target_description")
end

if page==7 then

    local issue_title=param.get("issue_title")
    wizard.issue_title=issue_title
    trace.debug("issue_title="..app.wizard.issue_title)
end

if page==8 then
    local issue_description=param.get("issue_description")
    

end

if page==9 then
    local issue_draft=param.get("issue_draft")
     
end

if page==10 then
local technical_area_1=param.get("local technical_area_1")
local technical_area_2=param.get("local technical_area_2")
local technical_area_3=param.get("local technical_area_3")
local technical_area_4=param.get("local technical_area_4")
 

       
end





if page==11 then

end

if page==12 then

 
end











