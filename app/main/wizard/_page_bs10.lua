local area_id=param.get("area_id" )
local unit_id=param.get("unit_id" )


local page=param.get("page",atom.integer)
local wizard=param.get("wizard","table")

local area={}

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
                  --contenuto specifico della pagina wizard    
             ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page,style="height:80%"},
                        module = 'wizard',
                        view = 'wizard_new_initiative_bs',
                        params={
                                area_id=area_id,
                                unit_id=unit_id,
                                page=page
                        },
                        routing = {
                            ok = {
                              mode   = 'redirect',
                              module = 'wizard',
                              view = 'wizard_new_initiative_bs',
                              params = {
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                          },
                            },
                            error = {
                              mode   = '',
                              module = 'wizard',
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
                 ui.container{attr={class="row-fluid"},content=function()
                    ui.container
                      {
                        attr={class="span10 offset1"},
                        content=function() 
    
                       --1* selezione

                       ui.container
                        {
                          attr={class="formSelect spaceline3"},
                          content=function() 
                          
                           ui.container
                                 {
                                     attr={class="row-fluid text-center"},
                                     content=function() 
                                       --checkbox
                                       execute.view
                                          {
                                              module="wizard",
                                              view="_checkbox_bs_pag10",
                                              params={
                                                   id_checkbox="1",
                                                   label=""
                                              }
                                          }
                                       
                                        ui.tag{
                                                  tag="div",
                                                  attr={id="div1",disabled="false"},
                                                  content=function()
                                       
                                       --select
                    ui.container
                      {
                        attr={class="span10 spaceline3"},
                        content=function() 

                                       ui.field.select{
                                            attr = { id = "technicalChooser", onchange="namePasteTemplateChange(event)", style="width: 25.4em;height:38px;"},
                                            label =  "1° AREA DI COMPETENZA TECNICA:",
                                            label_attr={class="spaceline"},
                                            name = 'technical_area_1',
                                            foreign_records = tmp,
                                            foreign_id = "id",
                                            foreign_name = "name",
                                            value =  ""
                                          }

                                      end
                                      
                                }
                                 end
                                      
                             }
                         end
                         }
                         
                         end
                         }--fine div formSelect
                     
                     
                     
                   --2* selezione

                      
                       ui.container
                        {
                          attr={class="formSelect spaceline3"},
                          content=function() 
                          
                           ui.container
                                 {
                                     attr={class="row-fluid text-center"},
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
                                                  attr={id="div2",style="opacity:0.5;",disabled="true"},
                                                  content=function()
                                       
                                       --select
                    ui.container
                      {
                        attr={class="span10 spaceline3"},
                        content=function() 
                                       ui.field.select{
                                            attr = { id = "technicalChooser2", onchange="namePasteTemplateChange(event)",disabled="true", style="width: 25.4em;height:38px;"},
                                            label =  "2° AREA DI COMPETENZA (opzionale):",
                                            label_attr={class="spaceline"},
                                            name = 'technical_area_2',
                                            foreign_records = tmp,
                                            foreign_id = "id",
                                            foreign_name = "name",
                                            value =  ""
                                          }
                                          

                                      end
                                      
                                }
                                 end
                                      
                             }
                                                  end
                         }
                         end
                         }--fine div formSelect
                     
                   --fine 2* selezione  
                 
                 
                   --3* selezione


                      
                       ui.container
                        {
                          attr={class="formSelect spaceline3"},
                          content=function() 
                          
                           ui.container
                                 {
                                     attr={class="row-fluid text-center"},
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
                                                  attr={id="div3",style="opacity:0.5;",disabled="true"},
                                                  content=function()
                                       --select
                    ui.container
                      {
                        attr={class="span10 spaceline3"},
                        content=function() 
                                     
                                       ui.field.select{
                                            attr = { id = "technicalChooser3", onchange="namePasteTemplateChange(event)",disabled="true", style="width: 25.4em;height:38px;"},
                                            label =  "3° AREA DI COMPETENZA (opzionale):",
                                            label_attr={class="spaceline"},
                                            name = 'technical_area_3',
                                            foreign_records = tmp,
                                            foreign_id = "id",
                                            foreign_name = "name",
                                            value =  ""
                                          }
                                          

                                      end
                                      
                                }
                                 end
                                      
                             }
                                                  end
                         }
                         end
                         }--fine div formSelect
                     
                   --fine 3* selezione  
                 
                 
                 
                   --4* selezione

                      
                       ui.container
                        {
                          attr={class="formSelect spaceline3"},
                          content=function() 
                          
                           ui.container
                                 {
                                     attr={class="row-fluid text-center"},
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
                                                  attr={id="div4",style="opacity:0.5;",disabled="true"},
                                                  content=function()
                                       --select
                    ui.container
                      {
                        attr={class="span10 spaceline3"},
                        content=function() 
                                                   ui.field.select{
                                                        attr = { id = "technicalChooser4", onchange="namePasteTemplateChange(event)",disabled="true", style="width: 25.4em;height:38px;"},
                                                        label =  "4° AREA DI COMPETENZA (opzionale):",
                                                        label_attr={class="spaceline"},
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
                         end
                         }
                         end
                         }
                         
                         end
                         }--fine div formSelect
                     
                   --fine 4* selezione 
 
                   ui.script{static = "js/wizard_checkbox.js"} 
 
 ui.container
                      {
                        attr={class="row-fluid"},
                        content=function() 
 ui.container
                      {
                        attr={class="span10 offset1"},
                        content=function() 
                 
                   ui.tag{
                                    tag = "p",
                                    attr = { class="text-justify spaceline3" },
                                    content=  _"Description technical note"
                                  }
                        
                     end
                }--fine form
                      end}
            end}  
            
            end}
            end}         
     
  end }


ui.script{static = "js/jquery.equalheight.js"}
ui.script{script = '$(document).ready(function() { equalHeight($(".eq_btn")); $(window).resize(function() { equalHeight($(".eq_btn")); }); }); ' }
ui.script{static = "js/jquery.fittext.js"}
ui.script{script = "jQuery('.fittext').fitText(0.9, {minFontSize: '10px', maxFontSize: '28px'}); " }
 

ui.container{attr={class="row-fluid btn_box_bottom spaceline3"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
    execute.view{
      module="wizard",
      view="_pulsanti_bs",
      params={
        btnBackModule = "wizard",
        btnBackView = "wizard_new_initiative_bs",
        page=page
      }
    }
  end }
end }
 
