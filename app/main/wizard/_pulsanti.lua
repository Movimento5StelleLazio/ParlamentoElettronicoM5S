

local page=param.get("page",atom.integer)
local wizard=param.get("wizard","table")

local btnBackModule  
local btnBackView  
local btnBackParams
local previus_page=page-1
local next_page=page+1

if not page  or page <= 1 then
    page=1
    btnBackModule ="index"
    btnBackView = "homepage"
    btnBackParams=nil
    
    else
    btnBackParams=previus_page
    btnBackModule ="wizard"
    btnBackView = "wizard_new_initiative"
end




    --pulsanti
               
            ui.tag
            {
            tag="div",
                attr={id="pulsanti" , style="position: relative;width:90%;margin-left: auto;margin-right: auto;"},
                content=function()
               --pulsante Previuos
                     ui.link{
                                 attr={id="btnPreviuos",class="button orange menuButton pulsantiWizard",style="float:left"},
                                 module = btnBackModule,
                                 view = btnBackView,
                                 params = { 
                                                unit_id=app.session.member.unit_id,
                                                area_id=app.session.member.area_id,
                                                page=btnBackParams 
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
                             tag="a",
                             attr={id="btnNext",class="button orange menuButton pulsantiWizard",style="float:right",onclick="document.getElementById('wizardForm"..page.."').submit();"},
                             module = "wizard",
                             view = "wizard_new_initiative",
                             params = { 
                                                unit_id=app.session.member.unit_id,
                                                area_id=app.session.member.area_id,
                                                page=page 
                                           },
                             content=function()
                                
                                    ui.tag{
                                       tag = "p",
                                       attr={style="text-align: center; width:126px", readonly="true"},
                                       content        =_"Next Phase".."    >>",  
                                       multiline=true
                                      
                                    }  
                                    
                                end-- fine tag.content
                        } -- fine pulsante next
--
--                     ui.link{
--                                 attr={id="btnNext",class="button orange menuButton pulsantiWizard",style="float:right"},
--                                 module = "wizard",
--                                 view = "wizard_new_initiative",
--                                 params = { 
--                                               wizard=wizard,
--                                               unit_id=app.session.member.unit_id,
--                                               area_id=app.session.member.area_id,
--                                               page=page+1 
--                                           },
--                                 content=function()
--                                    
--                                        ui.tag{
--                                           tag = "p",
--                                           attr={style="text-align: center; width:80px", readonly="true"},
--                                           content        =_"Next Phase".."    >>",  
--                                           multiline=true
--                                          
--                                        }  
--                                        
--                                    end-- fine tag.content
--                            } -- fine pulsante next
--               

 ui.tag
                                        {
                                        tag="div",
                                        attr={style="text-align: center;height:120px; width: 100%; float: left; position: relative; "},
                                        content=function()  
                                        end
                                        }         
                    
                end
            
            }-- fine pulsanti container
          
                    