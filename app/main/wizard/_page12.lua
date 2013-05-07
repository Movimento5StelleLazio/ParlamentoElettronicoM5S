local area_id=param.get("area_id" )
local unit_id=param.get("unit_id" )
local area_name=param.get("area_name")
local unit_name=param.get("unit_name")

local page=param.get("page",atom.integer)
local wizard=param.get("wizard","table")

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
                              ui.container{ attr = { class  = "unit_header_box" , style="height:100%;" }, 
                              content = function()
                               ui.tag { tag = "p", attr = { class  = "welcome_text_xl",style="font-size: 38px;margin-bottom: 60px;margin-top: 20px;"}, content = _"WIZARD HEADER END" }
                                   
                                      ui.link { 
                                        attr = { id = "unit_button_back", class="button orange menuButton"  }, 
                                        module = "wizard",
                                        view = "_page11",
                                        content = function()
                                          ui.image{ attr = { id = "unit_arrow_back" }, static = "arrow_left.png" }
                                          ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"BACK TO PREVIOUS PAGE" }
                                        end
                                      }
                                     ui.tag { tag = "p", attr = { class  = "welcome_text_xl",style="font-size: 23px; float: left; position: relative; text-align: left; top: 3px; width: 32em;"}, content = _"WIZARD END" }
                                    end}
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
                                
                       
                         
            --------------------------------------------------------      
            --contenuto specifico della pagina wizard    
             ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page},
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
                    
                       
                    local policy_id={}
                    local question_title
                    local question_short_description
                    local question_keywords
                    local problem_description
                    local target_description
                    
                    
                    --parametri in uscita
                     for i,k in ipairs(wizard) do
                          ui.hidden_field{name=k.name ,value=k.value}
                          trace.debug("[wizard] name="..k.name.." | value="..tostring(k.value))
                          
                          if k.name=="policy_id" then
                          policy_id=k.value
                          end
                          
                            
                          if k.name=="question_title" then
                          question_title=k.value
                          end
                          
                          if k.name=="question_short_description" then
                          question_short_description=k.value
                          end
                          
                          if k.name=="question_keywords" then
                          question_keywords=k.value
                          end
                          
                          if k.name=="problem_description" then
                          problem_description=k.value
                          end
                          
                          if k.name=="target_description" then
                          target_description=k.value
                          end
                          
                        end
                     
                        
                        
                          ui.container
                                    {
                                      attr={class="formSelect",style="top: 15px;"},
                                      content=function() 
                                      
                                      
                                      local area_policies=AllowedPolicy:get_policy_by_area_id(area_id)

                                        local dataSource
                                        dataSource = { 
                                                       { id = 0, name = _"Please choose a policy" }
                                                }
                                        
                                        if #area_policies>0 then
                                                               
                                                 for i, allowed_policy in ipairs(area_policies) do
                                                    dataSource[#dataSource+1] = {id=i, name=allowed_policy.name  }
                                                 end   
                                                                  
                                         else
                                                                 
                                        end
                                                                              
                                      
                                      
                                      
                                        ui.field.select{
                                                attr = { id = "policyChooser", style="position: relative; left: 5ex; vertical-align: middle; text-align: left; height: 28px; width: 40%;" },
                                                label =  "REGOLA:",
                                                label_attr={style="float: left; font-size: 27px; position: relative; text-align: right; width: 48%; left: 3px;"},
                                                name = 'policyChooser',
                                                foreign_records = dataSource,
                                                foreign_id = "id",
                                                foreign_name = "name",
                                                selected_record=tonumber(policy_id)
                                              }
                                          
                                          
                                          
                                             
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
                                         
                                       
                                       
                                       
                                     ui.container
                                        {
                                                attr={id="wizard_page_"..page, style="background-color: lavender; height: 80em; position: relative; float: left; width: 100%; top: 50px;"},
                                                content=function()  
                                                
                                                         ui.tag{
                                                                tag="span",
                                                                attr={style="font-size: 26px; left: 17px; text-overflow: ellipsis; text-align: left; height: 27px; position: relative; overflow: hidden; margin: 0px; line-height: 27px; white-space: nowrap; float: left; width: 100%; top: 7px;"},
                                                                nultiline=false,
                                                                content="QUESTIONE"
                                                               }
                                                        
                                                         --contenuto
                                                         
                                                         --TITOLO
                                                           ui.tag{
                                                               tag="div",
                                                               attr={style="text-align: center; width: 100%; float: left; position: relative; top: 50px;"},
                                                               content=function()     
                                                                       ui.field.text
                                                                       {
                                                                            attr={id="question_title",style=" font-size: 25px;height: 30px;width: 60%;"},
                                                                            name="question_title",
                                                                            label=_"Problem Title",
                                                                            label_attr={style="font-size:20px"},
                                                                            value=question_title
                                                                       }
                                                                end
                                                            }
                                                            
                                                            
                                                           --DESCRIZIONE QUESTIONE
                                                            
                                                           ui.tag{
                                                                   tag="div",
                                                                   attr={style="text-align: center; width: 100%; float: left; top: 80px; position: relative;"},
                                                                   content=function()  
                                                                   
                                                                    ui.container
                                                                    {
                                                                        attr={style="width: 20%; float: left; position: relative; margin-left: 9.6em;"},
                                                                        content=function()
                                                                         ui.tag{
                                                                            tag="p",
                                                                            attr={style="text-align: right; float: right; font-size: 20px;"},
                                                                            content=  _"Description to the problem you want to solve"
                                                                          }   
                                                                        
                                                                         ui.tag{
                                                                            tag="p",
                                                                            attr={style="float: left; position: relative; text-align: right;  font-style: italic;font-size:12px;"},
                                                                            content=  _"Description note"
                                                                          }   
                                                                          
                                                                        end
                                                                        
                                                                     }   
                                                                        ui.tag
                                                                           {
                                                                                tag="textarea",
                                                                                attr={id="question_short_description",name="question_short_description",style="resize: none; float: left; font-size: 23px; height: 228px; margin-left: 8px; width: 60%;"},
                                                                               
                                                                                content=question_short_description
                                                                                
                                                                           }
                                                                    end
                                                                 }
                                                            
                                                            
                                                            
                                                            --KEYWORDS
                                                             ui.tag{
                                                                   tag="div",
                                                                   attr={style="text-align: center; position: relative; float: left; width: 100%; top: 110px;"},
                                                                   content=function()  
                                                                   
                                                                    ui.container
                                                                    {
                                                                        attr={style="width: 20%; position: relative; float: left; margin-left: 9.6em;"},
                                                                        content=function()
                                                                         ui.tag{
                                                                            tag="p",
                                                                            attr={style="text-align: right; float: right; font-size: 20px;"},
                                                                            content=  _"Keywords"
                                                                          }   
                                                                        
                                                                         ui.tag{
                                                                            tag="p",
                                                                            attr={style="float: left; position: relative; text-align: right;  font-style: italic;font-size:12px;"},
                                                                            content=  _"Keywords note"
                                                                          }   
                                                                          
                                                                        end
                                                                        
                                                                     }   
                                                                        ui.tag
                                                                           {
                                                                                tag="textarea",
                                                                                attr={id="question_keywords",name="question_keywords",style="resize: none; float: left; font-size: 23px; height: 228px; width: 60%; margin-left: 7px;"},
                                                                                content=question_keywords
                                                                                
                                                                           }
                                                                    end
                                                                }--fine keywords
                                                                                            
                                                            
                                                            --DESCRIZIONE PROBLEMA
                                                            
                                                             ui.tag{
                                                                   tag="div",
                                                                   attr={style="text-align: center; position: relative; float: left; width: 100%; top: 140px;"},
                                                                   content=function()  
                                                                   
                                                                    ui.container
                                                                    {
                                                                        attr={style="width: 20%; position: relative; float: left; margin-left: 9.6em;"},
                                                                        content=function()
                                                                         ui.tag{
                                                                            tag="p",
                                                                            attr={style="text-align: right; float: right; font-size: 20px;"},
                                                                            content=  _"Problem description"
                                                                          }   
                                                                        
                                                                         ui.tag{
                                                                            tag="p",
                                                                            attr={style="float: right; position: relative; text-align: right;  font-style: italic;font-size: 12px;width:300px"},
                                                                            content=  _"Problem note"
                                                                          }   
                                                                          
                                                                        end
                                                                        
                                                                     }   
                                                                        ui.tag
                                                                           {
                                                                                tag="textarea",
                                                                                attr={id="problem_description", name="problem_description",style="resize: none;float: left; font-size: 23px; height: 228px; margin-left: 7px; width: 60%;"},
                                                                                content=problem_description
                                                                                
                                                                           }
                                                                    end
                                                                }
                                                            
                                                           --DESCRIZIONE OBIETTIVO
                                                           
                                                           
                                                            --contenuto
                                                               ui.tag{
                                                                   tag="div",
                                                                   attr={style="text-align: center; position: relative; float: left; width: 100%; top: 180px;"},
                                                                   content=function()  
                                                                   
                                                                    ui.container
                                                                    {
                                                                        attr={style="width: 20%; position: relative; float: left; margin-left: 9.6em;"},
                                                                        content=function()
                                                                         ui.tag{
                                                                            tag="p",
                                                                            attr={style="text-align: right; float: right; font-size: 20px;"},
                                                                            content=  _"Target description"
                                                                          }   
                                                                        
                                                                         ui.tag{
                                                                            tag="p",
                                                                            attr={style="float: right; position: relative; text-align: right;  font-style: italic;"},
                                                                            content=  _"Target note"
                                                                          }   
                                                                          
                                                                        end
                                                                        
                                                                     }   
                                                                        ui.tag
                                                                           {
                                                                                tag="textarea",
                                                                                attr={id="target_description",name="target_description",style="resize: none;float: left; font-size: 23px; height: 228px; margin-left: 7px; width: 60%;"},
                                                                                content=target_description
                                                                                
                                                                           }
                                                                    end
                                                                }
                                                           
                                 
                                                            
                                                            
                                                            
                                                      
                                                
                                                
                                                end --fine wizard_page
                                        }
                                                       
                                                      
                                     
                                     
                                     end
                                     }--fine div formSelect
                                 
                                   
            
            
            
            
            
            
            
            
            
                       end --fine contenuto
                        
                   }--fine form
            --------------------------------------------------------
            
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






