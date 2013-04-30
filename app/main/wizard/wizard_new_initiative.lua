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
                                attr={id="wizardTitoloArea",class="titoloWizardHead", style="height:30px"},
                                content=function()
                                      ui.tag{
                                            tag="p",
                                            attr={ class="wizardHeader" ,style="top: -2ex;"},
                                            content= _"Area"..":"
                                            
                                          }
                                       ui.tag{
                                            tag="p",
                                             attr={style="float: left;left: 1ex;position: relative;top: -2ex;"},
                                            content=area_name
                                           }
                                end
                         }                       
                                
                       
                        
                end
        
        }

trace.debug("page="..page)

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
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                         }
                             }
            end
            
            
            if page==12 then
            trace.debug("rendering view:"..page)
          
            execute.view{ 
                               module = "wizard", 
                               view = "_page12", 
                               params = {
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                         }
                             }
            end
            
              
           
         end
         }
end --fine wizardContainer
}

          



