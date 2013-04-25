local area=param.get("area" )
local unit=param.get("unit" )


local step=param.get("step",atom.integer)

if not step  or step==0 then
step=1
end

local previus_page=step-1
local next_page=step+1

ui.container
{
    attr={id="wizardContainer" , style="background-color: red; "},
    content=function()

        ui.container
        {
                attr={id="wizard_head",style="height:150px"},
                content=function()
                
                  ui.tag{
                        tag="span",
                        attr={class="titolo"},
                        content= _"Create new initiative"
                      }
               
                  ui.tag{
                        tag="span",
                        attr={class="titolo"},
                        content= _"Unit" 
                      }
                      
                  ui.tag{
                        tag="span",
                        attr={class="titolo"},
                        content= _"Area" 
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
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
                    attr={id="wizard_page_"..step},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
            
            if step==12 then
            trace.debug("rendering view:"..step)
            ui.container
            {
                    attr={id="wizard_page_"..step},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..step
                          }
                     end
                     
             }
            
            end
            
            
            
            
            --pulsanti
            
            ui.container
            {
                attr={id="pulsanti" , style="position: relative;top: 65%;width:90%;margin-left: auto;margin-right: auto;"},
                content=function()
               --pulsante Previuos
                     ui.link{
                                 attr={id="btnPreviuos",class="button orange menuButton",style="font-size: 13px;text-align: -moz-center;width: 130px;"},
                                 module = "initiative",
                                 view = "wizard_new",
                                 params = { 
                                                unit={name="LazionM5S"},
                                                area = {name="testAreaName"},
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
                             attr={id="btnNext",class="button orange menuButton", style="font-size: 13px;text-align: -moz-center;width: 130px;float:right;"},
                             module = "initiative",
                             view = "wizard_new",
                             params = { 
                                            unit={name="LazionM5S"},
                                            area = {name="testAreaName"},
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
                        } -- fine pulsante previuos
                    
                end
            
            }-- fine pulsanti

         end
         }
end --fine wizardContainer
}