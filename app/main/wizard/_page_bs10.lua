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
    ui.heading{level=3,content= _"FASE "..page }
    ui.heading{level=4,content=  _"Insert Technical Areas" }
  end }
end }
ui.container{attr={class="row-fluid",style="padding-top: 2em;"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
                      
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
                                            name = 'technical_area_1',
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
                     
     
  end }
end }


 

ui.container{attr={class="row-fluid"},content=function()
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
 