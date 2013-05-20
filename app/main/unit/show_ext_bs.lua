slot.set_layout("m5s_bs")

local unit_id = param.get_id()
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

local return_view = "homepage"

if unit_name == "iscritti" then
  return_view = "index"
end

ui.container{ attr = { class  = "row-fluid" } , content = function()
  ui.container{ attr = { class  = "well span8 offset2" }, content = function()
    ui.container{ attr = { class  = "container-fluid" }, content = function()
      ui.container{ attr = { class  = "row-fluid" }, content = function()
        ui.container { attr = { class  = "span1" }, content = function()
          ui.container { attr = { class  = "btn-group" }, content = function()
            ui.link{
              attr = { id = "unit_button_back", class="btn btn-primary"  },
              module = "index",
              view = return_view,
              content = function()
                ui.tag{ tag ="i" , attr = { class = "icon-arrow-left" }, content=""}
                slot.put(_"BACK TO PREVIOUS PAGE")
              end
            }
          end }
        end }
      end }

    ui.tag { tag = "p", attr = { id = "unit_title", class  = "welcome_text_l"}, content = _(config.gui_preset[gui_preset].units[unit_name].assembly_title, {realname = member.realname}) }


    ui.tag { tag = "p", attr = { class  = "welcome_text_xl"}, content = _"CHOOSE THE THEMATIC AREA" }
 
    end }
  end }
end }

ui.container{ attr = { id="unit_img_box"}, content=function()
  ui.image{ attr = { id = "unit_parlamento_img" }, static = "parlamento_icon_small.png" }
end }

ui.container{ attr = { class="unit_bottom_box"}, content=function()
 
  ui.container{ attr = { class ="unit_button_box" }, content = function()
    ui.tag { tag = "p", attr = { class  = "block-text welcome_text_xl"  }, content = _(config.gui_preset[gui_preset].units[unit_name].unit_title) or _"THEMATIC AREAS" }
    ui.link { 
      attr = { id = "unit_button_left", class="button orange"  }, 
      module = "unit",
      view = "show_ext",
      id = unit_id,
      content = _"SHOW ALL AREAS" 
    }
    ui.link {
      attr = { id = "unit_button_right", class="button orange"  },
      module = "unit",
      view = "show_ext",
      id = unit_id,
      params = { filter = "my_areas"},
      content =  _"SHOW ONLY PARTECIPATED AREAS" 
    }
  end }
  
  ui.container{ attr = { class="unit_areas_box"}, content=function()
    execute.view{  
      module = "area",
      view = "_list_ext",
      params = { areas_selector = areas_selector, member = app.session.member }
    }
  end}

end}
