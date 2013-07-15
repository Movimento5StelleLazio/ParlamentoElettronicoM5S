slot.set_layout("custom")

local indietro = param.get("indietro",atom.boolean)
local page_rendered

function readParam(page)
 
local objParam={}


if page==0 then


end

if page==1 then
    
   
    --trace.debug("policy_id="..policy_id)
    
    --trace.debug("wizard_new_issue="..wizard_new_issue)
    --app.session:save()
end

 

if page==2  then
     
     if not indietro then 
        objParam[#objParam+1]= {name="policy_id",value=param.get("policyChooser")}
     else
     
    --objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
     objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
        
     end
    
end

 
if page==3 then
  
   if not indietro then 
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
    else
     objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
    objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
  --  objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
    end

end


if page==4 then

     if not indietro then 
       objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
       objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
       objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
     else
       objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
       objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
       objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
       --objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
      end
 
end


if page==5 then
    
   if not indietro then 
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   else
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   --objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   end
  

end

if page==6 then

    if not indietro then
       objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
       objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
       objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
       objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
       objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
    else
       objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
       objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
       objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
       objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
       objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
      -- objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
     
    end
  
end

if page==7 then
   
    if not indietro then
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
 else
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
  -- objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
    
    
 
 end
  
    
end

if page==8 then
    if not indietro then
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
   objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
    
    else
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
   objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
  -- objParam[#objParam+1]= {name="initiative_brief_description",value=param.get("initiative_brief_description")}
    
    end
     
end

if page==9 then

if not indietro then
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
   objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
   objParam[#objParam+1]= {name="initiative_brief_description",value=param.get("initiative_brief_description")}
else
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
   objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
   objParam[#objParam+1]= {name="initiative_brief_description",value=param.get("initiative_brief_description")}
   --objParam[#objParam+1]= {name="draft",value=param.get("draft")}
 

end

   -- local issue_draft=param.get("issue_draft")
     
end

if page==10 then
 
 
if not indietro then
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
   objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
   objParam[#objParam+1]= {name="initiative_brief_description",value=param.get("initiative_brief_description")}
   objParam[#objParam+1]= {name="draft",value=param.get("draft")}
 else
 
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
   objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
   objParam[#objParam+1]= {name="initiative_brief_description",value=param.get("initiative_brief_description")}
   objParam[#objParam+1]= {name="draft",value=param.get("draft")}
   --objParam[#objParam+1]= {name="technical_area_1",value=param.get("technical_area_1")}
   
 end

       
end


if page==11 then

    if not indietro then
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
   objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
   objParam[#objParam+1]= {name="initiative_brief_description",value=param.get("initiative_brief_description")}
   objParam[#objParam+1]= {name="draft",value=param.get("draft")}
   objParam[#objParam+1]= {name="technical_area_1",value=param.get("technical_area_1")}
--   else
--   
--   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
--   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
--   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
--   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
--   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
--   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
--   objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
--   objParam[#objParam+1]= {name="initiative_brief_description",value=param.get("initiative_brief_description")}
--   objParam[#objParam+1]= {name="draft",value=param.get("draft")}
--   objParam[#objParam+1]= {name="technical_area_1",value=param.get("technical_area_1")}
   
   
   
   
   local value=""
   local proposer=""
   if param.get("proposer_hidden_1") then
   
         value=param.get("proposer_hidden_1")
         proposer="proposer1"
   end
   if  param.get("proposer_hidden_2") then
   
         value=param.get("proposer_hidden_2")
         proposer="proposer2"
   end
   if  param.get("proposer_hidden_3") then
       
         value=param.get("proposer_hidden_3")
         proposer="proposer3"
    
   end
   
   objParam[#objParam+1]= {name=proposer,value=value}
   
   
   
   end 


end

if page==12 then

 
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
   objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
   objParam[#objParam+1]= {name="initiative_brief_description",value=param.get("initiative_brief_description")}
   objParam[#objParam+1]= {name="draft",value=param.get("draft")}
   objParam[#objParam+1]= {name="technical_area_1",value=param.get("technical_area_1")}
   
   local value=""
   local proposer=""
   if param.get("proposer_hidden_1") then
   
         value=param.get("proposer_hidden_1")
         proposer="proposer1"
   end
   if  param.get("proposer_hidden_2") then
   
         value=param.get("proposer_hidden_2")
         proposer="proposer2"
   end
   if  param.get("proposer_hidden_3") then
       
         value=param.get("proposer_hidden_3")
         proposer="proposer3"
    
   end
   
   objParam[#objParam+1]= {name=proposer,value=value}
 
  
 
end


return objParam
end

--///////////////////////////////////////////////////////////////// 


local area_id=param.get("area_id" )  
local area_name="..."
local unit_id=param.get("unit_id" ) 
local unit_name="..."
 

 

if not area_id  then
    area_id=app.session.member.area_id
    trace.debug("restore session area_id..."..app.session.member.area_id)
else
    app.session.member.area_id=area_id
    trace.debug("saving session area_id..."..app.session.member.area_id)
end

if not unit_id then
    unit_id=app.session.member.unit_id
    trace.debug("restore session unit_id..."..app.session.member.unit_id)
else
    app.session.member.unit_id=unit_id
    trace.debug("saving session unit_id..."..app.session.member.unit_id)
end

local selector_unit= db:query( "SELECT * FROM unit WHERE id="..unit_id )
 

trace.debug("#selector_unit="..#selector_unit)
if #selector_unit==1 then
unit_name=selector_unit[1].name
end

local selector_area= db:query( "SELECT * FROM area WHERE id="..area_id )
 

trace.debug("#selector_area="..#selector_area)
if #selector_area==1 then
area_name=selector_area[1].name
end

local page=param.get("page",atom.integer)

if not page  or page < 1 then
trace.debug("page=not page!") 
page=1
trace.debug("page="..page) 

else

page=page+1
end

if indietro then
    trace.debug("indietro="..tostring(indietro))
    page_rendered=page-2
    page=page-1
    if page_rendered==0 then
     page=0
    end
else
    trace.debug("indietro=false")
    indietro=false
   
    if page>12 then
    page=12
    end
    
     page_rendered=page
    
end
trace.debug("page="..page) 
  
if page==12 then
            trace.debug("rendering view:"..page)
          
            execute.view{ 
                               module = "wizard", 
                               view = "_page_bs12", 
                               params = {
                                           wizard= readParam(page),
                                           area_name=area_name,
                                           area_id=area_id,
                                           unit_name=unit_name,
                                           unit_id=unit_id,
                                           page=page
                                         }
                             }
   return
                             
end



if page <= 12 and page >=1 then   
        ui.container{attr={class="row-fluid"},content=function()
          ui.container{attr={class="span12 well"},content=function()
            ui.container{attr={class="row-fluid"},content=function()
              ui.container{attr={class="span12 text-center"},content=function()
                ui.heading{level=1, attr={class="uppercase"},content= _"Create new issue"}
                ui.heading{level=2,attr={class="spaceline"}, content= function()
                  slot.put(_"Unit"..": ".."<strong>"..unit_name.."</strong>" )
                end }
                ui.heading{level=2,content= function()
                  slot.put( _"Area"..": ".."<strong>"..area_name.."</strong>" )
                end }
              end }
            end }
            ui.container{attr={class="row-fluid spaceline2"},content=function()
              ui.container{attr={class="span12 depression_box"},content=function()
               
                  execute.view{
                    module = "wizard",
                    view = "_page_bs"..page_rendered,
                    params = {
                      wizard= readParam(page_rendered),
                      area_id=area_id,
                      area_name=area_name,
                      unit_id=unit_id,
                      unit_name=unit_name,
                     
                      page=page_rendered
                    }
                  }
                
                
              end }
            end }
          end }
        end  }

else

        ui.container{attr={class="row-fluid"},content=function()
          ui.container{attr={class="span12 well"},content=function()
            ui.container{attr={class="row-fluid"},content=function()
              ui.container{attr={class="span12 text-center"},content=function()
                ui.heading{level=1, attr={class="uppercase"},content= _"Create new issue"}
                ui.heading{level=2,attr={class="spaceline"}, content= function()
                  slot.put(_"Unit"..": ".."<strong>"..unit_name.."</strong>" )
                end }
                ui.heading{level=2,content= function()
                  slot.put( _"Area"..": ".."<strong>"..area_name.."</strong>" )
                end }
              end }
            end }
            ui.container{attr={class="row-fluid spaceline2"},content=function()
              ui.container{attr={class="span12 depression_box"},content=function()
                trace.debug("page="..page)
               trace.debug("unit_id="..unit_id)
               unit_id= atom.integer:load(unit_id)

                  execute.view{
                    module = "wizard",
                    view = "show_ext_bs",
                    id= unit_id
                    
                  }
         
              end }
            end }
          end }
        end  }

end
    
    
    
     
