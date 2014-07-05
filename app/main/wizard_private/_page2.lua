local area_id=param.get("area_id" )
local unit_id=param.get("unit_id" )
local page=param.get("page",atom.integer)
 
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
                                attr={id="wizardTitoloArea",class="titoloWizardHead", style="text-align: center; width: 100%;"},
                                content=function()
                                  ui.tag{
                                        tag="p",
                                        attr={},
                                        content=  "FASE "..page
                                      }
                                      
                                  ui.tag{
                                        tag="p",
                                        attr={style="font-size:28px;"},
                                        content=  _"Give a title to the problem you want to solve"
                                      }
                                end
                         }
                         
            --------------------------------------------------------      
            --contenuto specifico della pagina wizard    
             ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page,style="height:80%"},
                        module = 'wizard',
                        view = 'wizard_new_initiative',
                        params={
                                
                                area_id=area_id,
                                unit_id=unit_id,
                                page=page+1
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
                       
                        --parametri in uscita 
                        for i,k in ipairs(wizard) do
                          ui.hidden_field{name=k.name ,value=k.value}
                           trace.debug("[wizard] name="..k.name.." | value="..k.value)
                        end
                        
                    
                           --contenuto
                               ui.tag{
                                   tag="div",
                                   attr={style="width:100%;text-align: center;"},
                                   content=function()     
                                           ui.field.text
                                           {
                                                attr={id="issue_title",style=" font-size: 25px;height: 30px;width: 60%;"},
                                                name="issue_title",
                                                label=_"Problem Title",
                                                label_attr={style="font-size:20px"}
                                           }
                                    end
                                }
                           end --fine contenuto
                        
                   }--fine form
            --------------------------------------------------------
            
           --pulsanti
            execute.view{
                            module="wizard",
                            view="_pulsanti",
                            params={
                                     wizard=wizard,
                                     btnBackModule = "wizard",
                                     btnBackView = "wizard_new_initiative",
                                     page=page
                                    }
                         }
                          
           
        end             
     }
