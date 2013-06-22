slot.set_layout("m5s_bs")

function readParam(page)
 
local objParam={}
 
if page==1 then
    
   
    --trace.debug("policy_id="..policy_id)
    
    --trace.debug("wizard_new_issue="..wizard_new_issue)
    --app.session:save()
end

 

if page==2 then
     
     objParam[#objParam+1]= {name="policy_id",value=param.get("policyChooser")}
    
end

 
if page==3 then
  
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
 

end


if page==4 then

   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}


--local question_keywords=param.get("question_keywords")
--question_keywords=question_keywords
   
end


if page==5 then
    
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   
    
   


end

if page==6 then

   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}

  
end

if page==7 then
   
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
 
  
    
end

if page==8 then
    
   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
   objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
    
    
    
    --local issue_description=param.get("issue_description")
    

end

if page==9 then

   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
   objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
   objParam[#objParam+1]= {name="initiative_brief_description",value=param.get("initiative_brief_description")}


   -- local issue_draft=param.get("issue_draft")
     
end

if page==10 then
 
 

   objParam[#objParam+1]= {name="issue_title",value=param.get("issue_title")}
   objParam[#objParam+1]= {name="policy_id",value=param.get("policy_id")}
   objParam[#objParam+1]= {name="issue_brief_description",value=param.get("issue_brief_description")}
   objParam[#objParam+1]= {name="issue_keywords",value=param.get("issue_keywords")}
   objParam[#objParam+1]= {name="problem_description",value=param.get("problem_description")}
   objParam[#objParam+1]= {name="aim_description",value=param.get("aim_description")}
   objParam[#objParam+1]= {name="initiative_title",value=param.get("initiative_title")}
   objParam[#objParam+1]= {name="initiative_brief_description",value=param.get("initiative_brief_description")}
   objParam[#objParam+1]= {name="draft",value=param.get("draft")}
 

       
end


if page==11 then


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
   if param.get("proposer1",atom.boolean) then
   
         value=param.get("proposer1",atom.boolean)
         proposer="proposer1"
   end
   if  param.get("proposer2",atom.boolean) then
   
         value=param.get("proposer2",atom.boolean)
         proposer="proposer2"
   end
   if  param.get("proposer3",atom.boolean) then
       
         value=param.get("proposer3",atom.boolean)
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

if not page  or page <= 1 then
    page=1
end
 
  
 if page==12 then
            trace.debug("rendering view:"..page)
          
            execute.view{ 
                               module = "wizard", 
                               view = "_page12", 
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
            
ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 well"},content=function()
    ui.container{attr={class="row-fluid"},content=function()
      ui.container{attr={class="span12 text-center"},content=function()
        ui.heading{level=1,content= _"Create new initiative"}
        ui.heading{level=2,content= _"Unit"..": "..unit_name }
        ui.heading{level=2,content= _"Area"..": "..area_name }
      end }
    end }
    ui.container{attr={class="row-fluid"},content=function()
      ui.container{attr={class="span12 alert alert-simple"},content=function()
        if page <= 12 and page >=1 then
          execute.view{
            module = "wizard",
            view = "_page_bs"..page,
            params = {
              wizard= readParam(page),
              area_id=area_id,
              unit_id=unit_id,
              page=page
            }
          }
        end
      end }
    end }
  end }
end }
    


--[[
ui.container
{
    attr={id="wizardContainer" , class="wizardContainer"},
    content=function()

        ui.container
        {
                attr={id="wizard_head",style="height:150px"},
                content=function()
                
                
                  ui.container
                        {
                                attr={id="wizardTitolo",class="titoloWizardHead"},
                                content=function()
                                      ui.tag{
                                            tag="pre",
                                            attr={class="titoloWizard" },
                                            content= _"Create new initiative"
                                          }
                                          
                                          
                                end
                         }
                   
                
                  ui.container
                        {
                                attr={id="wizardTitoloUnita",class="titoloWizardHead", style="height:30px;diplay:block"},
                                content=function()
                                      ui.tag{
                                            tag="p",
                                            attr={class="wizardHeader",style="top: -2ex;"},
                                            content= _"Unit"..":"
                                          
                                          }
                                      ui.tag{
                                            tag="p",
                                            attr={style="float: left;left: 1ex;position: relative;top: -2ex;"},
                                            content=unit_name
                                           }
                                end
                         }
                                
                                  
                  ui.container
                        {
                                attr={id="wizardTitoloAreaHeader",class="titoloWizardHead", style="height:30px"},
                                content=function()
                                      ui.tag{
                                            tag="p",
                                            attr={ class="wizardHeader" ,style="top: -2ex;"},
                                            content= _"Area"..":"
                                            
                                          }
                                       ui.tag{
                                            tag="span",
                                            attr={style="font-size: 26px; left: 17px; text-overflow: ellipsis; text-align: left; height: 27px; position: relative; overflow: hidden; margin: 0px; line-height: 27px; white-space: nowrap; float: left; width: 480px; top: 7px;"},
                                            nultiline=false,
                                            content=area_name
                                           }
                                end
                         }                       
                                
                       
                        
                end
        
        }


trace.debug("inital page="..page)

ui.container
{
    attr={id="mainContainerWizard" , class="mainContainerWizard"},
    content=function()
    
    -- page 1
            if page==1 then
            trace.debug("rendering view:"..page)
           
            execute.view{ 
                           module = "wizard", 
                           view = "_page1", 
                           params = {
                                        wizard= readParam(page),
                                        area_id=area_id,
                                        unit_id=unit_id,
                                        page=page
                                     }
                         }
            
            end --fine page1
            
            
            
           
                            
                          
           
            -- page 2
            
            if page==2 then
               
            trace.debug("rendering view:"..page)
            execute.view{ 
                               module = "wizard", 
                               view = "_page2", 
                               params = {
                                          wizard= readParam(page),
                                          area_id=area_id,
                                          unit_id=unit_id,
                                          page=page
                                         }
                             }
            
            end
            
             
            if page==3 then
            trace.debug("rendering view:"..page)
             execute.view{ 
                               module = "wizard", 
                               view = "_page3", 
                               params = {
                                           wizard= readParam(page), 
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                         }
                             }
            
            end
            
            
            if page==4 then
            trace.debug("rendering view:"..page)
            execute.view{ 
                               module = "wizard", 
                               view = "_page4", 
                               params = {
                                           wizard= readParam(page), 
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                         }
                             }
            
            end
            
            
            if page==5 then
            trace.debug("rendering view:"..page)
            execute.view{ 
                               module = "wizard", 
                               view = "_page5", 
                               params = {
                                           wizard= readParam(page), 
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                         }
                             }
            end
            
           
      
            
            if page==6 then
            trace.debug("rendering view:"..page)
            execute.view{ 
                               module = "wizard", 
                               view = "_page6", 
                               params = {
                                            wizard= readParam(page), 
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                         }
                             }
            end
            
           
            
            if page==7 then
            trace.debug("rendering view:"..page)
            execute.view{ 
                               module = "wizard", 
                               view = "_page7", 
                               params = {
                                            wizard= readParam(page), 
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                         }
                             }
            end
            
            
            if page==8 then
            trace.debug("rendering view:"..page)
            execute.view{ 
                               module = "wizard", 
                               view = "_page8", 
                               params = {
                                           wizard= readParam(page), 
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                         }
                             }
            end
            
            if page==9 then
            trace.debug("rendering view:"..page)
            execute.view{ 
                               module = "wizard", 
                               view = "_page9", 
                               params = {
                                           wizard= readParam(page), 
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                         }
                             }
            end
            
            if page==10 then
            trace.debug("rendering view:"..page)
            execute.view{ 
                               module = "wizard", 
                               view = "_page10", 
                               params = {
                                           wizard= readParam(page), 
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                         }
                             }
            end
            
            if page==11 then
            trace.debug("rendering view:"..page)
            execute.view{ 
                               module = "wizard", 
                               view = "_page11", 
                               params = {
                                           wizard= readParam(page), 
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                         }
                             }
            end
            
          
              
           
         end
         }
end 
}
--]]

          

