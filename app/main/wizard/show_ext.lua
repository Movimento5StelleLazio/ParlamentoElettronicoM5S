local unit_id = param.get_id()
local filter = param.get("filter")

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
for i,v in pairs(config.gui_preset.M5S.units) do
  if config.gui_preset.M5S.units[i].unit_id == unit_id then unit_name = i end
end

if not unit_name then
  slot.put_into("error", "Cannot find unit_id in configuration!")
  return false
end

local return_view = "homepage"

if unit_name == "iscritti" then
  return_view = "index"
end

ui.container{ attr = { class  = "unit_header_box" }, content = function()
  ui.link { 
    attr = { id = "unit_button_back", class="button orange menuButton"  }, 
    module = "index",
    view = return_view,
    content = function()
      ui.image{ attr = { id = "unit_arrow_back" }, static = "arrow_left.png" }
      ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"BACK TO PREVIOUS PAGE" }
    end
  }
  ui.tag { tag = "p", attr = { id = "unit_title", class  = "welcome_text_l"}, content = _(config.gui_preset.M5S.units[unit_name].assembly_title, {realname = member.realname}) }
  ui.tag { tag = "p", attr = { class  = "welcome_text_xl"}, content = _"CHOOSE THE THEMATIC AREA" }
end}

ui.container{ attr = { id="unit_img_box"}, content=function()
  ui.image{ attr = { id = "unit_parlamento_img" }, static = "parlamento_icon_small.png" }
end }

ui.container{ attr = { class="unit_bottom_box"}, content=function()
 
  ui.container{ attr = { class ="unit_button_box" }, content = function()
    ui.tag { tag = "p", attr = { class  = "block-text welcome_text_xl"  }, content = _(config.gui_preset.M5S.units[unit_name].unit_title) or _"THEMATIC AREAS" }
    ui.link { 
      attr = { id = "unit_button_left", class="button orange"  }, 
      module = "wizard",
      view = "show_ext",
      id = unit_id,
      content = _"SHOW ALL AREAS" 
    }
    ui.link {
      attr = { id = "unit_button_right", class="button orange"  },
      module = "wizard",
      view = "show_ext",
      id = unit_id,
      params = { filter = "my_areas"},
      content =  _"SHOW ONLY PARTECIPATED AREAS" 
    }
  end }
  
  ui.container{ attr = { class="unit_areas_box"}, content=function()
    execute.view{  
      module = "wizard",
      view = "_list_ext",
      params = { areas_selector = areas_selector, member = app.session.member }
    }
  end}

end}
