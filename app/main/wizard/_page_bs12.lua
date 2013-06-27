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
                              mode   = 'redirect',
                              module = 'index',
                              view = 'homepage_bs',
                              params = {
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page+1
                                          },
                            },
                            error = {
                              mode   = '',
                              module = 'wizard',
                              view = 'wizard_new_initiative_bs',
                              params = {
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=12
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
                        local proposer1=false
                        local proposer2=false
                        local proposer3=false
                    
                    
                    --parametri in uscita
                         ui.hidden_field{name="indietro" ,value=false}
                         for i,k in ipairs(wizard) do
                          ui.hidden_field{name=k.name ,value=k.value}
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
                                                attr={style="position:relative;"},
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
                                                               attr={style="font-size:20px;width: 26%;float: left;margin-left: 8em;margin-top:7px"},
                                                               content=function()     
                                                                       ui.field.text
                                                                       {
                                                                            attr={id="issue_title",style="font-size: 25px;height: 30px; width: 60%; margin-left: -1.5em;"},
                                                                            name="issue_title",
                                                                            label=_"Problem Title",
                                                                            label_attr={style="font-size:20px"},
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
                                                                                attr={id="question_short_description",name="question_short_description",style="resize: none; float: left; font-size: 23px; height: 228px; margin-left: 8px; width: 60%;"},
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
                                                                                attr={id="question_keywords",name="question_keywords",style="resize: none; float: left; font-size: 23px; height: 228px; width: 60%; margin-left: 7px;"},
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
                                                           ui.tag{
                                                               tag="div",
                                                               attr={style="left:5px;text-align: center; width: 100%; float: left; position: relative; top: 50px;"},
                                                               content=function()     
                                                                       ui.field.text
                                                                       {
                                                                            attr={id="issue_title",style=" font-size: 25px;height: 30px;width: 60%;"},
                                                                            name="issue_title",
                                                                            label=_"Issue Title",
                                                                            label_attr={style="font-size:20px"},
                                                                            value=initiative_title
                                                                       }
                                                                end
                                                            }
                                                            
                                                            
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
                                                                        attr={style="float: right; position: relative; text-align: right;  font-style: italic;"},
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
                                                                            attr={style="float: left; font-size: 12px; text-align: right; width: 249px; margin-left: -33px;font-style: italic;"},
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
                                                                                           
                                                            
                                                           local tmp
                                                              tmp = { 
                                                                        { id = 0, name = "<".._"Please choose a tecnical area"..">" }
                                                                    }
                                                              
                                                             
                                                            --AREA DI COMPETENZA
                                                            
                                                              ui.container
                                                             {
                                                                 attr={style="width: 100%; float: left; position: relative; text-align: left; top: 230px;"},
                                                                 content=function() 
                                                                   ui.field.select{
                                                                        attr = { id = "technicalChooser", onchange="namePasteTemplateChange(event)", style="top: -4px;position: relative; text-align: left; float: left; width: 60%; left: 47px;"},
                                                                        label =  "1° AREA DI COMPETENZA TECNICA:",
                                                                        label_attr={style="height: 30px; position: relative; text-align: left; float: left; font-size: 16px; left: 60px; width: 28%;"},
                                                                        name = 'technical_area_1',
                                                                        foreign_records = tmp,
                                                                        foreign_id = "id",
                                                                        foreign_name = "name",
                                                                        value =  ""
                                                                      }
                                                                      
                            --                                           ui.field.select{
                            --                                            attr = { id = "technicalChooser2", onchange="namePasteTemplateChange(event)", style="width:70%;height:30px;position:relative;"},
                            --                                            label =  "2° AREA DI COMPETENZA TECNICA:",
                            --                                            name = 'technical_area_2',
                            --                                            foreign_records = tmp,
                            --                                            foreign_id = "id",
                            --                                            foreign_name = "name",
                            --                                            value =  ""
                            --                                          }
                            --                                          
                            --                                               
                            --                                           ui.field.select{
                            --                                            attr = { id = "technicalChooser3", onchange="namePasteTemplateChange(event)", style="width:70%;height:30px;position:relative;"},
                            --                                            label =  "3° AREA DI COMPETENZA TECNICA:",
                            --                                            name = 'technical_area_3',
                            --                                            foreign_records = tmp,
                            --                                            foreign_id = "id",
                            --                                            foreign_name = "name",
                            --                                            value =  ""
                            --                                          }
                            --                                          
                            --                                               
                            --                                           ui.field.select{
                            --                                            attr = { id = "technicalChooser4", onchange="namePasteTemplateChange(event)", style="width:70%;height:30px;position:relative;"},
                            --                                            label =  "4° AREA DI COMPETENZA TECNICA:",
                            --                                            name = 'technical_area_4',
                            --                                            foreign_records = tmp,
                            --                                            foreign_id = "id",
                            --                                            foreign_name = "name",
                            --                                            value =  ""
                            --                                          }
                                                                      
                                                                  end
                                                                  
                                                            }
                                                         
                                                      ui.tag{
                                                            tag = "div",
                                                            attr={style="text-align: left; width: 100%; float: left; position: relative; top: 230px;"},
                                                            content = function()
                                                             ui.tag{
                                                                tag = "p",
                                                                attr = { style="float: left; position: relative; margin: 0px 126px 4em 58px; text-align: right; width: 26%; font-style: italic;" },
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
                                                     
                                                            
                                                       
                                                       
                                                        --PROPOSER    
                                                            
                                                            
                                                            ui.tag{
                                                                   tag="div",
                                                                   attr={style="text-align: center; width: 100%; float: left; position: relative; top: 290px;"},
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
                                                                        attr={style="float: left; position: relative; border: 1px solid black; height: 190px; margin-left: 0.6em; text-align: left; width: 60%;"},
                                                                        content=function()
                                                                        
                                                                        
                                                                         ui.container
                                                                            {
                                                                               attr={style="position: relative; height: 190px; text-align: left; line-height: 56px; margin-left: 60px;"},
                                                                               content=function()
                                                                               ui.field.boolean{ label_attr={style="font-size:25px"},name = "proposer1", label = _"Citiziens", value = proposer1 }
                                                                              
                                                                               ui.field.boolean{ label_attr={style="font-size:25px"},name = "proposer2", label = _"Elected M5S", value = proposer2 }
                                                                              
                                                                               ui.field.boolean{ label_attr={style="font-size:25px"},name = "proposer3", label = _"Other groups", value = proposer3 }  
                                                                        
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
                                
                                 
 
                                   
                                    
                       end --fine contenuto
                        
                   }--fine form
            --------------------------------------------------------
            
    end }
end }

                           
 

