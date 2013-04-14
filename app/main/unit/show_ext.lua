local unit_id = param.get_id()
local unit = Unit:by_id(unit_id)
local filter_areas = param.get("filter_areas")

if not app.session.member_id then
  return false
end

local member = app.session.member

local areas_selector = Area:build_selector{ active = true, unit_id = unit_id }
areas_selector:add_order_by("member_weight DESC")

if filter_areas == "my_areas" then
  areas_selector:join("membership", nil, { "membership.area_id = area.id AND membership.member_id = ?", member.id })
else
  areas_selector:join("privilege", nil, { "privilege.unit_id = area.unit_id AND privilege.member_id = ? AND privilege.voting_right", member.id })
end

ui.container{ attr = { class  = "unit_header_box" }, content = function()
  ui.link { attr = { id = "unit_button_back", class="button orange menuButton"  }, content = function()
    ui.image{ attr = { id = "unit_arrow_back" }, static = "arrow_left.png" }
    ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"BACK TO PREVIOUS PAGE" }
  end}
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
    content = function()
      ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"SHOW ALL AREAS" }
    end
  }
  ui.link {
    attr = { id = "unit_button_right", class="button orange menuButton"  },
    module = "unit",
    view = "show_ext",
    params = { filter_areas = "my_areas"},
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
