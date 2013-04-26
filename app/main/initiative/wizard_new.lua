local area=param.get("area" )
local unit=param.get("unit" )

local wizard_new_issue=param.get("wizard_new_issue","table")
if not wizard_new_issue then
         wizard_new_issue={}
end


local step=param.get("step",atom.integer)


local btnBackModule = "initiative"
local btnBackView = "wizard_new"

if not step  or step <= 1 then
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
                    attr={id="wizard_page_"..step, class="basicWizardPage"},
                    content=function()
                     ui.container
                        {
                                attr={id="wizardTitoloArea",class="titoloWizardHead", style="text-align: center; width: 100%;"},
                                content=function()
                                  ui.tag{
                                        tag="p",
                                        attr={},
                                        content=  "FASE "..step
                                      }
                                      
                                  ui.tag{
                                        tag="p",
                                        attr={style="font-size:28px;"},
                                        content=  _"How much time does your proposal need to be examined?"
                                      }
                                end
                         }
                         
                      local tmp
                      tmp = { 
                                { id = 0, name = _"Please choose a policy" }
                            }
                      
                      local _value=""
                      if area then
                          for i, allowed_policy in ipairs(area.allowed_policies) do
                            if not allowed_policy.polling then
                              tmp[#tmp+1] = allowed_policy
                            end
                          end   
                          
                        --  _value=param.get("policy_id", atom.integer) or area.default_policy and area.default_policy.id
                     
                      end
                    
                    ui.container
                    {
                          attr={class="formSelect"},
                          content=function() 
                          ui.tag
                          {     tag="select",
                                attr={id="policyChooser", style="width:70%;height:30px;left: 20ex;position:relative;"},
                                label ="",
                                name = "policyId",
                                content=function()
                                
                                    for v,k in ipairs(tmp) do
                                    
                                          ui.tag{
                                          tag     = "option",
                                          attr    = {
                                                        value    = k.name,
                                                       
                                                       
                                                     },
                                          content = format.string(k.name)
                                          }
                                    end
                                
                                end
                           }
                         
                         
                          ui.tag{
                                tag = "div",
                                attr={style="left: 50ex;position:relative;"},
                                content = function()
                                  ui.tag{
                                    tag = "label",
                                    attr = { class = "ui_field_label" },
                                    content = function() slot.put("&nbsp;") end,
                                  }
                                  ui.tag{
                                    content = function()
                                      ui.link{
                                        text = _"Information about the available policies",
                                        module = "policy",
                                        view = "list"
                                      }
                                      slot.put(" ")
                                      ui.link{
                                        attr = { target = "_blank" },
                                        text = _"(new window)",
                                        module = "policy",
                                        view = "list"
                                      }
                                    end
                                  }--fine tag
                                end
                              } --fine tag 
                         
                     end
                     }--fine div
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

 ui.field.hidden{ 
                 name = "wizard_new_issue", 
                 value = wizard_new_issue
                }        
                                     
ui.field.hidden{ 
                 name = "area", 
                 value = area
                }        
            



