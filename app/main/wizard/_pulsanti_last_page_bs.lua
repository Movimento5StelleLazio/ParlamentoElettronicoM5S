

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


 ui.container{attr={class="row-fluid"},content=function()
   ui.container{attr={class="span3 text-center",style="width: 100%;"},content=function()

    --pulsanti
               
            ui.tag
            {
            tag="div",
                attr={id="pulsanti" },
                content=function()
               
               ui.container{attr={class="row-fluid"},content=function()
                  
                     ui.container{attr={class="span3 offset1 text-center"},content=function()
               --pulsante anteprima
                     ui.tag{
                                tag="div",
                                 attr={id="btnAnteprima",class="btn btn-primary btn-large large_btn",disabled="true"},
                                 module = "wizard",
                                 view = "anteprima",
                                 params = { 
                                                
                                           },
                                 content=function()
                                    ui.heading
                                      { 
                                      level=4, 
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
                                 attr={id="btnSalvaPreview",class="btn btn-primary btn-large large_btn fixclick",disabled="true" },
                                 module = "wizard",
                                 view = "_save_preview",
                                 params = { 
                                                
                                           },
                                 content=function()
                                     ui.heading
                                      { 
                                      level=4,
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
                                 attr={id="btnSaveIssue",class="btn btn-primary btn-large large_btn fixclick" ,onclick="sendInitiative("..page..");"},
                                 params = { 
                                                    unit_id=app.session.member.unit_id,
                                                    area_id=app.session.member.area_id,
                                                    page=page 
                                               },
                                 content=function()
                                    
                                      ui.heading
                                      { 
                                      level=4,
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
           
