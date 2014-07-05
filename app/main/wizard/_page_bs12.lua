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
    ui.container{attr={ class  = "row-fluid" } , content = function()
      ui.container{attr={ class  = "well span12" }, content = function()
        ui.container{attr={ class  = "row-fluid" } , content = function()
          ui.container{attr={ class  = "span12" }, content = function()
            ui.heading{level=1, content = _"WIZARD HEADER END" }
          end }
		end }
        ui.container{ attr = { class  = "row-fluid spaceline3" } , content = function()
          ui.container{ attr = { class  = "span3" }, content = function()
	        ui.link{
              attr = { class="btn btn-primary btn-large table-cell fixclick" ,onclick="window.history.back()"},
              module = "wizard",
              view = "wizard_new_initiative_bs",
              params={
                area_id=area_id,
                unit_id=unit_id,
                page=12,
                indietro=true
              },
              content = function()
                ui.heading{level=3,attr={class="fittext_back_btn"},content=function()
                  ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
                  slot.put(_"Back to previous page")
                end }
              end
            }				
	      end }
          ui.container{ attr = { class  = "span9" }, content = function()
	        ui.heading{level=3, content = _"WIZARD END"}
          end }
        end }
      end }
    end }


    ui.container{attr={class="row-fluid"},content=function()
      ui.container{attr={class="span12 text-center"},content=function()
        ui.heading{level=2,attr={class="spaceline"}, content= function()
          slot.put(_"Unit"..": ".."<strong>"..unit_name.."</strong>" )
        end }
        ui.heading{level=2,content= function()
          slot.put( _"Area"..": ".."<strong>"..area_name.."</strong>" )
        end }
      end }
    end }
	  
  end }
end }
  

ui.container{attr={class="row-fluid spaceline3"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()                                
    --------------------------------------------------------      
     --contenuto specifico della pagina wizard    
    ui.form{
      method = "post",
      attr={id="wizardForm"..page,class=""},
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
          }
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
          if k.name=="technical_area_3" then
             technical_area_3=k.value
           else
             technical_area_3=0
          end
          if k.name=="technical_area_4" then
             technical_area_4=k.value
          else
             technical_area_4=0
          end
        end --fine for
        ui.container {
          attr={class="formSelect",style=""},
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
                trace.debug("allowed_policy.id="..allowed_policy.policy_id.."| policy_id="..allowed_policy.policy_id)
                ui.hidden_field{name=allowed_policy.name ,value=i.."_"..allowed_policy.policy_id}
                if tonumber(allowed_policy.policy_id)==tonumber(policy_id) then
                  if i==1 then
                    selected1="true"
                    trace.debug("selected1="..selected1)
                  end
                  if i==2 then
                    selected2="true"
                    trace.debug("selected2="..selected2)
                  end
                  if i==3  then
                    selected3="true"
                    trace.debug("selected3="..selected3)
                  end
                end
              end   
            end --fine if
			
            ui.container {
              attr={class="formSelect",style=""},
              content=function()
                --contenuto
                ui.container{attr={class="row-fluid spaceline3"},content=function()
                  ui.container{attr={class="span12 text-center"},content=function()
				    ui.container{attr={class="inline-block"},content=function()
                      ui.container{attr={class="text-left"},content=function()
                        --1 proposer
                        execute.view {
                          module="wizard",
                          view="_checkbox_bs_pag1",
                          params={
                            imgId=tostring(1),
                            id_checkbox=tostring(dataSource[2].id),
                            label= "URGENTE (1 Settimana)",
                            selected=selected1
                          }
                        }
                        
                        --2 proposer
                        execute.view {
                          module="wizard",
                          view="_checkbox_bs_pag1",
                          params={
                            imgId=tostring(2),
                            id_checkbox=tostring(dataSource[3].id),
                            label="NORMALE (1 Mese)",
                            selected=selected2
                               
                          }
                        }
                                                                
                        --3 proposer
                        execute.view {
                      module="wizard",
                      view="_checkbox_bs_pag1",
                      params={
                        imgId=tostring(3),
                        id_checkbox=tostring(dataSource[4].id),
                        label="TEMPI LUNGHI (6 Mesi)",
                        selected=selected3
                      }
                    }
                      end }
					end }                                                      
                  end }
                end }  
				
				--fine div contento  
              end 
			}
			
            ui.tag{
              tag = "div",
              attr={style=""},
              content = function()
--              ui.tag{
--                content = function()
--                  ui.link{
--                    text = _"Information about the available policies",
--                    module = "policy",
--                    view = "list"
--                  }
--                  slot.put(" ")
--                  ui.link{
--                    attr = { target = "_blank" },
--                    text = _"(new window)",
--                    module = "policy",
--                    view = "list"
--                  }
--                end
--              }--fine tag
              end
            } --fine tag 
            
			-- Box questione
			ui.container{attr={class="row-fluid spaceline3"},content=function()
			  ui.container{attr={class="span12 text-center alert alert-simple issue_box paper", style="padding-bottom:30px"},content=function()
			    
				--Titolo box questione
				ui.container{attr={class="row-fluid spaceline3"},content=function()
                  ui.container{attr={class="span4 offset1"},content=function()      
                    ui.heading{ level=5, attr = { class = "alert head-orange uppercase text-center" }, content = _"QUESTIONE" }
                  end }
                end }
				
				--Titolo questione
				ui.container{attr={class="row-fluid spaceline3"},content=function()
                  ui.container{attr={class="span4 offset1 text-right"},content=function() 
					ui.tag{tag="label", content=_"Problem Title"}
				  end }
				  ui.container{attr={class="span6"},content=function() 
					ui.tag{tag="input",attr={id="issue_title", name="issue_title", value=issue_title, style="width:100%;"}, content=""}
                  end }
                end }
                
				-- Descrizione breve questione
                ui.container{attr={class="row-fluid spaceline4"},content=function()
                  ui.container{attr={class="span4 offset1 text-right issue_brief_span"},content=function()
                    ui.tag{tag="p",content=  _"Description to the problem you want to solve"}
--                      ui.tag{tag="em",content=  _"Description note"}
                  end }
                  ui.container{attr={class="span6 issue_brief_span"},content=function()
                    ui.tag{
                      tag="textarea",
                      attr={id="issue_brief_description",name="issue_brief_description", style="width:100%;height:100%;resize:none;"},
                      content=issue_brief_description
                    }
                  end }
                end }
                
				-- Keywords
                ui.container{attr={class="row-fluid spaceline4"},content=function()
                  ui.container{attr={class="span4 offset1 text-right"},content=function()
                    ui.tag{tag="p",content=  _"Keywords"}
 --                     ui.tag{tag="em",content=  _"Keywords note"}
                  end }
                  ui.container{attr={class="span6 collapse",style="height:auto;"},content=function()
                    ui.tag{
                      tag="textarea",
                      attr={id="issue_keywords",name="issue_keywords",class="tagsinput",style="resize:none;"},
                      content=issue_keywords
                    }
                  end }
                end }
				
				-- Descrizione del problema
				ui.container{attr={class="row-fluid spaceline4"},content=function()
                  ui.container{attr={class="span4 offset1 text-right issue_desc"},content=function()
                    ui.tag{tag="p",content=  _"Problem description"}
--                      ui.tag{tag="em",content=  _"Problem note"}
                  end }
                  ui.container{attr={class="span6 issue_desc"},content=function()
                    ui.tag{
                      tag="textarea",
                      attr={id="problem_description",name="problem_description",style="height:100%;width:100%;resize:none;"},
                      content=problem_description
                    }
                  end }
                end }
				
				-- Descrizione dell'obiettivo
				ui.container{attr={class="row-fluid spaceline3"},content=function()
                  ui.container{attr={class="span4 offset1 text-right aim_desc"},content=function()
                    ui.tag{tag="p",content=  _"Target description"}
--                      ui.tag{tag="em",content=  _"Target note"}
                  end }
                  ui.container{attr={class="span6 aim_desc"},content=function()
                    ui.tag{
                      tag="textarea",
                      attr={id="aim_description",name="aim_description",style="height:100%;width:100%;resize:none;"},
                      content=aim_description
                    }
                  end }
                end }

			  end }
			end }
			
			-- Box proposta
			ui.container{attr={class="row-fluid spaceline3"},content=function()
			  ui.container{attr={class="span12 text-center alert alert-simple issue_box paper", style="padding-bottom:30px"},content=function()

                -- Titolo box proposta			  
				ui.container{attr={class="row-fluid spaceline3"},content=function()
                  ui.container{attr={class="span4 offset1"},content=function()      
                    ui.heading{ level=5, attr = { class = "alert head-chocolate uppercase text-center" }, content = _"PROPOSTA" }
                  end }
                end }
				
				-- Titolo proposta
				ui.container{attr={class="row-fluid spaceline3"},content=function()
                  ui.container{attr={class="span4 offset1 text-right"},content=function() 
					ui.tag{tag="label", content=_"Initiative Title"}
				  end }
				  ui.container{attr={class="span6"},content=function() 
					ui.tag{tag="input",attr={id="initiative_title", name="initiative_title", value=initiative_title, style="width:100%;"}, content=""}
                  end }
                end }
				
				-- Descrizione breve proposta
				ui.container{attr={class="row-fluid spaceline3"},content=function()
				  ui.container{attr={class="span4 offset1 text-right init_brief"},content=function()
                    ui.tag{tag="p",content=  _"Initiative short description"}
--                      ui.tag{tag="em",content=  _"Initiative short note"}
                  end }
                  ui.container{attr={class="span6 init_brief"},content=function()
                    ui.tag{
                      tag="textarea",
                      attr={id="initiative_brief_description",name="initiative_brief_description",style="height:100%;width:100%;resize:none;"},
                      content=initiative_brief_description
                    }
                  end }
				end }
								
				-- Testo della proposta
				ui.container{attr={class="row-fluid spaceline3"},content=function()
                  ui.container{attr={class="span4 offset1 text-right draft"},content=function()
                    ui.tag{tag="p",content=  _"Draft text"}
--                      ui.tag{tag="em",content=  _"Draft note"}
                  end }
                  ui.container{attr={class="span6 draft"},content=function()
                    ui.tag{
                      tag="textarea",
                      attr={id="draft",name="draft",style="height:100%;width:100%;resize:none;"},
                      content=draft
                    }
                  end }
                end }
			    
                 -- Selezione areee tecniche
				 
                ui.container{attr={class="row-fluid",style="padding-top: 2em;"},content=function()
                  ui.container{attr={class="span12 text-center",style="margin-top: 5em; margin-left: 1em; "},content=function()
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
                     end
                     --contenuto
                     --1* selezione
                      ui.container{attr={class="formSelect"},content=function() 
                        ui.container{
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
                  end }       
				  
				 --fine selezione aree tecniche 

				 
				-- Proposta avanzata da
                  ui.tag{tag="div",attr={style="row-fluid"},content=function()  
                                               
                                                           
                                                           ui.container{attr={class="span2 text-center"},content=function()
                                                                         ui.tag{
                                                                            tag="p",
                                                                            attr={style="text-align: right; float: left; font-size: 20px;"},
                                                                            content=   _"The proposals was presented by:"
                                                                          }   
                                                                        end
                                                                   }
                                                               
                                                                ui.container
                                                                    {
                                                                        attr={style="float: left; position: relative; border: 1px solid black; height: 19em; margin-left: 0.6em; text-align: left; width: 80%;"},
                                                                        content=function()
                                                                        
                                                                        
                                                                         ui.container
                                                                            {
                                                                               attr={style="position: relative; text-align: left; line-height: 56px; margin-top: 1em;margin-left: 1em;"},
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
                                                                    
                                                                 ui.container{attr={class="span3 text-center"},content=function()
                                                                 end}     
                                                               ui.field.hidden{
                                                                               name="formatting_engine",
                                                                               value="rocketwiki"
                                                                               }
                                                                    
                                                             
                      end
                           }--fine div formSelect
                   end} 
				   
				--fine Prpoposta avanzata da
		
				-- Pulsanti
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
		
		
		
 
		
				  
              end }
			end }
                     

          end 
		  --fine contenuto
        }
	  --fine form
    end }
end }

ui.script{static = "js/jquery.fittext.js"}
ui.script{script = "jQuery('.fittext_back_btn').fitText(1.1, {minFontSize: '17px', maxFontSize: '32px'}); " }                  
ui.script{static = "js/jquery.equalheight.js"}
ui.script{script = '$(document).ready(function() { equalHeight($(".issue_brief_span")); $(window).resize(function() { equalHeight($(".issue_brief_span")); }); }); ' }

ui.script{script = '$(document).ready(function() { equalHeight($(".issue_keywords")); $(window).resize(function() { equalHeight($(".issue_keywords")); }); }); ' }
ui.script{script = '$(document).ready(function() { equalHeight($(".issue_desc")); $(window).resize(function() { equalHeight($(".issue_desc")); }); }); ' }
ui.script{script = '$(document).ready(function() { equalHeight($(".aim_desc")); $(window).resize(function() { equalHeight($(".aim_desc")); }); }); ' }
ui.script{script = '$(document).ready(function() { equalHeight($(".init_brief")); $(window).resize(function() { equalHeight($(".init_brief")); }); }); ' }
ui.script{script = '$(document).ready(function() { equalHeight($(".draft")); $(window).resize(function() { equalHeight($(".draft")); }); }); ' }


ui.script{static="js/jquery.tagsinput.js"}
ui.script{script="$('#issue_keywords').tagsInput({'height':'96%','width':'96%','defaultText':'".._"Add a keyword".."','maxChars' : 20});"}

