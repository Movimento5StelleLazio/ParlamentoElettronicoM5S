local area=param.get("area" )
local unit=param.get("unit" )


local step=param.get("step",atom.integer)


local btnBackModule = "initiative"
local btnBackView = "wizard_new"

if not step  or step==0 then
    step=1
    btnBackModule ="index"
    btnBackView = "homepage"
end

local previus_page=step-1
local next_page=step+1




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

trace.debug("step="..step)

ui.container
{
    attr={id="mainContainerWizard" , class="mainContainerWizard"},
    content=function()
    
    -- step 1
            if step==1 then
            trace.debug("rendering view:"..step)
            ui.container
            {
                    attr={id="wizard_page_"..step, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                            tag="span",
                            attr={class="titolo"},
                            content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
            
            -- step 2
            
            if step==2 then
            
            trace.debug("rendering view:"..step)
            ui.container
            {
                     attr={id="wizard_page_"..step, style="height:450px"},
                    content=function()
                    
                    ui.tag{
                            tag="span",
                            attr={class="titolo"},
                            content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
            
            if step==3 then
            trace.debug("rendering view:"..step)
            ui.container
            {
                      attr={id="wizard_page_"..step, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
            
            if step==4 then
            trace.debug("rendering view:"..step)
            ui.container
            {
                     attr={id="wizard_page_"..step, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
            
            if step==5 then
            trace.debug("rendering view:"..step)
            ui.container
            {
                      attr={id="wizard_page_"..step, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
           
      
            
            if step==6 then
            trace.debug("rendering view:"..step)
            ui.container
            {
                     attr={id="wizard_page_"..step, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
           
            
            if step==7 then
            trace.debug("rendering view:"..step)
            ui.container
            {
                      attr={id="wizard_page_"..step, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
            
            if step==8 then
            trace.debug("rendering view:"..step)
            ui.container
            {
                     attr={id="wizard_page_"..step, style="height:450px"},
                    content=function()
                    
                     ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
            if step==9 then
            trace.debug("rendering view:"..step)
            ui.container
            {
                      attr={id="wizard_page_"..step, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
            if step==10 then
            trace.debug("rendering view:"..step)
            ui.container
            {
                     attr={id="wizard_page_"..step, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
            if step==11 then
            trace.debug("rendering view:"..step)
            ui.container
            {
                     attr={id="wizard_page_"..step, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titoloWizard"},
                             content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
            
            if step==12 then
            trace.debug("rendering view:"..step)
            ui.container
            {
                     attr={id="wizard_page_"..step, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
            
            
               ui.field.hidden{ 
                                name = "unit", 
                                value = unit
                               }        
                                     
                ui.field.hidden{ 
                                 name = "area", 
                                 value = area
                                }        
            
            
            
            --pulsanti
            
            ui.tag
            {
            tag="div",
                attr={id="pulsanti" , style="position: relative;top: -140px;width:90%;margin-left: auto;margin-right: auto;"},
                content=function()
               --pulsante Previuos
                     ui.link{
                                 attr={id="btnPreviuos",class="button orange menuButton pulsantiWizard",style="float:left"},
                                 module = btnBackModule,
                                 view = btnBackView,
                                 params = { 
                                                --unit={name="LazionM5S"},
                                                --area = {name="testAreaName"},
                                                step=previus_page 
                                           },
                                 content=function()
                                    
                                        ui.tag{
                                           tag = "p",
                                           attr={style="text-align: center; width:80px", readonly="true"},
                                           content        =_"Back Phase".."\n <<",  
                                           multiline=true
                                          
                                        }  
                                        
                                    end-- fine tag.content
                            } -- fine pulsante previuos
                            
                   ui.container{
                                 attr={id="spazioDiv", class="spazioDiv"},
                                 content=function()
                                 end
                                }        
                 
                   --pulsante Next
                  ui.link{
                             attr={id="btnNext",class="button orange menuButton pulsantiWizard",style="float:right"},
                             module = "initiative",
                             view = "wizard_new",
                             params = { 
                                            --unit={name="LazionM5S"},
                                            --area = {name="testAreaName"},
                                            step=next_page 
                                       },
                             content=function()
                                
                                    ui.tag{
                                       tag = "p",
                                       attr={style="text-align: center; width:80px", readonly="true"},
                                       content        =_"Next Phase".."    >>",  
                                       multiline=true
                                      
                                    }  
                                    
                                end-- fine tag.content
                        } -- fine pulsante next
                    
                end
            
            }-- fine pulsanti container

         end
         }
end --fine wizardContainer
}