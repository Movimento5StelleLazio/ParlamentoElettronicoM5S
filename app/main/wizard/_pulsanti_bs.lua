

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
    btnBackView = "homepage_bs"
    btnBackParams=nil
    
    else
    btnBackParams=previus_page
    btnBackModule ="wizard"
    btnBackView = "wizard_new_initiative_bs"
end


ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span3 text-center"},content=function()
    ui.link{
      attr={id="btnPreviuos",class="btn btn-primary btn-large table-cell eq_btn"},
      module = btnBackModule,
      view = btnBackView,
      params = {
        unit_id=app.session.member.unit_id,
        area_id=app.session.member.area_id,
        page=btnBackParams
      },
      content=function()
        ui.heading{ level=4, attr = {class = "fittext_btn_wiz" }, content=function()
          ui.container{attr={class="row-fluid"},content=function()
            ui.container{attr={class="span12"},content=function()
              slot.put(_"Back Phase")
            end }
          end }
          ui.container{attr={class="row-fluid"},content=function()
            ui.container{attr={class="span12"},content=function()
              ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
            end }
          end }
        end }
      end
    } 
  end }
  ui.container{attr={class="span3 offset6 text-center"},content=function()
  ui.tag{
      tag="a",
      attr={id="btnNext",class="btn btn-primary btn-large table-cell eq_btn",onclick="document.getElementById('wizardForm"..page.."').submit();"},
      module = "wizard",
      view = "wizard_new_initiative_bs",
      params = {
        unit_id=app.session.member.unit_id,
        area_id=app.session.member.area_id,
        page=next_page
      },
      content=function()
        ui.heading{ level=4, attr = {class = "fittext_btn_wiz" }, content=function()
          ui.container{attr={class="row-fluid"},content=function()
            ui.container{attr={class="span12"},content=function()
              slot.put(_"Next Phase")
            end }
          end }
          ui.container{attr={class="row-fluid"},content=function()
            ui.container{attr={class="span12"},content=function()
              ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-right.svg"}
            end }
          end }
        end }
      end
    }
  end }
  ui.script{static = "js/jquery.equalheight.js"}
  ui.script{script = '$(document).ready(function() { equalHeight($(".eq_btn")); $(window).resize(function() { equalHeight($(".eq_btn")); }); }); ' }
  ui.script{static = "js/jquery.fittext.js"}
  ui.script{script = "jQuery('.fittext_btn_wiz').fitText(1.0, {minFontSize: '12px', maxFontSize: '28px'}); " }
end }


--[[

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
          
                    
--]]
