local area=param.get("area","table")
local unit_id=param.get("unit_id")

 
if not area then
    area={}
end
 
 
 


local page=param.get("page",atom.integer)


local btnBackModule = "wizard"
local btnBackView = "wizard_new_initiative"

if not page  or page <= 1 then
    page=1
    btnBackModule ="index"
    btnBackView = "homepage"
end

local previus_page=page-1
local next_page=page+1


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
                        module = 'wizard',
                        action = 'wizard_new_save',
                        params={
                                area_id=1,
                                unit_id=unit_id,
                                page=page
                        },
                        routing = {
                            ok = {
                              mode   = 'redirect',
                              module = 'wizard',
                              view = 'wizard_new_initiative',
                              params = {
                                           page=page+1
                                          },
                            },
                            error = {
                              mode   = '',
                              module = 'wizard',
                              view = 'wizard_new_initiative',
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
                     
             
             --pulsanti
             
             --pulsanti
            execute.view{
                            module="wizard",
                            view="_pulsanti",
                            params={
                                     btnBackModule = "wizard",
                                     btnBackView = "wizard_new_initiative",
                                     page=page
                                    }
                         }
                          
             
         
     end
 }