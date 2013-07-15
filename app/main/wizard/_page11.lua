local area_id=param.get("area_id" )
local unit_id=param.get("unit_id" )

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
                                        content=  _"The proposals was presented by:"
                                      }
                                end
                         }
                         
                      
                   
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
                          if k.value then
                          trace.debug("[wizard] name="..k.name.." | value="..k.value)
                          end
                        end
                     
                        --contenuto
                       ui.container {
                                   attr={style="float: left; border: 1px solid black; position: relative; vertical-align: middle; width: 96%; margin-bottom: 8em; margin-top: 4em; text-align: left; margin-left: 1.6em;"},
                                   content=function()
                                   ui.container
                                           {
                                          attr={style="line-height: 56px; position: relative; text-align: left; margin-left: 325px; float: left;"},
                                          content=function()
                                          ui.field.boolean{ label_attr={style="font-size:25px"},name = "proposer1", label = _"Citiziens", value = proposer1 }
                                          ui.field.boolean{ label_attr={style="font-size:25px"},name = "proposer2", label = _"Elected M5S", value = proposer2 }
                                          ui.field.boolean{ label_attr={style="font-size:25px"},name = "proposer3", label = _"Other groups", value = proposer3 }  
                                                                        
                                          end
                                                         }
                                          end
                                          }
                                                             --fine div formSelect
            
                    end            
               }--fine form
            --------------------------------------------------------
            
           --pulsanti
 
            execute.view{
                            module="wizard",
                            view="_pulsanti",
                            params={
                                     btnBackModule = "wizard",
                                     btnBackView = "wizard_new_initiative",
                                     page=page
                                    }
                         }
                          
      end             
     }
 
 
