  ui.container{ attr = {  class = "row-fluid" }, content = function ()
    ui.container{ attr = { class="span2"}, content=function()
      ui.image{static="simbolo_movimento.png" }
    end }
    ui.container{ attr = { class="span7 text-right"}, content=function()
      ui.heading{ attr = {class="uppercase"}, level=2, content=function()
        slot.put(_"Are you a Lazio citizen and you want to register? Here's how to do:")
        ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-right.svg"}
      end }
    end }
    ui.container{ attr = { class="span3 text-center"}, content=function()
      ui.link{
        attr = {class="btn btn-primary btn-large medium_btn table-cell"},
        module = "index",
        view = "register",
        content = function()
          ui.heading{ level=4, attr = {class="fittext_register"}, content= _"Registration Guide" }
        end
      }
    end }
  end }
  ui.script{static = "js/jquery.fittext.js"}
  ui.script{script = "jQuery('.fittext_register').fitText(0.7, {minFontSize: '18px', maxFontSize: '28px'}); " }
