 
local area_id=param.get("area_id" )
local unit_id=param.get("unit_id" )
 

local page=param.get("page",atom.integer)


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
                                        content=  _"Target description title"
                                      }
                                end
                         }
                         
            --------------------------------------------------------      
            --contenuto specifico della pagina wizard    
             ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page,style="height:100%"},
                        module = 'wizard',
                        action = 'wizard_new_save',
                        params={
                                area_id=area_id,
                                unit_id=unit_id,
                                page=page
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
                    
                           --contenuto
                               ui.tag{
                                   tag="div",
                                   attr={style="width:100%;height:100%;text-align: center;"},
                                   content=function()  
                                   
                                    ui.container
                                    {
                                        attr={style="width: 20%; position: relative; float: left; margin-left: 10em;"},
                                        content=function()
                                         ui.tag{
                                            tag="p",
                                            attr={style="text-align: right; float: right; font-size: 20px;"},
                                            content=  _"Target description"
                                          }   
                                        
                                         ui.tag{
                                            tag="p",
                                            attr={style="float: right; position: relative; text-align: right;  font-style: italic;"},
                                            content=  _"Target note"
                                          }   
                                          
                                        end
                                        
                                     }   
                                        ui.tag
                                           {
                                                tag="textarea",
                                                attr={id="target_description",name="target_description",style="resize: none;float: left; font-size: 23px; height: 228px; margin-left: 15px; width: 598px;"},
                                                content=function()
                                                end
                                                
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
                                     btnBackModule = "wizard",
                                     btnBackView = "wizard_new_initiative",
                                     page=page
                                    }
                         }
                          
           
        end             
     }
