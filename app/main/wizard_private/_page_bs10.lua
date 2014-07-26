local area_id=param.get("area_id", atom.integer)
local unit_id=param.get("unit_id", atom.integer)


local page=param.get("page",atom.integer)
local wizard=param.get("wizard","table")

local areas=Area:new_selector()
	:join("unit", nil, "area.unit_id = unit.id AND unit.name LIKE \'\%ASSEMBLEA INTERNA\%\'")
	:add_order_by("id ASC")
	:exec()

local btnBackModule = "wizard_private"
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
   ui.heading{level=3,content=function() 
      slot.put(_"FASE <strong>"..page.."</strong> di 11") 
    end}
    ui.heading{level=4,content=  _"Insert Technical Areas" }
  end }
end }
ui.container{attr={class="row-fluid",style="padding-top: 2em;"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
                      
                      --valori di test
                      local tmp
                      tmp = { 
                                { id = 0, name = _"Please choose a tecnical area" }
                            }
                      
                      if #areas>0 then                       
                          for i, names in ipairs(areas) do
                          	trace.debug(names.id .. " " .. names.name .. " " .. names.description)
                            tmp[#tmp+1] = {id = names.id, name = string.sub(names.name, 1, 50).."..." }
                          end      
                          
                        --  _value=param.get("policy_id", atom.integer) or area.default_policy and area.default_policy.id
                        --else
                         
                      end
                  --contenuto specifico della pagina wizard    
             ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page,style="height:80%"},
                        module = 'wizard_private',
                        view = 'wizard_new_initiative_bs',
                        params={
                                area_id=area_id,
                                unit_id=unit_id,
                                page=page
                        },
                        routing = {
                            ok = {
                              mode   = 'redirect',
                              module = 'wizard_private',
                              view = 'wizard_new_initiative_bs',
                              params = {
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                          },
                            },
                            error = {
                              mode   = '',
                              module = 'wizard_private',
                              view = 'wizard_new_initiative_bs',
                            }
                          }, 
                       content=function()
                     
                          --parametri in uscita
                        ui.hidden_field{name="indietro" ,value=false}
                        for i,k in ipairs(wizard) do
                          ui.hidden_field{name=k.name ,value=k.value}
                          trace.debug("[wizard] name="..k.name.." | value="..k.value)
                        end
                    
                       --contenuto
                 ui.container{attr={class="row-fluid",style="padding-top: 2em;"},content=function()
                     ui.container{attr={class="span12 text-center"},content=function()      
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
                                            selected_record = area_id,
                                            value =  ""
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
                                              module="wizard_private",
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
                                              module="wizard_private",
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
                                              module="wizard_private",
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
                                    attr = { style="float: left; text-align: right; width: 25%; font-style: italic;height: 200px;font-size: 15px;padding-left: 1em;padding-top: 4em;" },
                                    content=  _"Description technical note"
                                  }
                        
                     end
                }--fine form
            
            
            end}
            end}         
     
  end }
end }

ui.script{static = "js/jquery.equalheight.js"}
ui.script{script = '$(document).ready(function() { equalHeight($(".eq_btn")); $(window).resize(function() { equalHeight($(".eq_btn")); }); }); ' }
ui.script{static = "js/jquery.fittext.js"}
ui.script{script = "jQuery('.fittext').fitText(0.9, {minFontSize: '10px', maxFontSize: '28px'}); " }
 

ui.container{attr={class="row-fluid btn_box_bottom spaceline3"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
    execute.view{
      module="wizard_private",
      view="_pulsanti_bs",
      params={
        btnBackModule = "wizard_private",
        btnBackView = "wizard_new_initiative_bs",
        page=page
      }
    }
  end }
end }
 
