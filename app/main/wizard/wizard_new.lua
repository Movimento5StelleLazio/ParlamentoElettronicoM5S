local area=param.get("area","table")
local unit_id=param.get("unit_id")

 
if not area then
    area={}
end
 
 

local wizard_new_issue=param.get("wizard_new_issue")
if not wizard_new_issue then
         wizard_new_issue={}
end


local page=param.get("page",atom.integer)


local btnBackModule = "initiative"
local btnBackView = "wizard_new"

if not page  or page <= 1 then
    page=1
    btnBackModule ="index"
    btnBackView = "homepage"
end

local previus_page=page-1
local next_page=page+1




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
           
            ui.container
            {
                    attr={id="wizard_page_"..page, class="basicWizardPage"},
                    content=function()
                    ui.container
                        {
                                attr={id="wizardTitoloArea",class="titoloWizardHead", style="text-align: center; width: 100%;"},
                                content=function()
                                  ui.tag{
                                        tag="p",
                                        attr={},
                                        content=  "FASE "..page
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
                      if #area>0 then
                       
                          for i, allowed_policy in ipairs(area.allowed_policies) do
                            if not allowed_policy.polling then
                              tmp[#tmp+1] = allowed_policy
                            end
                          end   
                          
                        --  _value=param.get("policy_id", atom.integer) or area.default_policy and area.default_policy.id
                        else
                         
                      end
                   
                    ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page},
                        module = 'initiative',
                        action = 'wizard_new_save',
                        params={
                                area_id=1,
                                unit_id=unit_id,
                                page=page
                        },
                        routing = {
                            ok = {
                              mode   = 'redirect',
                              module = 'initiative',
                              view   = 'wizard_new',
                               params = {
                                           page=page+1
                                          },
                            },
                            error = {
                              mode   = '',
                               module = 'initiative',
                              view   = 'wizard_new',
                            }
                          }, 
                       content=function()
                    
                        ui.container
                        {
                          attr={class="formSelect"},
                          content=function() 
                          
                           ui.field.select{
                                attr = { id = "policyChooser", onchange="namePasteTemplateChange(event)", style="width:70%;height:30px;left: 20ex;position:relative;"},
                                label =  "",
                                name = 'policyChooser',
                                foreign_records = tmp,
                                foreign_id = "id",
                                foreign_name = "name",
                                value =  ""
                              }
                          
                          
                         
                        
                             --slot.put('<input type="hidden"  name="area" value="'..area..'">')         
                                
                         
                             
                          ui.tag{
                                tag = "div",
                                attr={style="position:relative;"},
                                content = function()
                                  ui.tag{
                                    tag = "label",
                                    attr = { class = "ui_field_label",style="margin-left:28em;" },
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
                         }--fine div formSelect
                     
                        
                        
                     end
                     
                     }--fine form
                     
                        
       
                   end
             }
            
            end --fine page1
            
            
            -- page 2
            
            if page==2 then
            
            trace.debug("rendering view:"..page)
            ui.container
            {
                     attr={id="wizard_page_"..page, style="height:450px"},
                    content=function()
                    
                    ui.tag{
                            tag="span",
                            attr={class="titolo"},
                            content=  "test page_"..page
                          }
                     end
                     
             }
            
            end
            
            
            if page==3 then
            trace.debug("rendering view:"..page)
            ui.container
            {
                      attr={id="wizard_page_"..page, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..page
                          }
                     end
                     
             }
            
            end
            
            
            if page==4 then
            trace.debug("rendering view:"..page)
            ui.container
            {
                     attr={id="wizard_page_"..page, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..page
                          }
                     end
                     
             }
            
            end
            
            
            if page==5 then
            trace.debug("rendering view:"..page)
            ui.container
            {
                      attr={id="wizard_page_"..page, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..page
                          }
                     end
                     
             }
            
            end
            
           
      
            
            if page==6 then
            trace.debug("rendering view:"..page)
            ui.container
            {
                     attr={id="wizard_page_"..page, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..page
                          }
                     end
                     
             }
            
            end
            
           
            
            if page==7 then
            trace.debug("rendering view:"..page)
            ui.container
            {
                      attr={id="wizard_page_"..page, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..page
                          }
                     end
                     
             }
            
            end
            
            
            if page==8 then
            trace.debug("rendering view:"..page)
            ui.container
            {
                     attr={id="wizard_page_"..page, style="height:450px"},
                    content=function()
                    
                     ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..page
                          }
                     end
                     
             }
            
            end
            
            if page==9 then
            trace.debug("rendering view:"..page)
            ui.container
            {
                      attr={id="wizard_page_"..page, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..page
                          }
                     end
                     
             }
            
            end
            
            if page==10 then
            trace.debug("rendering view:"..page)
            ui.container
            {
                     attr={id="wizard_page_"..page, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..page
                          }
                     end
                     
             }
            
            end
            
            if page==11 then
            trace.debug("rendering view:"..page)
            ui.container
            {
                     attr={id="wizard_page_"..page, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titoloWizard"},
                             content=  "test page_"..page
                          }
                     end
                     
             }
            
            end
            
            
            if page==12 then
            trace.debug("rendering view:"..page)
            ui.container
            {
                     attr={id="wizard_page_"..page, style="height:450px"},
                    content=function()
                    
                      ui.tag{
                             tag="span",
                             attr={class="titolo"},
                             content=  "test page_"..page
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
                                                page=previus_page 
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
                  ui.tag{
                             tag="button",
                             attr={id="btnNext",class="button orange menuButton pulsantiWizard",style="float:right",onclick="document.getElementById('wizardForm"..page.."').submit();"},
                             
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

          



