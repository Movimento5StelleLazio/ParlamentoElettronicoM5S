

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
    btnBackModule ="wizard_private"
    btnBackView = "wizard_new_initiative"
end




    --pulsanti
               
            ui.tag
            {
            tag="div",
                attr={id="pulsanti" , style="position: relative; float: left; text-align: center; top: 40px; left: 9em;"},
                content=function()
                
               --pulsante anteprima
                     ui.link{
                                 attr={id="btnAnteprima",class="button orange menuButton pulsantiWizard",style="float:left;margin-right: 35px;"},
                                 module = "wizard_private",
                                 view = "anteprima",
                                 params = { 
                                                
                                           },
                                 content=function()
                                    
                                        ui.tag{
                                           tag = "p",
                                           attr={style="text-align: center; line-height: 25px; width: 150px; font-size: 22px;", readonly="true"},
                                           content        =_"Show preview",  
                                           multiline=true
                                          
                                        }  
                                        
                                    end-- fine tag.content
                            } -- fine pulsante previuos
                            
                   ui.container{
                                 attr={id="spazioDiv", class="spazioDiv"},
                                 content=function()
                                 end
                                }        
                 
                 
                 
                      ui.link{
                                 attr={id="btnSalvaPreview",class="button orange menuButton pulsantiWizard",style="float:left;margin-right: 35px;"},
                                 module = "wizard_private",
                                 view = "_save_preview",
                                 params = { 
                                                
                                           },
                                 content=function()
                                    
                                        ui.tag{
                                           tag = "p",
                                           attr={style="width: 150px; text-align: center; font-size: 22px; line-height: 20px;", readonly="true"},
                                           content        =_"Save preview",  
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
                             attr={id="btnSaveIssue",class="button orange menuButton pulsantiWizard",style="float:left;margin-right: 35px;",onclick="document.getElementById('wizardForm"..page.."').submit();"},
                             params = { 
                                                unit_id=app.session.member.unit_id,
                                                area_id=app.session.member.area_id,
                                                page=page 
                                           },
                             content=function()
                                
                                    ui.tag{
                                       tag = "p",
                                       attr={style="text-align: center; font-size: 22px; line-height: 20px; margin-top: 11px; width: 150px;", readonly="true"},
                                       content        =_"Save issue",  
                                       multiline=true
                                      
                                    }  
                                    
                                end-- fine tag.content
                        } -- fine pulsante next
              

                        ui.tag{
                                tag="div",
                                attr={style="text-align: center;height:120px; width: 100%; float: left; position: relative; "},
                                content=function()  
                                end
                                 }         
                    
                end
            
            }-- fine pulsanti container
          
ui.script{static = "js/jquery.equalheight.js"}
ui.script{script = '$(document).ready(function() { equalHeight($(".eq1")); $(window).resize(function() { equalHeight($(".eq1")); }); }); ' }
ui.script{static = "js/jquery.fittext.js"}
ui.script{script = "jQuery('.fittext').fitText(0.9, {minFontSize: '10px', maxFontSize: '28px'}); " }                    
