local area_id=param.get("area_id", atom.integer)
local unit_id=param.get("unit_id", atom.integer)
local page=param.get("page",atom.integer)
local wizard=param.get("wizard","table")
local btnBackModule = "wizard"
local btnBackView = "wizard_new_initiative_bs"

if not page  or page <= 1 then
    page=1
    btnBackModule ="index"
    btnBackView = "homepage_bs"
end

local previus_page=page-1
local next_page=page+1


if not wizard then
 
    trace.debug("new obj wizard ?")
    --wizard=app.wizard
    --app.session:save()
    else
    trace.debug("wizard passed.")
    --trace.debug("wizard id="..wizard.policy_id)
end
 

ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
   ui.heading{level=3,content=function() 
      slot.put(_"FASE <strong>"..page.."</strong> di 11") 
    end}
    ui.heading{level=4,attr={class="uppercase"},content=  _"Give a short description to the problem you want to solve"}
  end }
end }
                                       
ui.container{attr={class="row-fluid spaceline3"},content=function()
ui.container{attr={class="span12 text-center"},content=function()
            --------------------------------------------------------      
            --contenuto specifico della pagina wizard    
             ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page, class="inline-block"},
                        module = 'wizard',
                        view = btnBackView,
                        params={
                                area_id=area_id,
                                unit_id=unit_id,
                                page=page
                        },
                        routing = {
                            ok = {
                              mode   = 'redirect',
                              module = 'wizard',
                              view = btnBackView,
                              params = {
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                          },
                            },
                            error = {
                              mode   = '',
                              module = 'wizard',
                              view = btnBackView,
                            }
                          }, 
                       content=function()
                    
                    --parametri in uscita 
                            ui.hidden_field{name="indietro" ,value=false}
                    
                            for i,k in ipairs(wizard) do
                              ui.hidden_field{name=k.name ,value=k.value}
                              if k.value then
                              trace.debug("[wizard] name="..k.name.." | value="..k.value)
                              end
                            end
                      
                      ui.container{attr={class="row-fluid"},content=function()
                        ui.container{attr={class="span10 offset1 text-center"},content=function()            
                          ui.container{attr={class="row-fluid"},content=function()
                            ui.container{attr={class="span6 text-right issue_brief_span"},content=function()
                              ui.tag{tag="p",content=  _"Description to the problem you want to solve"}                    
                              ui.tag{tag="em",content=  _"Description note"}
                            end }
                            ui.container{attr={class="span6 issue_brief_span"},content=function()
                              ui.tag{
                                tag="textarea",
                                attr={id="issue_brief_description",name="issue_brief_description", style="width:100%;height:100%;resize:none;"},
                                content=""
                              }
                              ui.tag{tag="small", attr={class="uppercase"}, content= _"Maxiumum number of characters is 140 (#{chars} left)"}
                            end }
                          end }
                        end }
                      end }

                      end

                   }--fine form
            --------------------------------------------------------
   end }
end }

 

ui.container{attr={class="row-fluid btn_box_bottom spaceline3"},content=function()
  ui.container{attr={class="span12 text-center spaceline3"},content=function()
    execute.view{
      module="wizard",
      view="_pulsanti_bs",
      params={
        btnBackModule = "wizard",
        btnBackView = btnBackView,
        page=page
      }
    }
  end }
end }


ui.script{static = "js/jquery.equalheight.js"}
ui.script{script = '$(document).ready(function() { equalHeight($(".issue_brief_span")); $(window).resize(function() { equalHeight($(".issue_brief_span")); }); }); ' }
