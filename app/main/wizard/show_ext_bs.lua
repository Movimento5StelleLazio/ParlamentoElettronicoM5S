slot.set_layout("custom")

local unit_id = param.get_id()
trace.debug("unit_id="..unit_id)
local filter = param.get("filter")
local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1] or 'default'

if not app.session.member_id then
  return false
end

local member = app.session.member
areas_selector = Area:build_selector{ active = true }
areas_selector:add_order_by("member_weight DESC")

if filter == "my_areas" then
  areas_selector:join("membership", nil, { "membership.area_id = area.id AND membership.member_id = ?", member.id })
else
  areas_selector:join("privilege", nil, { "privilege.unit_id = area.unit_id AND privilege.member_id = ? AND privilege.voting_right", member.id })
end

if unit_id then
  trace.debug("unit_id="..unit_id)
  areas_selector:add_where{ "area.unit_id = ?", unit_id }
else
  slot.put_into("error", "No unit_id was provided!")
  return false
end

local unit_name
for i,v in pairs(config.gui_preset[gui_preset].units) do
  if config.gui_preset[gui_preset].units[i].unit_id == unit_id then unit_name = i end
end

if not unit_name then
  slot.put_into("error", "Cannot find unit_id in configuration!")
  return false
end

local return_view = "homepage_bs"

if unit_name == "iscritti" then
  return_view = "index"
end

ui.container{ attr = { class  = "row-fluid" } , content = function()
  ui.container{ attr = { class  = "well span12" }, content = function()
    ui.container{ attr = { class  = "row-fluid" }, content = function()
      ui.container{ attr = { class  = "span3 offset1" }, content = function()
        ui.link{
          attr = { class="btn btn-primary btn-large"  },
          module = "index",
          view = return_view,
          content = function()
            ui.heading{level=3,attr={class="fittext_back_btn"},content=function()
              ui.image{ attr = { class="text-center"}, static="svg/back_page.svg"}
              --slot.put(_"Back to previous page")
            end }
          end
        }
      end }
      ui.container{ attr = { class  = "span7 text-center" }, content = function()
        ui.container{ attr = { class  = "row-fluid" }, content = function()
          ui.container{ attr = { class  = "span12 text-center" }, content = function()
            ui.heading{level=1,attr={class="fittext0"},content=_(config.gui_preset[gui_preset].units[unit_name].assembly_title, {realname = member.realname})}
          end }
        
        end }
        ui.container{ attr = { class  = "row-fluid spaceline3" }, content = function()
          ui.container{ attr = { class  = "span12 text-center" }, content = function()
            ui.heading{level=2,attr={class="fittext0"},content=_"CHOOSE THE THEMATIC AREA"}
          end }
        end }
      end }
    end }
  end }
end }

ui.container{ attr = { class="row-fluid text-center"}, content=function()
  ui.container{ attr = { class="span4 offset4 text-center"}, content=function()
    ui.image{ static = "parlamento_icon_small.png" }
  end }
end }

btn_class = "btn btn-primary"
btn_class_active = "btn btn-primary active"
btn1, btn2 = btn_class,btn_class
if filter == "my_areas" then
  btn2=btn_class_active
else
  btn1=btn_class_active
end
  

ui.container{ attr = { class="row-fluid"}, content=function()
  ui.container{ attr = { class ="span12 well" }, content = function()
    ui.container{ attr = { class ="row-fluid" }, content = function()
      ui.tag { 
        tag = "h3", 
        attr = { class  = "span12 text-center"  }, 
        content = _(config.gui_preset[gui_preset].units[unit_name].unit_title) or _"THEMATIC AREAS" 
      }
    end }
    ui.container{ attr = { class ="row-fluid" }, content = function()
      ui.container{attr={class="span3 offset2"},content=function()
        ui.link { 
          attr = { class=btn1  }, 
          module = "wizard",
          view = "show_ext_bs",
          id = unit_id,
          content = function()
ui.image{ attr = { class="text-center"}, static="svg/button_wizard_1.svg"}
           -- ui.heading{level=3, attr={class="fittext1"}, content= _"SHOW ALL AREAS"}
          end 
        }
      end }
      ui.container{attr={class="span3 offset2"},content=function()
        ui.link {
          attr = { class=btn2  },
          module = "wizard",
          view = "show_ext_bs",
          id = unit_id,
          params = { filter = "my_areas"},
          content = function()
ui.image{ attr = { class="text-center"}, static="svg/button_wizard_2.svg"}
            --ui.heading{level=3, attr={class="fittext1"}, content= _"SHOW ONLY PARTECIPATED AREAS"}
          end 
        }
      end }
    end }
    ui.container{ attr = { class="row-fluid"}, content=function() 
      ui.container{ attr = { class ="span2" }, content = ""}
    end }
    
   
    ui.container{ attr = { class="row-fluid"}, content=function()
      execute.view{  
        module = "wizard",
        view = "_list_ext_bs",
        params = { areas_selector = areas_selector, member = app.session.member }
      }
    end }
  end }
end}

ui.script{static = "js/jquery.equalheight.js"}
ui.script{script = '$(document).ready(function() { equalHeight($(".eq1")); $(window).resize(function() { equalHeight($(".eq1")); }); }); ' }
ui.script{static = "js/jquery.fittext.js"}
ui.script{script = "jQuery('.fittext0').fitText(1.0, {minFontSize: '24px', maxFontSize: '32px'}); " }
ui.script{script = "jQuery('.fittext1').fitText(1.3, {minFontSize: '24px', maxFontSize: '32px'}); " }
ui.script{script = "jQuery('.fittext_back_btn').fitText(1.1, {minFontSize: '17px', maxFontSize: '32px'}); " }


