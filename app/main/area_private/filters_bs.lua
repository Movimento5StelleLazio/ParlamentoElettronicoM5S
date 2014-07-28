slot.set_layout("custom")

local create = param.get("create", atom.boolean)
local area = Area:by_id(param.get_id())

if not area then
  slot.put_into("error", "Please provide a valid area id")
  return false
end

app.html_title.title = area.name
app.html_title.subtitle = _("Area")

util.help("area.show")

ui.container{ attr = { class  = "row-fluid" }, content = function()
  ui.container{ attr = { class  = "span12 well" }, content = function()
    ui.container{ attr = { class  = "row-fluid text-center" }, content = function()
      ui.tag { tag = "h4", attr = {class = "span12"},  content = _("#{realname}, you are now in the Regione Lazio Internal Assembly", {realname = (app.session.member.realname ~= "" and app.session.member.realname or app.session.member.login)}) }
    end }
    ui.container{ attr = { class  = "row-fluid text-center" }, content = function()
      ui.tag { tag = "h3",attr = {class = "span12"}, content = _("CHOOSE THE MEMBERS INITIATIVES YOU WANT TO READ:") }
    end }
    ui.container{ attr = { class  = "row-fluid btn_box_top  btn_box_bottom" }, content = function()
      ui.container{attr={class="span3", style=spanstyle},content = function()
        ui.link {
          attr = { class="btn btn-primary btn-large large_btn table-cell eq1 fixclick" },
          module = "unit_private",
          view = "show_ext_bs",
          id = area.unit_id,
          params = { filter = "my_areas" },
          content = function()
            ui.heading{level=3,attr={class="fittext"},content=function()
              ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
              slot.put(_"Back to previous page")
            end }
          end
        }
      end }
      ui.container{attr={class="span3"},content = function()
        ui.link {
		  attr = { class="btn btn-primary btn-large large_btn table-cell eq1 fixclick" },
		  module = "area_private",
		  view = "show_ext_bs",
		  params = { state = "admission"},
		  id = area.id,
		  content = function()
		    ui.heading{level=3, attr={class="fittext"},content=_"INITIATIVES LOOKING FOR SUPPORTERS"}
		  end 
		}
      end }
      ui.container{attr={class="span3"},content = function()
        ui.link {
          attr = { class="btn btn-primary btn-large large_btn table-cell eq1 fixclick" },
          module = "area_private",
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
          module = "area_private",
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
end }
