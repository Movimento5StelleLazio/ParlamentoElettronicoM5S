
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
                                        content=  _"...."
                                      }
                                end
                         }
                         
            --------------------------------------------------------      
            --contenuto specifico della pagina wizard    
             ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page},
                        module = 'wizard',
                        action = 'wizard_new_save',
                        params={
                                area_id=1,
                                unit_id=unit_id,
                                page=page
                        },
                        routing = {
                            ok = {
                              mode   = 'redirect',
                              module = 'wizard',
                              view = 'wizard_new_initiative',
                              params = {
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
                    
           
            
            
                       end --fine contenuto
                        
                   }--fine form
            --------------------------------------------------------
            
            --pulsanti
            ui.tag
            {
            tag="div",
                attr={id="pulsanti" , style="position: relative;top: 100px;width:90%;margin-left: auto;margin-right: auto;"},
                content=function()
               --pulsante Previuos
                     ui.link{
                                 attr={id="btnPreviuos",class="button orange menuButton pulsantiWizard",style="float:left"},
                                 module = btnBackModule,
                                 view = btnBackView,
                                 params = { 
                                                --unit={name="LazionM5S"},
                                                --area = {name="testAreaName"},
                                                page=previus_page 
                                           },
                                 content=function()
                                    
                                        ui.tag{
                                           tag = "p",
                                           attr={style="text-align: center; width:80px", readonly="true"},
                                           content        =_"Back Phase".."\n <<",  
                                           multiline=true
                                          
                                        }  
                                        
                                    end-- fine tag.content
                            } -- fine pulsante previuos
                            
                   ui.container{
                                 attr={id="spazioDiv", class="spazioDiv"},
                                 content=function()
                                 end
                                }        
                 
                   --pulsante Next
                  ui.tag{
                             tag="button",
                             attr={id="btnNext",class="button orange menuButton pulsantiWizard",style="float:right",onclick="document.getElementById('wizardForm"..page.."').submit();"},
                             
                             content=function()
                                
                                    ui.tag{
                                       tag = "p",
                                       attr={style="text-align: center; width:80px", readonly="true"},
                                       content        =_"Next Phase".."    >>",  
                                       multiline=true
                                      
                                    }  
                                    
                                end-- fine tag.content
                        } -- fine pulsante next
                    
                end
            
            }-- fine pulsanti container
                
                   
           
        end             
     }