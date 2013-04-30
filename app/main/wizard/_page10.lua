local area_id=param.get("area_id" )
local unit_id=param.get("unit_id" )

 
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
                                        content=  _"Insert Technical Areas"
                                      }
                                end
                         }
                         
                      local tmp
                      tmp = { 
                                { id = 0, name = _"Please choose a tecnical area" }
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
                        attr={id="wizardForm"..page,style="height:80%"},
                        module = 'wizard',
                        action = 'wizard_new_save',
                        params={
                                area_id=area_id,
                                unit_id=unit_id,
                                page=page
                        },
                        routing = {
                            ok = {
                              mode   = 'redirect',
                              module = 'wizard',
                              view = 'wizard_new_initiative',
                              params = {
                                           area_id=area_id,
                                           unit_id=unit_id,
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
                    
                       --contenuto
                       ui.container
                        {
                          attr={class="formSelect"},
                          content=function() 
                          
                           ui.container
                                 {
                                     attr={style="width: 100%; text-align: center;"},
                                     content=function() 
                                       ui.field.select{
                                            attr = { id = "technicalChooser", onchange="namePasteTemplateChange(event)", style="width:70%;height:30px;position:relative;"},
                                            label =  "1° AREA DI COMPETENZA TECNICA:",
                                            name = 'technicalChooser',
                                            foreign_records = tmp,
                                            foreign_id = "id",
                                            foreign_name = "name",
                                            value =  ""
                                          }
                                          
                                           ui.field.select{
                                            attr = { id = "technicalChooser2", onchange="namePasteTemplateChange(event)", style="width:70%;height:30px;position:relative;"},
                                            label =  "2° AREA DI COMPETENZA TECNICA:",
                                            name = 'technicalChooser',
                                            foreign_records = tmp,
                                            foreign_id = "id",
                                            foreign_name = "name",
                                            value =  ""
                                          }
                                          
                                               
                                           ui.field.select{
                                            attr = { id = "technicalChooser3", onchange="namePasteTemplateChange(event)", style="width:70%;height:30px;position:relative;"},
                                            label =  "3° AREA DI COMPETENZA TECNICA:",
                                            name = 'technicalChooser',
                                            foreign_records = tmp,
                                            foreign_id = "id",
                                            foreign_name = "name",
                                            value =  ""
                                          }
                                          
                                               
                                           ui.field.select{
                                            attr = { id = "technicalChooser4", onchange="namePasteTemplateChange(event)", style="width:70%;height:30px;position:relative;"},
                                            label =  "4° AREA DI COMPETENZA TECNICA:",
                                            name = 'technicalChooser',
                                            foreign_records = tmp,
                                            foreign_id = "id",
                                            foreign_name = "name",
                                            value =  ""
                                          }
                                          
                                      end
                                      
                                }
                             
                          ui.tag{
                                tag = "div",
                                attr={style="position:relative;top:10px"},
                                content = function()
                                 ui.tag{
                                    tag = "p",
                                    attr = { style="float: left; position: relative; margin: 0px 126px 4em 58px; text-align: right; width: 20%; font-style: italic;" },
                                    content=  _"Description note"
                                  }
                                  
                                  ui.tag{
                                    content = function()
                                      ui.link{
                                        text = _"Information about the available Technical Areas",
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
 