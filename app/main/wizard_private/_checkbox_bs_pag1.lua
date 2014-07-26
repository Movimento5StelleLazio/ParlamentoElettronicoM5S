 local id_checkbox=param.get("id_checkbox", atom.string)
 local label=param.get("label", atom.string)
 local selected=param.get("selected", atom.boolean)
 local imgId=param.get("imgId", atom.string)
 
 
 local display = "none"
 
 if selected then
 	display="block"
 end
 
ui.container{attr={class="row-fluid", onmousedown="doCheckPag1("..id_checkbox..","..imgId..")"},content=function()
  ui.container{attr={class="span12"},content=function() 
    ui.container{attr={class="nowrap", style="margin: 1em;"},content=function() 
      ui.tag {
        tag="a",
        attr={id="policyChooser"..id_checkbox,class="btn btn-primary btn-large inline-block eq_btn1" ,style="height: 62px!important;width: 2em;"},
        content=function()
         ui.heading{ level=4, attr = {class = "fittext_btn_wiz" }, content=function()
            ui.container{attr={class="row-fluid"},content=function()
              ui.container{attr={class="span12" },content=function()
                ui.image{ attr = {id="imgCheck"..imgId, class="arrow_medium" ,style="display:"..display..";"}, static="svg/V_checked.svg"}
              end }
            end }
          end }
           end  }
       ui.heading{level=3,attr = {class="policy_chooser_txt inline-block"}, content= label}
      
      
    end }
  end }
end }
 
  
 
 
