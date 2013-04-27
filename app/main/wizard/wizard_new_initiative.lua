local area=param.get("area","table")
local unit_id=param.get("unit_id")

 
if not area then
    area={}
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
                                            content="testUnit"
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
                                            content="testArea"
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
                                          page=page
                                         }
                             }
            
            end
            
            
            if page==3 then
            trace.debug("rendering view:"..page)
             execute.view{ 
                               module = "wizard", 
                               view = "_page2", 
                               params = {
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
                                          page=page
                                         }
                             }
            end
            
              
           
         end
         }
end --fine wizardContainer
}

          



