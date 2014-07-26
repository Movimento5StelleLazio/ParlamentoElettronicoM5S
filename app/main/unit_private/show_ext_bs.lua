slot.set_layout("custom")

local type_id = param.get_id()
local filter = param.get("filter") or "my_areas"
--local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1] or 'default'
local wizard = param.get("wizard", boolean)

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

areas_selector:join("unit", nil, "unit.id = area.unit_id AND unit.name LIKE '%ASSEMBLEA INTERNA%' ")

local unit_name = "iscritti"
--[[for i,v in pairs(config.gui_preset[gui_preset].units) do
  trace.debug('unit_id '..type_id..' type_id '..config.gui_preset[gui_preset].units[i].type_id)
  if config.gui_preset[gui_preset].units[i].type_id == type_id then unit_name = i end
end]]

if not unit_name then
  slot.put_into("error", "Cannot find type_id in configuration!")
  return false
end

ui.container{ attr = { class  = "row-fluid spaceline" } , content = function()
  ui.container{ attr = { class  = "well span12" }, content = function()
    ui.container{ attr = { class  = "row-fluid" }, content = function()
      ui.container{ attr = { class  = "span3" }, content = function()
        ui.link{
          attr = { class="btn btn-primary btn-large large_btn"  },
          module = "index",
          view = "homepage_private_bs",
          content = function()
            ui.heading{level=3, content=function()
              ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
              slot.put(_"Back to previous page")
            end }
          end
        }
      end }
      ui.container{ attr = { class  = "span9 text-center" }, content = function()
        ui.container{ attr = { class  = "row-fluid" }, content = function()
          ui.container{ attr = { class  = "span12 text-center" }, content = function()
            ui.heading{level=1,content=_(config.gui_preset["custom"].units["iscritti"].assembly_title, {realname = member.realname})}
          end }
        end }
        ui.container{ attr = { class  = "row-fluid" }, content = function()
          ui.container{ attr = { class  = "span12 text-center" }, content = function()
            ui.heading{level=2, content=_"CHOOSE THE THEMATIC AREA"}
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

btn_class = "btn btn-primary btn-large large_btn"
btn_class_active = "btn btn-primary btn-large active large_btn"
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
        content = _(config.gui_preset["custom"].units["iscritti"].unit_title) or _"THEMATIC AREAS" 
      }
    end }
    ui.container{ attr = { class ="row-fluid text-center" }, content = function()
      ui.container{attr={class="span6"},content=function()
        ui.link { 
          attr = { class=btn1  }, 
          module = "unit_private",
          view = "show_ext_bs",
          id = type_id,					
          params = { wizard = wizard },
          content = function()
            ui.heading{level=3, content= _"SHOW ALL AREAS"}
          end 
        }
      end }
      ui.container{attr={class="span6"},content=function()
        ui.link {
          attr = { class=btn2  },
          module = "unit_private",
          view = "show_ext_bs",
          id = type_id,		
          params = { filter = "my_areas", wizard = wizard },
          content = function()
            ui.heading{level=3, content= _"SHOW ONLY PARTECIPATED AREAS"}
          end 
        }
      end }
    end }
    if wizard then
		  ui.container{ attr = { class="row-fluid spaceline"}, content=function()
		    ui.container{ attr = { class = "span12 spaceline" }, content = function()
		      execute.view{  
		        module = "area_private",
		        view = "_list_ext_bs",
		        params = { areas_selector = areas_selector, member = app.session.member, wizard = wizard }
		      }
		    end }
		  end }
		else
			ui.container{ attr = { class="row-fluid spaceline"}, content=function()
		    ui.container{ attr = { class = "span12 spaceline" }, content = function()
		      execute.view{  
		        module = "area_private",
		        view = "_list_ext_bs",
		        params = { areas_selector = areas_selector, member = app.session.member }
		      }
		    end }
		  end }
		end
  end }
end}

ui.script{static = "js/jquery.equalheight.js"}
ui.script{script = '$(document).ready(function() { equalHeight($(".eq1")); $(window).resize(function() { equalHeight($(".eq1")); }); }); ' }
ui.script{static = "js/jquery.fittext.js"}
ui.script{script = "jQuery('.fittext0').fitText(1.0, {minFontSize: '24px', maxFontSize: '32px'}); " }
ui.script{script = "jQuery('.fittext1').fitText(1.3, {minFontSize: '24px', maxFontSize: '32px'}); " }
ui.script{script = "jQuery('.fittext_back_btn').fitText(1.1, {minFontSize: '17px', maxFontSize: '32px'}); " }


