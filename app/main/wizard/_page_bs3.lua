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
    ui.heading{level=4,content=  _"Give a description to the problem you want to solve"}
  end }
end }
                                       
ui.container{attr={class="row-fluid",style="padding-top: 2em;"},content=function()
ui.container{attr={class="span12 text-center"},content=function()
            --------------------------------------------------------      
            --contenuto specifico della pagina wizard    
             ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page,style="height:100%"},
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
                      
                        ui.container{attr={class="span2 text-center"},content=function()
                        end}
                        ui.container{attr={class="span8 text-center"},content=function()
                        
                          ui.container{attr={class="row-fluid"},content=function()
                              
                             ui.container{attr={class="span12 "},content=function()
                             
                                 ui.container{attr={class="row-fluid"},content=function()
                                 
                                      ui.container{attr={class="span12 "},content=function()
                                          
                                           --contenuto
                                           ui.tag{
                                               tag="div",
                                               attr={style="row-fluid"},
                                               content=function()  
                                               
                                                   
                                                   ui.container{attr={class="span12 text-center"},content=function()
                                                        ui.container
                                                        {
                                                            attr={style="width: 10em; position: relative; float: left;"},
                                                            content=function()
                                                             ui.tag{
                                                                tag="p",
                                                                attr={style="text-align: right; float: right; font-size: 20px;"},
                                                                content=  _"Description to the problem you want to solve"
                                                              }   
                                                            
                                                             ui.tag{
                                                                tag="p",
                                                                attr={style="float: left; position: relative; text-align: right;  font-style: italic;font-size:15px;"},
                                                                content=  _"Description note"
                                                              }   
                                                              
                                                            end
                                                            
                                                         } 
                                               
                                                         ui.tag
                                                               {
                                                                    tag="textarea",
                                                                    attr={id="issue_brief_description",name="issue_brief_description",style="resize: none;float: left; font-size: 23px; height: 22em; margin-left: 15px; width: 59%;"},
                                                                   
                                                                    content=function()
                                                                    end
                                                                    
                                                               }
                                                               
                                                    end}
                                                   
                                                end} --fine tag div
                                              
                                              
                                              end}  
                                       end}
                                
                                 end}
                                end}
                                
                              
                            
                             end}   
                             ui.container{attr={class="span2 text-center"},content=function()
                             end}  
                           
                           end --fine contenuto
                   }--fine form
            --------------------------------------------------------
   end }
end }

 

ui.container{attr={class="row-fluid btn_box_bottom"},content=function()
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
