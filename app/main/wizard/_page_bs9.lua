
local area_id=param.get("area_id" )
local unit_id=param.get("unit_id" )
 

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
    ui.heading{level=4,attr={class="uppercase"},content=  _"Insert the text for your initiative to solve the problem"}
  end }
end }
                                       
ui.container{attr={class="row-fluid spaceline3"},content=function()
ui.container{attr={class="span12 text-center"},content=function()
            --------------------------------------------------------      
            --contenuto specifico della pagina wizard    
             ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page,class="inline-block"},
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
                            ui.container{attr={class="span6 text-right collapse", style="height:100%"},content=function()
                              ui.tag{tag="p",content=  _"Draft text"}
                              ui.tag{tag="em",content=  _"Draft note"}
                            end }
                            ui.tag{
                              tag="textarea",
                              attr={id="draft",name="draft",class="span6 collapse", style="height:32em; resize:none;"},
                              content=""
                            }
                          end }
                        end }
                      end }

                           end --fine contenuto
                   }--fine form
            --------------------------------------------------------
   end }
end }

 

ui.container{attr={class="row-fluid btn_box_bottom spaceline3"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
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
