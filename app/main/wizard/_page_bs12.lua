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


ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
  
                                     ui.container{ attr = { class  = "row-fluid" } , content = function()
                                      ui.container{ attr = { class  = "well span12" }, content = function()
                                        ui.container{ attr = { class  = "row-fluid" }, content = function()
                                          ui.container{ attr = { class  = "span3",style="width:100%" }, content = function()
                                           
                                            ui.heading{level=1,attr={class="fittext0"},
                                               content = _"WIZARD HEADER END" }
                                           
                                          
                                          end }
                                          ui.container{ attr = { class  = "span9 text-center" , style="width:96%"}, content = function()
                                            ui.container{ attr = { class  = "row-fluid" }, content = function()
                                              ui.container{ attr = { class  = "span12 text-center" }, content = function()
                                                
                                                
                                              
                                              end }
                                            end }
                                            ui.container{ attr = { class  = "row-fluid" }, content = function()
                                              ui.container{ attr = { class  = "span12 text-center"  }, content = function()
                                              
                                                ui.link{
                                                  attr = { class="btn btn-primary btn-large large_btn table-cell" ,style="width: 9em; float: left;"},
                                                  module = "wizard",
                                                  view = "wizard_new_initiative_bs",
                                                  params={
                                                    area_id=area_id,
                                                    unit_id=unit_id,
                                                    page=11
                                                     },
                                                  content = function()
                                                    ui.heading{level=3,attr={class="fittext_back_btn"},content=function()
                                                      ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
                                                      slot.put(_"Back to previous page")
                                                    end
                                                     }
                                                  end
                                                }--fine content
                                               
                                                ui.heading{level=3,attr={class="fittext0",style="width:25em;float:right"},content = _"WIZARD END"}
                                              end }
                                            end }
                                          end }
                                        end }
                                      end }
                                    end }                
                      
                  --unità ed area                    
                      ui.container{attr={class="row-fluid"},content=function()
                          ui.container{attr={class="span12 "},content=function()
                            ui.container{attr={class="row-fluid"},content=function()
                              ui.container{attr={class="span12 text-center"},content=function()
                               
                                ui.heading{level=4,content= _"Unit"..": "..unit_name }
                                ui.heading{level=4,content= _"Area"..": "..area_name }
                              end }
                            end }
                            
                          end }
                        end }                    
                                
  end }
end }

ui.container{attr={class="row-fluid",style="padding-top: 2em;"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()              
                         
            --------------------------------------------------------      
            --contenuto specifico della pagina wizard    
             ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page},
                        module = 'wizard',
                        action = 'create',
                        params={
                                area_id=area_id,
                                unit_id=unit_id,
                                page=page
                        },
                        routing = {
                            ok = {
                              mode   = 'forward',
                              module = 'index',
                              view = 'homepage_bs',
                              params = {
                                           area_id=area_id,
                                           area_name=area_name,
                                           unit_id=unit_id,
                                           unit_name=unit_name,
                                           page=page
                                          },
                            },
                          error = {
                              mode   = 'forward',
                              module = 'wizard',
                              view = 'wizard_new_initiative_bs',
                              params = {
                                           area_id=area_id,
                                           area_name=area_name,
                                           unit_id=unit_id,
                                           unit_name=unit_name,
                                            
                                           page=page
                                          },
                           
                            } 
                          }, 
                       content=function()
                    
                       
                        local policy_id={}
                        local issue_title
                        local issue_brief_description
                        local issue_keywords
                        local problem_description
                        local aim_description
                        local initiative_title
                        local initiative_brief_description
                        local draft
                        local technical_area_1
                        local technical_area_2
                        local technical_area_3
                        local technical_area_4
                        local proposer1=false
                        local proposer2=false
                        local proposer3=false
                    
                    
                    --parametri in uscita
                         ui.hidden_field{name="indietro" ,value=false}
                         for i,k in ipairs(wizard) do
                         
                          
                          ui.hidden_field{name=k.name.."_hidden" ,value=k.value}
                          trace.debug("[wizard] name="..k.name.." | value="..tostring(k.value))
                          
                          if k.name=="policy_id" then
                          policy_id=k.value
                          end
                          
                            
                          if k.name=="issue_title" then
                          issue_title=k.value
                          end
                          
                          if k.name=="issue_brief_description" then
                          issue_brief_description=k.value
                          end
                          
                          if k.name=="issue_keywords" then
                          issue_keywords=k.value
                          end
                          
                          if k.name=="problem_description" then
                          problem_description=k.value
                          end
                          
                          if k.name=="aim_description" then
                          aim_description=k.value
                          end
                          
                          
                          if k.name=="initiative_title" then
                          initiative_title=k.value
                          end
                          
                          if k.name=="initiative_brief_description" then
                          initiative_brief_description=k.value
                          end
                          
                          if k.name=="draft" then
                          draft=k.value
                          end
                          
                            
                          if k.name=="proposer1" then
                             proposer1=k.value
                          end
                          
                           if k.name=="proposer2" then
                             proposer2=k.value
                          end
                          
                           if k.name=="proposer3" then
                             proposer3=k.value
                          end
                          
                          if k.name=="technical_area_1" then
                             technical_area_1=k.value
                          end
                        
                        if k.name=="technical_area_2" then
                             technical_area_2=k.value
                             else
                             technical_area_2=0
                          end
                        
                        if k.name=="technical_area_2" then
                             technical_area_3=k.value
                             else
                             technical_area_3=0
                          end
                        
                        if k.name=="technical_area_2" then
                             technical_area_4=k.value
                             else
                             technical_area_4=0
                          end
                        
                        
                          
                        end --fine for
                     
                        
                        
                          ui.container
                                    {
                                      attr={class="formSelect",style="top: 15px;height:100%;width:100%;"},
                                      content=function() 
                                      local area_policies=AllowedPolicy:get_policy_by_area_id(area_id)
                                      local index
                                      local dataSource
                                      dataSource = { 
                                                       { id = 0, name = _"Please choose a policy" }
                                                }
                                      if #area_policies>0 then
                                                 for i, allowed_policy in ipairs(area_policies) do
                                                    dataSource[#dataSource+1] = {id=i, name=allowed_policy.name  }
                                                    trace.debug("allowed_policy.id="..allowed_policy.id.."| policy_id="..policy_id)
                                                    --
                                                     ui.hidden_field{name=allowed_policy.name ,value=i.."_"..allowed_policy.id}
                                                    
                                                    if tonumber(allowed_policy.id)==tonumber(policy_id) then
                                                      index=i
                                                      trace.debug("index="..index)
                                                    end
                                                    
                                                 end   
                                         else
                                      end --fine if
                                      
                                        ui.container
                                            {
                                              attr={class="formSelect",style="height:50px"},
                                              content=function()
                                              ui.field.select{
                                                        attr = { id = "policyChooser", style="width: 54%;height:38px;position:relative;text-align: left;float: left;margin-left: 40px;" },
                                                        label =  "REGOLA:",
                                                        label_attr={style="height: 30px; position: relative; text-align: right; float: left; font-size: 25px;  width: 34%;top: 6px;"},
                                                        name = 'policyChooser',
                                                        foreign_records = dataSource,
                                                        foreign_id = "id",
                                                        foreign_name = "name",
                                                        selected_record=tonumber(index)
                                                      }
                                                      
                                               end
                                               }       
                                        ui.tag{
                                                tag = "div",
                                                attr={style="font-size: 15px;float: right;margin-right: 21em;"},
                                                content = function()
                                                  
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
                                                attr={id="wizard_page_"..page, style="background-color: lavender; height: 65em; position: relative; float: left; width: 100%; top: 50px;"},
                                                content=function()  
                                                
                                                  ui.container
                                                    {
                                                            attr={id="wizard_page_"..page, style="background-color: yellow; text-align: center; vertical-align: middle; height: 60px; position: relative; left: 5.6em; float: left; width: 25%; top: 15px;"},
                                                            content=function()  
                                                             ui.tag{
                                                                    tag="span",
                                                                    attr={style="font-size: 26px; text-overflow: ellipsis; position: relative; overflow: hidden; margin: 0px; white-space: nowrap; float: left; width: 100%; top: 16px;"},
                                                                    nultiline=false,
                                                                    content="QUESTIONE"
                                                                   }
                                                      end
                                                     } --contenuto
                                                        
                                                   ui.container{attr={class="row-fluid",style="padding-top: 2em;"},content=function()
                                                        ui.container{attr={class="span12 text-center"},content=function()        
                                                                
                                                     --TITOLO
                                                      ui.tag{
                                                               tag="div",
                                                               attr={style="font-size:20px;width: 54em;float: left;margin-left: 10em;margin-top: 4em;"},
                                                               content=function()     
                                                                       ui.field.text
                                                                       {
                                                                            attr={id="issue_title",style="font-size: 25px;height: 30px; width: 70%; margin-left: .1em;float: left;"},
                                                                            name="issue_title",
                                                                            label=_"Problem Title",
                                                                            label_attr={style="font-size:20px;float: left;margin-top: 0.3em;"},
                                                                            value=issue_title
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
                                                                                attr={id="issue_short_description",name="issue_short_description",style="resize: none; float: left; font-size: 23px; height: 228px; margin-left: 8px; width: 60%;"},
                                                                                content=""..issue_brief_description
                                                                                
                                                                           }
                                                                 end
                                                                 } --fine  --DESCRIZIONE QUESTIONE
                                                            
                                                          end}
                                                          end}  
                                                            
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
                                                                                attr={id="issue_keywords",name="issue_keywords",style="resize: none; float: left; font-size: 23px; height: 228px; width: 60%; margin-left: 7px;"},
                                                                                content=issue_keywords
                                                                                
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
                                                                }  -- fine DESCRIZIONE PROBLEMA
                                                            
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
                                                                            attr={style="float: right; position: relative; text-align: right;  font-style: italic;font-size:12px"},
                                                                            content=  _"Target note"
                                                                          }   
                                                                          
                                                                        end
                                                                        
                                                                     }   
                                                                        ui.tag
                                                                           {
                                                                                tag="textarea",
                                                                                attr={id="aim_description",name="aim_description",style="resize: none;float: left; font-size: 23px; height: 228px; margin-left: 7px; width: 60%;"},
                                                                                content=aim_description
                                                                                
                                                                           }
                                                                    end
                                                                }
                                                           
                                                
                                                end --fine wizard_page
                                        }
                                                       
                                        
                                        
                         --parte2 del riepilogo               
                                        
                                           ui.container
                                            {
                                                    attr={id="wizard_part_2", style="background-color: lavender; height: 130em; position: relative; float: left; width: 100%; top: 150px;"},
                                                    content=function()  
                                                    
                                                          ui.container
                                                            {
                                                                    attr={id="wizard_page_"..page, style="background-color: lightblue; text-align: center; vertical-align: middle; height: 60px; position: relative; left: 5.6em; float: left; width: 25%; top: 15px;"},
                                                                    content=function()  
                                                             ui.tag{
                                                                    tag="span",
                                                                   attr={style="font-size: 26px; text-overflow: ellipsis; position: relative; overflow: hidden; margin: 0px; white-space: nowrap; float: left; width: 100%; top: 16px;"},
                                                                    nultiline=false,
                                                                    content="PROPOSTA"
                                                                   }
                                                                   
                                                                   end
                                                            }
                                        
                                                      --fine contenuto
                                        
                                                      --TITOLO ISSUE
                                                      
                                                       ui.container{attr={class="row-fluid",style="padding-top: 2em;"},content=function()
                                                        ui.container{attr={class="span12 text-center"},content=function()          
                                                       
                                                      ui.tag{
                                                               tag="div",
                                                               attr={style="font-size:20px;width: 54em;float: left;margin-left: 10em;margin-top: 4em;"},
                                                               content=function()     
                                                                       ui.field.text
                                                                       {
                                                                            attr={id="initiative_title",style="font-size: 25px;height: 30px; width: 70%; margin-left: .1em;float: left;"},
                                                                            name="initiative_title",
                                                                            label=_"Initiative Title",
                                                                            label_attr={style="font-size:20px;float: left;margin-top: 0.3em;"},
                                                                            value=issue_title
                                                                       }
                                                                end
                                                            }
                                                       
                                                      
                                                      end}
                                                      end}
                                                       
                                                            
                                                            
                                                            --DESCRIZIONE ISSUE
                                                            ui.tag{
                                                               tag="div",
                                                               attr={style="text-align: center; width: 100%; float: left; position: relative; top: 100px;"},
                                                               content=function()  
                                                               
                                                                ui.container
                                                                {
                                                                    attr={style="width: 20%; position: relative; float: left; margin-left: 9.6em;"},
                                                                    content=function()
                                                                     ui.tag{
                                                                        tag="p",
                                                                        attr={style="text-align: right; float: right; font-size: 20px;"},
                                                                        content=  _"Initiative short description"
                                                                      }   
                                                                    
                                                                     ui.tag{
                                                                        tag="p",
                                                                        attr={style="float: right; position: relative; text-align: right;  font-style: italic;font-size:12px"},
                                                                        content=  _"Initiative short note"
                                                                      }   
                                                                      
                                                                    end
                                                                    
                                                                 } 
                                                                   
                                                                 ui.tag
                                                                       {
                                                                            tag="textarea",
                                                                            attr={id="initiative_brief_description", name="initiative_brief_description",style="resize: none; float: left; font-size: 23px; margin-left: 7px; width: 60%; height: 12em;"},
                                                                            content=initiative_brief_description
                                                                            
                                                                       }
                                                                       
                                                                       
                                                                end
                                                            }
                                                                                        
                                                            
                                                           --TESTO PROPOSTA
                                                             ui.tag{
                                                                   tag="div",
                                                                   attr={style="text-align: center; width: 100%; float: left; position: relative; top: 150px;"},
                                                                   content=function()  
                                                                   
                                                                    ui.container
                                                                    {
                                                                        attr={style="width: 20%; position: relative; float: left; margin-left: 9.6em;"},
                                                                        content=function()
                                                                         ui.tag{
                                                                            tag="p",
                                                                            attr={style="text-align: right; float: right; font-size: 20px;"},
                                                                            content=  _"Draft text"
                                                                          }   
                                                                        
                                                                         ui.tag{
                                                                            tag="p",
                                                                            attr={style="float: left; font-size: 12px; text-align: right; width: 249px;font-style: italic;"},
                                                                            content=  _"Draft note"
                                                                          }   
                                                                          
                                                                        end
                                                                        
                                                                     }   
                                                                        ui.tag
                                                                           {
                                                                                tag="textarea",
                                                                                attr={id="draft",name="draft",style="resize: none;float: left; font-size: 23px;height: 28em; margin-left: 7px; width: 60%;"},
                                                                                content=draft
                                                                                
                                                                           }
                                                                    end
                                                                }
                                                                                           
                                                          
                                                              
                                                             
                                                       ui.container{attr={class="row-fluid",style="padding-top: 2em;"},content=function()
                                                        ui.container{attr={class="span12 text-center",style="margin-top: 12em; margin-left: 1em; "},content=function()
                                                        
                                                                          local area={}
                      
                                                                          --valori di test
                                                                          local tmp
                                                                          tmp = { 
                                                                                    { id = 0, name = _"Please choose a tecnical area" },
                                                                                    { id = 1, name = "Ingegneria Edile" },
                                                                                    { id = 2, name = "Ingegneria Informatica" }
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
                                                                             --contenuto
                                                                           
                                                                           --1* selezione
                                                                           ui.container
                                                                            {
                                                                              attr={class="formSelect"},
                                                                              content=function() 
                                                                              
                                                                               ui.container
                                                                                     {
                                                                                         attr={style="width: 100%; text-align: center;"},
                                                                                         content=function() 
                                                                                           ui.field.select{
                                                                                                attr = { id = "technicalChooser", onchange="namePasteTemplateChange(event)", style="width:62%;height:38px;position:relative;"},
                                                                                                label =  "1° AREA DI COMPETENZA TECNICA:",
                                                                                                label_attr={style="float:left;margin-left:1em;margin-top:0.2em"},
                                                                                                name = 'technical_area_1',
                                                                                                foreign_records = tmp,
                                                                                                foreign_id = "id",
                                                                                                foreign_name = "name",
                                                                                                value =  "",
                                                                                                selected_record=tonumber(technical_area_1)
                                                                                              }
                                                                                        
                                                                                          end
                                                                                          
                                                                                    }
                                                                              
                                                                              --nota   
                                                                              ui.tag{
                                                                                    tag = "div",
                                                                                    attr={style="position:relative;top: -0.5em;font-size:14px;margin-left: 33em;"},
                                                                                    content = function()
                                                                                    
                                                                                      
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
                                                                         
                                                                         
                                                                         
                                                                       --2* selezione
                                                                           ui.container
                                                                            {
                                                                              attr={class="formSelect", style="height: 5em;margin-top: 2em;"},
                                                                              content=function() 
                                                                              
                                                                               ui.container
                                                                                     {
                                                                                         attr={style="width: 100%; text-align: center;"},
                                                                                         content=function() 
                                                                                         
                                                                                           --checkbox
                                                                                           execute.view
                                                                                              {
                                                                                                  module="wizard",
                                                                                                  view="_checkbox_bs_pag10",
                                                                                                  params={
                                                                                                       id_checkbox="2",
                                                                                                       label=""
                                                                                                  }
                                                                                              }
                                                                                           
                                                                                            ui.tag{
                                                                                                      tag="div",
                                                                                                      attr={id="div2",style="opacity:0.5;margin-left: 5em;",disabled="true"},
                                                                                                      content=function()
                                                                                           
                                                                                           --select
                                                                                           ui.field.select{
                                                                                                attr = { id = "technicalChooser2", onchange="namePasteTemplateChange(event)",disabled="true", style="width: 33.4em;height:38px;position:relative;margin-top: 1.2em;"},
                                                                                                label =  "2° AREA DI COMPETENZA (opzionale):",
                                                                                                label_attr={style="float:left;margin-left:1em;margin-top:2.2em;font-size: 16px;"},
                                                                                                name = 'technical_area_2',
                                                                                                foreign_records = tmp,
                                                                                                foreign_id = "id",
                                                                                                foreign_name = "name",
                                                                                                value =  ""
                                                                                              }
                                                                                              
                                                                                              end}
                                                                                        
                                                                                          end
                                                                                          
                                                                                    }
                                                                              
                                                                               
                                                                              --nota   
                                                                              ui.tag{
                                                                                    tag = "div",
                                                                                    attr={id="divNota2",style="position:relative;top:-0.5em;font-size:14px;margin-left: 33em;"},
                                                                                    content = function()
                                                                                    
                                                                                      
                                                                                      ui.tag{
                                                                                      attr={id="nota2",style="opacity:0.5",disable="true"},
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
                                                                         
                                                                       --fine 2* selezione  
                                                                     
                                                                     
                                                                       --3* selezione
                                                                           ui.container
                                                                            {
                                                                              attr={class="formSelect", style="height: 5em;margin-top: 2em;"},
                                                                              content=function() 
                                                                              
                                                                               ui.container
                                                                                     {
                                                                                         attr={style="width: 100%; text-align: center;"},
                                                                                         content=function() 
                                                                                         
                                                                                         
                                                                                           --checkbox
                                                                                           execute.view
                                                                                              {
                                                                                                  module="wizard",
                                                                                                  view="_checkbox_bs_pag10",
                                                                                                  params={
                                                                                                       id_checkbox="3",
                                                                                                       label=""
                                                                                                  }
                                                                                              }
                                                                                         
                                                                                         
                                                                                          ui.tag{
                                                                                                      tag="div",
                                                                                                      attr={id="div3",style="opacity:0.5;margin-left: 5em;",disabled="true"},
                                                                                                      content=function()
                                                                                         
                                                                                           ui.field.select{
                                                                                                attr = { id = "technicalChooser3", onchange="namePasteTemplateChange(event)",disabled="true", style="width: 33.4em;height:38px;position:relative;margin-top: 1.2em;"},
                                                                                                label =  "3° AREA DI COMPETENZA (opzionale):",
                                                                                                label_attr={style="float:left;margin-left:1em;margin-top:2.2em;font-size: 16px;"},
                                                                                                name = 'technical_area_3',
                                                                                                foreign_records = tmp,
                                                                                                foreign_id = "id",
                                                                                                foreign_name = "name",
                                                                                                value =  ""
                                                                                              }
                                                                                              
                                                                                              end}
                                                                                        
                                                                                          end
                                                                                          
                                                                                    }
                                                                              
                                                                               
                                                                              --nota   
                                                                              ui.tag{
                                                                                    tag = "div",
                                                                                    attr={id="divNota3",style="position:relative;top:-0.5em;font-size:14px;margin-left: 33em;",disable="true"},
                                                                                    content = function()
                                                                                    
                                                                                      
                                                                                      ui.tag{
                                                                                      attr={id="nota3",style="opacity:0.5",disable="true"},
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
                                                                         
                                                                       --fine 3* selezione  
                                                                     
                                                                     
                                                                     
                                                                       --4* selezione
                                                                           ui.container
                                                                            {
                                                                              attr={class="formSelect", style="height: 5em;margin-top: 2em;"},
                                                                              content=function() 
                                                                              
                                                                               ui.container
                                                                                     {
                                                                                         attr={style="width: 100%; text-align: center;"},
                                                                                         content=function() 
                                                                                         
                                                                                         
                                                                                           --checkbox
                                                                                           execute.view
                                                                                              {
                                                                                                  module="wizard",
                                                                                                  view="_checkbox_bs_pag10",
                                                                                                  params={
                                                                                                       id_checkbox="4",
                                                                                                       label=""
                                                                                                  }
                                                                                              }
                                                                                         
                                                                                         
                                                                                                 ui.tag{
                                                                                                      tag="div",
                                                                                                      attr={id="div4",style="opacity:0.5;margin-left: 5em;",disabled="true"},
                                                                                                      content=function()
                                                                                                       ui.field.select{
                                                                                                            attr = { id = "technicalChooser4", onchange="namePasteTemplateChange(event)",disabled="true", style="width: 33.4em;height:38px;position:relative;margin-top: 1.2em;"},
                                                                                                            label =  "4° AREA DI COMPETENZA (opzionale):",
                                                                                                            label_attr={style="float:left;margin-left:1em;margin-top:2.2em;font-size: 16px;"},
                                                                                                            name = 'technical_area_4',
                                                                                                            foreign_records = tmp,
                                                                                                            foreign_id = "id",
                                                                                                            foreign_name = "name",
                                                                                                            value =  ""
                                                                                                          }
                                                                                                      end
                                                                                                 }   
                                                                                          end
                                                                                          
                                                                                    }
                                                                              
                                                                               
                                                                              --nota   
                                                                              ui.tag{
                                                                                    tag = "div",
                                                                                    attr={id="divNota4",style="position:relative;top:-0.5em;font-size:14px;margin-left: 33em;",disable="true"},
                                                                                    content = function()
                                                                                    
                                                                                      
                                                                                      ui.tag{
                                                                                      attr={id="nota4",style="opacity:0.5",disable="true"},
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
                                                                         
                                                                       --fine 4* selezione  
                                                                       ui.script{static = "js/wizard_checkbox.js"} 
                                                                     
                                                                       ui.tag{
                                                                                        tag = "p",
                                                                                        attr = { style="float: left; text-align: right; width: 25%; font-style: italic;height: 200px;font-size: 12px;padding-left: 9em;" },
                                                                                        content=  _"Description technical note"
                                                                               }
                                                                            
                                                                    
                                                                         
                                                         
                                                      end }
                                                    end }       --fine selezione aree tecniche    
                                                       
                                                       
                                                        --PROPOSER    
                                                            
                                                            
                                                            ui.tag{
                                                                   tag="div",
                                                                   attr={style="text-align: center; width: 100%; float: left; position: relative;height: 16em;"},
                                                                   content=function()  
                                                                   
                                                                    ui.container
                                                                    {
                                                                        attr={style="width: 20%; position: relative; float: left; margin-left: 9.6em;"},
                                                                        content=function()
                                                                         ui.tag{
                                                                            tag="p",
                                                                            attr={style="text-align: right; float: right; font-size: 20px;"},
                                                                            content=   _"The proposals was presented by:"
                                                                          }   
                                                                        end
                                                                   }
                                                               
                                                                ui.container
                                                                    {
                                                                        attr={style="float: left; position: relative; border: 1px solid black; height: 19em; margin-left: 0.6em; text-align: left; width: 60%;"},
                                                                        content=function()
                                                                        
                                                                        
                                                                         ui.container
                                                                            {
                                                                               attr={style="position: relative; text-align: left; line-height: 56px; margin-left: 60px;margin-top: 2em;"},
                                                                               content=function()
                                                                               
                                                                          --1 proposer
                                                                          trace.debug("proposer_hidden_1="..tostring(proposer1))
                                                                          execute.view
                                                                          {
                                                                              module="wizard",
                                                                              view="_checkbox_bs",
                                                                              params={
                                                                                   id_checkbox="1",
                                                                                   label=_"Citiziens",
                                                                                   selected=tostring(proposer1)
                                                                              }
                                                                          }
                                                                          
                                                                          --2 proposer
                                                                              trace.debug("proposer_hidden_2="..tostring(proposer2))
                                                                          execute.view
                                                                          {
                                                                              module="wizard",
                                                                              view="_checkbox_bs",
                                                                              params={
                                                                                   id_checkbox="2",
                                                                                   label=_"Elected M5S",
                                                                                   selected=tostring(proposer2)
                                                                              }
                                                                          }
                                                                          
                                                                          
                                                                          --3 proposer
                                                                              trace.debug("proposer_hidden_3="..tostring(proposer3))
                                                                          execute.view
                                                                          {
                                                                              module="wizard",
                                                                              view="_checkbox_bs",
                                                                              params={
                                                                                   id_checkbox="3",
                                                                                   label=_"Other groups",
                                                                                   selected=tostring(proposer3)
                                                                              }
                                                                          }
                                                                               end
                                                                              }
                                                                       end
                                                                    }
                                                                    
                                                                    
                                                               ui.field.hidden{
                                                                               name="formatting_engine",
                                                                               value="rocketwiki"
                                                                               }
                                                                    
                                                             
                                                             end
                                                             }--fine div formSelect
                                                      
                                                             
                                                            
                                             
                                                    end --fine contenuto wizard_part_2
                                            }
                                        
                                                      
                                     
                                     
                                     end
                                     }--fine div formSelect
                                 
                                   
                             --pulsanti
                                ui.container{attr={class="row-fluid"},content=function()
                                  ui.container{attr={class="span12 text-center"},content=function()
                                    execute.view{
                                      module="wizard",
                                      view="_pulsanti_last_page_bs",
                                      params={
                                        btnBackModule = "wizard",
                                        btnBackView = "wizard_new_initiative_bs",
                                        page=page
                                      }
                                    }
                                  end }
                                end }
                                
                                ui.script{static = "js/wizard_checkbox.js"} 
                                ui.script{static = "js/send_initiative.js"}                                
                
                                   
                                    
                       end --fine contenuto
                        
                   }--fine form
            --------------------------------------------------------
            
    end }
end }

                           
 

