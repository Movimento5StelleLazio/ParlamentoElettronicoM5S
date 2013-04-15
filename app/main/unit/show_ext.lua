local unit_id = param.get("unit_id")
local unit_selector = param.get("unit_selector")
local areas_selector = param.get("areas_selector")
local filter_areas = param.get("filter_areas")

if not app.session.member_id then
  return false
end

local member = app.session.member

if not areas_selector then
  areas_selector = Area:build_selector{ active = true }
end 

if unit_id then
  areas_selector:add_where{ "area.unit_id = ?", unit_id }
  -- A single unit id was passed
elseif unit_selector then
  -- Decomment this if unit_selector was not executed on level 2
  -- units = unit_selector:exec()
  for i, unit in ipairs(units) do
--[[
    TODO: build an area_selector based on selected units
    The unit_selector must be built using the :add_field("id","unit_id", "grouped") function
    areas_selector:left_join( ?)
--]]
  end
else
  slot.put_into("error", "No unit_id or unit_selector was provided!")
  return false
end

areas_selector:add_order_by("member_weight DESC")

if filter_areas == "my_areas" then
  areas_selector:join("membership", nil, { "membership.area_id = area.id AND membership.member_id = ?", member.id })
else
  areas_selector:join("privilege", nil, { "privilege.unit_id = area.unit_id AND privilege.member_id = ? AND privilege.voting_right", member.id })
end

ui.container{ attr = { class  = "unit_header_box" }, content = function()
  ui.link { 
    attr = { id = "unit_button_back", class="button orange menuButton"  }, 
    module = "index",
    view = "homepage",
    content = function()
      ui.image{ attr = { id = "unit_arrow_back" }, static = "arrow_left.png" }
      ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"BACK TO PREVIOUS PAGE" }
    end
  }
  ui.tag { tag = "p", attr = { id = "unit_title", class  = "welcome_text_l"}, content = _("#{realname}, you are now in the Regione Lazio Assembly", {realname = member.realname}) }
  ui.tag { tag = "p", attr = { class  = "welcome_text_xl"}, content = _"CHOOSE THE THEMATIC AREA" }
end}

ui.image{ attr = { id = "unit_parlamento_img" }, static = "parlamento_icon_small.png" }

ui.container{ attr = { class="unit_bottom_box"}, content=function()
  -- Implementare la logica per mostrare la scritta corretta
  ui.tag { tag = "p", attr = { class  = "welcome_text_xl"  }, content = _"THEMATIC AREAS" }
  ui.link { 
    attr = { id = "unit_button_left", class="button orange menuButton"  }, 
    module = "unit",
    view = "show_ext",
    params = { unit_id = unit_id },
    content = function()
      ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"SHOW ALL AREAS" }
    end
  }
  ui.link {
    attr = { id = "unit_button_right", class="button orange menuButton"  },
    module = "unit",
    view = "show_ext",
    params = { unit_id = unit_id, filter_areas = "my_areas"},
--    params = { filter_areas = "my_areas"},
    content = function()
      ui.tag { tag = "p",  attr = { class  = "button_text"  }, content = _"SHOW ONLY PARTECIPATED AREAS" }
    end
  }
  
  ui.container{ attr = { class="unit_areas_box"}, content=function()
    execute.view{  
      module = "area",
      view = "_list",
      params = { areas_selector = areas_selector, member = app.session.member }
    }
  end}

end}
