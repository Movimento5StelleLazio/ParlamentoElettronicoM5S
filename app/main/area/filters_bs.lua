slot.set_layout("custom")

local area = Area:by_id(param.get_id())
local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1] or 'default'

if not area then
  slot.put_into("error", "Please provide a valid area id")
  return false
end

app.html_title.title = area.name
app.html_title.subtitle = _("Area")

util.help("area.show")

local unit_name
if config.gui_preset[gui_preset].units.type_id == 1 then
	unit_name = "eletti"
else
	unit_name = "cittadini"
end
	
--[[for i,v in pairs(config.gui_preset[gui_preset].units) do
  if config.gui_preset[gui_preset].units[i].type_id == area.unit_id then unit_name = i end
end
 
if not config.gui_preset[gui_preset].units[unit_name] then
  --slot.put_into("error", "unit_id for selected area is not configured in config.gui_preset")
  --return false
  unit_name = "cittadini"
end]]

local spanstyle
if unit_name == "cittadini" or unit_name == "iscritti" then
  spanstyle =""
else
  spanstyle="margin-left: 12.5%"
end

ui.container{ attr = { class  = "row-fluid" }, content = function()
  ui.container{ attr = { class  = "span12 well" }, content = function()
    ui.container{ attr = { class  = "row-fluid text-center" }, content = function()
      ui.tag { tag = "h4", attr = {class = "span12"},  content = _(config.gui_preset[gui_preset].units[unit_name].assembly_title, {realname = app.session.member.realname}) }
    end }
    ui.container{ attr = { class  = "row-fluid text-center" }, content = function()
      ui.tag { tag = "h3",attr = {class = "span12"}, content = _(config.gui_preset[gui_preset].units[unit_name].area_filter_title) }
    end }
    ui.container{ attr = { class  = "row-fluid btn_box_top  btn_box_bottom" }, content = function()
      ui.container{attr={class="span3", style=spanstyle},content = function()
        ui.link {
          attr = { class="btn btn-primary btn-large large_btn table-cell eq1 fixclick" },
          module = "unit",
          view = "show_ext_bs",
          id = area.unit_id,
          content = function()
            ui.heading{level=3,attr={class="fittext"},content=function()
              ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
              slot.put(_"Back to previous page")
            end }
          end
        }
      end }
      if unit_name == "cittadini" or unit_name == "iscritti" then
        ui.container{attr={class="span3"},content = function()
          ui.link {
            attr = { class="btn btn-primary btn-large large_btn table-cell eq1 fixclick" },
            module = "area",
            view = "show_ext_bs",
            params = { state = "admission"},
            id = area.id,
            content = function()
              ui.heading{level=3, attr={class="fittext"},content=_"INITIATIVES LOOKING FOR SUPPORTERS"}
            end 
        }
        end }
      end
      ui.container{attr={class="span3"},content = function()
        ui.link {
          attr = { class="btn btn-primary btn-large large_btn table-cell eq1 fixclick" },
          module = "area",
          view = "show_ext_bs",
          params = { state = "development"},
          id = area.id,
          content = function()
            ui.heading{level=3, attr={class="fittext"},content=_"INITIATIVES NOW IN DISCUSSION"}
          end 
        }
      end }
      ui.container{attr={class="span3"},content = function()
        ui.link {
          attr = { class="btn btn-primary btn-large large_btn table-cell eq1 fixclick" },
          module = "area",
          view = "show_ext_bs",
          params = { state = "closed"},
          id = area.id,
          content = function()
            ui.heading{level=3, attr={class="fittext"},content=_"COMPLETED OR RETIRED INITIATIVES"}
          end 
        }
      end }
     end
    }
  
  end }
  ui.script{static = "js/jquery.equalheight.js"}
  ui.script{script = '$(document).ready(function() { equalHeight($(".eq1")); $(window).resize(function() { equalHeight($(".eq1")); }); }); ' }
  ui.script{static = "js/jquery.fittext.js"}
  ui.script{script = "jQuery('.fittext').fitText(); " }

end }
