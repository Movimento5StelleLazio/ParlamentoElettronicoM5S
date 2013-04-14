local unit_id = param.get_id()
local unit = Unit:by_id(unit_id)

if not app.session.member_id then
  return false
end

local member = app.session.member

local areas_selector = Area:build_selector{ active = true, unit_id = unit_id }
areas_selector:add_order_by("member_weight DESC")

local members_selector = Member:build_selector{
  active = true,
  voting_right_for_unit_id = unit.id
}

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
  ui.link { attr = { id = "unit_button_left", class="button orange menuButton"  }, content = function()
    ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"SHOW ALL AREAS" }
  end}
  ui.link { attr = { id = "unit_button_right", class="button orange menuButton"  }, content = function()
    ui.tag { tag = "p",  attr = { class  = "button_text"  }, content = _"SHOW ONLY PARTECIPATED AREAS" }
  end}
  
  ui.container{ attr = { class="unit_areas_box"}, content=function()
    execute.view{  
      module = "area",
      view = "_list",
      params = { areas_selector = areas_selector, member = app.session.member }
    }
  end}

end}
