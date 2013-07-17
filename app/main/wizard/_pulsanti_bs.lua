

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

if page==1 then

ui.container{attr={class="row-fluid span10 offset1"},content=function()
  ui.container{attr={class="span3 text-center"},content=function()
    trace.debug("renmdering button <<")
  ui.link{
          attr={id="btnPreviuos",class="btn btn-primary btn-large table-cell eq_btn fixclick"},
          module = "wizard",
          view = "show_ext_bs",
          id=app.session.member.unit_id,
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
                        slot.put(_"Back Phase")
                        end 
                        }
                  end 
                  }
                  ui.container{attr={class="row-fluid"},content=function()
                    ui.container{attr={class="span12"},content=function()
                      ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
                    end }
                  end }
               end
               } --fine heading
            end
            } -- fine link

  end }
  ui.container{attr={class="span3 offset6 text-center"},content=function()
  ui.tag{
      tag="a",
      attr={id="btnNext",class="btn btn-primary btn-large table-cell eq_btn",onmousedown="if ( event.which != 1 ) { return; };document.getElementById('wizardForm"..page.."').submit();"},
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
 
end }

else

ui.container{attr={class="row-fluid span10 offset1"},content=function()
  ui.container{attr={class="span3 text-center"},content=function()
    ui.tag{
      tag="a",
      attr={id="btnPreviuos",class="btn btn-primary btn-large table-cell eq_btn",onmousedown="if ( event.which != 1 ) { return; };document.getElementsByName('indietro')[0].value=true;document.getElementById('wizardForm"..page.."').submit();"},
      module = btnBackModule,
      view = btnBackView,
      params = {
        unit_id=app.session.member.unit_id,
        area_id=app.session.member.area_id,
        page=previus_page,
        indietro=true
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
      attr={id="btnNext",class="btn btn-primary btn-large table-cell eq_btn",onmousedown="if ( event.which != 1 ) { return; };document.getElementById('wizardForm"..page.."').submit();"},
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
 
end }

end --fine if

ui.script{static = "js/jquery.equalheight.js"}
ui.script{script = '$(document).ready(function() { equalHeight($(".eq_btn")); $(window).resize(function() { equalHeight($(".eq_btn")); }); }); ' }
ui.script{static = "js/jquery.fittext.js"}
ui.script{script = "jQuery('.fittext_btn_wiz').fitText(1.0, {minFontSize: '12px', maxFontSize: '28px'}); " }


