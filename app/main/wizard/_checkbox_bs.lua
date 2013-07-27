 local id_checkbox=param.get("id_checkbox")
 local label=param.get("label")
 local selected=param.get("selected")
 
 
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
 
ui.container{attr={class="row-fluid", onmousedown="doCheck("..id_checkbox..")"},content=function()
  ui.container{attr={class="span12"},content=function() 
    ui.container{attr={class="nowrap", style="margin: 1em;"},content=function() 
      ui.tag {
        tag="a",
        attr={id="policyChooser"..id_checkbox,class="btn btn-primary btn-large inline-block eq_btn1" ,style="height: 62px!important;width: 2em;float:left"},
        content=function()
         ui.heading{ level=4, attr = {class = "fittext_btn_wiz" }, content=function()
            ui.container{attr={class="row-fluid"},content=function()
              ui.container{attr={class="span12" },content=function()
              ui.image{ attr = {id="imgCheck"..id_checkbox, class="arrow_medium" ,style="display:"..display..";",onclick="doCheck("..id_checkbox..")"}, static="svg/V_checked.svg"}
            end }
          end }
        end }
      end --fine content
    } --fine tagA
    
   
    --label
    ui.container
    {
     attr={style="margin-top: 1em; float: left; margin-left:2em"},
     content=function()
     ui.heading{level=3,content= label}
     end
    } 
    
   end --fine container
 }
 
 
 
 end}
 end}
 
  
 
 
