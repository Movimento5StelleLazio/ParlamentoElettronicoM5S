  ui.container{ attr = {  class = "row-fluid" }, content = function ()
    ui.container{ attr = { class="span2 reg_txt"}, content=function()
      ui.image{attr = { id="m5s_logo", class="inline-block"}, static="svg/logo_movimento5stelle.svg" }
    end }
    ui.container{ attr = { class="span7 text-right reg_txt"}, content=function()
      ui.container{ attr = { class="vtable"}, content=function()
        ui.heading{ attr = {class="uppercase table-cell"}, level=2, content=function()
          slot.put(_"Are you a Lazio citizen and you want to register? Here's how to do:")
          ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-right.svg"}
        end }
      end }
    end }
    ui.container{ attr = { class="span3 text-right reg_txt"}, content=function()
      ui.container{ attr = { class="vtable"}, content=function()
        ui.container{ attr = { class="table-cell"}, content=function()
          ui.link{
            attr = {class="btn btn-primary btn-large medium_btn fixclick"},
            module = "index",
            view = "register",
            content = function()
              ui.heading{ level=4, attr = {class="fittext_register"}, content= _"Registration Guide" }
            end
          }
        end }
      end }
    end }
  end }
  ui.script{static = "js/jquery.fittext.js"}
  ui.script{script = "jQuery('.fittext_register').fitText(0.7, {minFontSize: '18px', maxFontSize: '28px'}); " }
  ui.script{static = "js/jquery.equalheight.js"}
  ui.script{script = '$(document).ready(function() { equalHeight($(".reg_txt")); $(window).resize(function() { equalHeight($(".reg_txt")); }); }); ' }

