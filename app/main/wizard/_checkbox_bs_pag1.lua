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
 
ui.container{attr={class="row-fluid", style="width:34em;height: 5em;",onclick="doCheckPag1("..id_checkbox..","..imgId..")"},content=function()
ui.container{attr={class="span12"},content=function() 
 ui.container
 {
    attr={class="span3 text-center;",style="width: 6em;"},
    content=function()
    ui.tag
    {
      tag="a",
      attr={id="policyChooser"..id_checkbox,class="btn btn-primary btn-large table-cell eq_btn1" ,style="height: 62px!important;width: 2em;"},
      content=function()
        ui.heading{ level=4, attr = {class = "fittext_btn_wiz" }, content=function()
         
          ui.container{attr={class="row-fluid"},content=function()
            ui.container{attr={class="span12" },content=function()
              ui.image{ attr = {id="imgCheck"..imgId, class="arrow_medium" ,style="display:"..display..";"}, static="svg/V_checked.svg"}
            end }
          end }
        end }
      end --fine content
    } --fine tagA
    
   end --fine container
 }
 
 
  --label
    ui.container
    {
     attr={style="margin-top: 1em; float: left; cursor:pointer"},
     content=function()
     ui.heading{level=3,content= label}
     end
    }
 end
 }
 end}
 
  
 
 