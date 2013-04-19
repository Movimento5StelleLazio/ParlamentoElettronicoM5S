local area = Area:by_id(param.get_id())

if not area then
  slot.put_into("error", "Please provide a valid area id")
  return false
end

app.html_title.title = area.name
app.html_title.subtitle = _("Area")

util.help("area.show")

local unit_name
for i,v in pairs(config.gui_preset.M5S.units) do
  if config.gui_preset.M5S.units[i].unit_id == area.unit_id then unit_name = i end
end
 
if not config.gui_preset.M5S.units[unit_name] then
  slot.put_into("error", "unit_id for selected area is not configured in config.gui_preset")
  return false
end


ui.container{ attr = { class  = "area_filter_header_box" }, content = function()
  ui.tag { tag = "p", attr = { id = "unit_title", class  = "welcome_text_l"}, content = _(config.gui_preset.M5S.units[unit_name].assembly_title, {realname = app.session.member.realname}) }
  ui.tag { tag = "p", attr = { class  = "welcome_text_xl"}, content = _(config.gui_preset.M5S.units[unit_name].area_filter_title) }
  ui.link {
    attr = { id = "area_filter_button", class="button orange menuButton"  },
    module = "unit",
    view = "show_ext",
    id = area.unit_id,
    content = function()
      ui.image{ attr = { id = "unit_arrow_back" }, static = "arrow_left.png" }
      ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"BACK TO PREVIOUS PAGE" }
    end
  }
   ui.link {
    attr = { id = "area_filter_button", class="button orange menuButton"  },
    module = "area",
    view = "show_ext",
    params = { state = "new"},
    id = area.id,
    content = function()
      ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"PROPOSTE IN CERCA DI SOSTENITORI" }
    end
  }
   ui.link {
    attr = { id = "area_filter_button", class="button orange menuButton"  },
    module = "area",
    view = "show_ext",
    params = { state = "open"},
    id = area.id,
    content = function()
      ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"PROPOSTE ATTUALMENTE IN DICSCUSSIONE" }
    end
  }
  ui.link {
    attr = { id = "area_filter_button", class="button orange menuButton"  },
    module = "area",
    view = "show_ext",
    params = { state = "closed_or_canceled"},
    id = area.id,
    content = function()
      ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"PROPOSTE COMPLETATE O RITIRATE" }
    end
  }
  slot.put("<br />")
 end
}
