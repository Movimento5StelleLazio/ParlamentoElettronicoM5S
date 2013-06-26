 
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

ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
    ui.heading{level=3,content= _"FASE "..page }
    ui.heading{level=4,content=  _"Target description title" }
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
                        view = 'wizard_new_initiative_bs',
                        params={
                                area_id=area_id,
                                unit_id=unit_id,
                                page=page
                        },
                        routing = {
                            ok = {
                              mode   = 'redirect',
                              module = 'wizard',
                              view = 'wizard_new_initiative_bs',
                              params = {
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                          },
                            },
                            error = {
                              mode   = '',
                              module = 'wizard',
                              view = 'wizard_new_initiative_bs',
                            }
                          }, 
                       content=function()
                     
                          --parametri in uscita
                           ui.hidden_field{name="indietro" ,value=false}
                           for i,k in ipairs(wizard) do
                              ui.hidden_field{name=k.name ,value=k.value}
                              trace.debug("[wizard] name="..k.name.." | value="..k.value)
                            end
                        
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
                                                attr={id="aim_description",name="aim_description",style="resize: none;float: left; font-size: 23px; height: 228px; margin-left: 15px; width: 598px;"},
                                                content=function()
                                                end
                                                
                                           }
                                    end
                                }
                           end --fine contenuto
 
                        
                   }--fine form
            --------------------------------------------------------
  
  end }
end }


 

ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
    execute.view{
      module="wizard",
      view="_pulsanti_bs",
      params={
        btnBackModule = "wizard",
        btnBackView = "wizard_new_initiative_bs",
        page=page
      }
    }
  end }
end }
