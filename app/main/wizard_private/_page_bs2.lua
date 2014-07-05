local area_id=param.get("area_id", atom.integer)
local unit_id=param.get("unit_id", atom.integer)
local page=param.get("page", atom.integer)
 
local wizard=param.get("wizard","table")

if not wizard then
 
    trace.debug("new obj wizard ?")
    --wizard=app.wizard
    --app.session:save()
    else
    trace.debug("wizard passed.")
    --trace.debug("wizard id="..wizard.policy_id)
end
 



local btnBackModule = "wizard"
local btnBackView = "wizard_new_initiative_bs"

if not page  or page <= 1 then
    page=1
    btnBackModule ="index"
    btnBackView = btnBackView
end

local previus_page=page-1
local next_page=page+1


ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
   ui.heading{level=3,content=function() 
      slot.put(_"FASE <strong>"..page.."</strong> di 11") 
    end}
    ui.heading{level=4,attr={class="uppercase"}, content=  _"Give a title to the problem you want to solve" }
  end }
end }
                         
ui.container{attr={class="row-fluid",style="padding-top: 2em;"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
                         
            --------------------------------------------------------      
            --contenuto specifico della pagina wizard    
             ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page,style="height:80%"},
                        module = 'wizard',
                        view = "wizard_new_initiative_bs",
                        params={
                                
                                area_id=area_id,
                                unit_id=unit_id,
                                page=page
                        },
                        routing = {
                            ok = {
                              mode   = 'redirect',
                              module = 'wizard',
                              view = "wizard_new_initiative_bs",
                              params = {
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page+1
                                          },
                            },
                            error = {
                              mode   = '',
                              module = 'wizard',
                              view =  "wizard_new_initiative_bs",
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
                            
                    
                           --contenuto
                               ui.tag{
                                   tag="div",
                                   attr={style="width:100%;text-align: center;margin-top: 2em;margin-botton: 2em;"},
                                   content=function()     
                                           ui.field.text
                                           {
                                                attr={id="issue_title",style=" font-size: 25px;height: 30px;width: 60%;"},
                                                name="issue_title",
                                                label=_"Problem Title",
                                                label_attr={style="font-size:20px"}
                                           }
                                end--fine contenuto
                                }
                           end --fine content
                        
                   }--fine form
                           end }
                         end }
 
 



 ui.container{attr={class="row-fluid btn_box_bottom spaceline3"},content=function()
 ui.container{attr={class="span12 text-center"},content=function()
           --pulsanti
            execute.view{
                            module="wizard",
                            view="_pulsanti_bs",
                            params={
                                     wizard=wizard,
                                     btnBackModule = "wizard",
                                     btnBackView = btnBackModule,
                                     page=page
                                    }
                         }
                          
           
      
   end }
end }    
     
