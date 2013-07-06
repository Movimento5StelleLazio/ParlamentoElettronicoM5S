 local id_checkbox=param.get("id_checkbox")
 local label=param.get("label")
 local selected=param.get("selected")
 
 
 local imgId=param.get("imgId")
 
 local display
 
 
 if selected then
     
     if selected=="true" then
         display="block"
         else
         display="none"
     end
     
     else
         display="none"
     
 end
 
ui.container{attr={class="row-fluid", onclick="doCheckPag1("..id_checkbox..","..imgId..")"},content=function()
  ui.container{attr={class="span12"},content=function() 
    ui.container{attr={class="policy_chooser_box nowrap"},content=function() 
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
end}
 
  
 
 
