

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


 ui.container{attr={class="row-fluid"},content=function()
   ui.container{attr={class="span3 text-center",style="width: 100%;"},content=function()

    --pulsanti
               
            ui.tag
            {
            tag="div",
                attr={id="pulsanti" , style="position: relative;"},
                content=function()
               
               ui.container{attr={class="row-fluid"},content=function()
                ui.container{attr={class="row-fluid"},content=function()
                  
                     ui.container{attr={class="span3 text-center",style="margin-left: 7em;" },content=function()
               --pulsante anteprima
                     ui.tag{
                                tag="div",
                                 attr={id="btnAnteprima",class="btn btn-primary btn-large table-cell eq_btn fixclick",disabled="true",style="opacity:0.5;float:left;height: 103px;"},
                                 module = "wizard_private",
                                 view = "anteprima",
                                 params = { 
                                                
                                           },
                                 content=function()
                                    ui.heading
                                      { 
                                      level=4, attr = {class = "fittext_btn_wiz" },
                                      content=function()
                                          ui.container
                                          {
                                            attr={class="row-fluid"},
                                            content=function()
                                                ui.container
                                                {
                                                attr={class="span12"},
                                                content=function()
                                                slot.put(_"Show preview"  )
                                                end 
                                                }
                                          end 
                                          }
                                          
                                       end
                                       } --fine heading
                                    end-- fine tag.content
                            } -- fine pulsante previuos
                        
                        end}    
                  
                    ui.container{attr={class="span3 text-center"},content=function()
                      ui.tag{  
                                 tag="div",
                                 attr={id="btnSalvaPreview",class="btn btn-primary btn-large table-cell eq_btn fixclick",disabled="true",style="opacity:0.5;float:left;height: 103px;"},
                                 module = "wizard_private",
                                 view = "_save_preview",
                                 params = { 
                                                
                                           },
                                 content=function()
                                     ui.heading
                                      { 
                                      level=4, attr = {class = "fittext_btn_wiz" },
                                      content=function()
                                          ui.container
                                          {
                                            attr={class="row-fluid"},
                                            content=function()
                                                ui.container
                                                {
                                                attr={class="span12"},
                                                content=function()
                                                slot.put(_"Save preview"  )
                                                end 
                                                }
                                          end 
                                          }
                                          
                                       end
                                       } --fine heading
                                          
                                        
                                    end-- fine tag.content
                            } -- fine pulsante previuos
                        end}    
                
                 
                   --pulsante Save
                    ui.container{attr={class="span3 text-center"},content=function()
                        ui.tag{
                                 tag="a",
                                 attr={id="btnSaveIssue",class="btn btn-primary btn-large table-cell eq_btn fixclick",style="float:left;cursor:pointer;height: 103px;",onclick="sendInitiative("..page..");"},
                                 params = { 
                                                    unit_id=app.session.member.unit_id,
                                                    area_id=app.session.member.area_id,
                                                    page=page 
                                               },
                                 content=function()
                                    
                                      ui.heading
                                      { 
                                      level=4, attr = {class = "fittext_btn_wiz" },
                                      content=function()
                                          ui.container
                                          {
                                            attr={class="row-fluid"},
                                            content=function()
                                                ui.container
                                                {
                                                attr={class="span12"},
                                                content=function()
                                                slot.put(_"Save issue"  )
                                                end 
                                                }
                                          end 
                                          }
                                          
                                       end
                                       } --fine heading
                                    end-- fine tag.content
                            } -- fine pulsante next
                  
                        end}
                    
                   
                end
            
            }-- fine pulsanti container
          
            end}
          end}
        
    end}
  end}            
  
ui.script{static = "js/jquery.equalheight.js"}
ui.script{script = '$(document).ready(function() { equalHeight($(".eq_btn")); $(window).resize(function() { equalHeight($(".eq_btn")); }); }); ' }
ui.script{static = "js/jquery.fittext.js"}
ui.script{script = "jQuery('.fittext').fitText(0.9, {minFontSize: '10px', maxFontSize: '28px'}); " }
