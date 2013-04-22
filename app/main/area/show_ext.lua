local area = Area:by_id(param.get_id())
local state = param.get("state")
local orderby = param.get("orderby")
local desc = param.get("desc",atom.boolean)
local interest = param.get("interest")
local member = app.session.member

app.html_title.title = area.name
app.html_title.subtitle = _("Area")

util.help("area.show")

-- Get the unit name from the configuration file
local unit_name
for i,v in pairs(config.gui_preset.M5S.units) do
  if config.gui_preset.M5S.units[i].unit_id == area.unit_id then unit_name = i end
end

if not config.gui_preset.M5S.units[unit_name] then
  slot.put_into("error", "unit_id for selected area is not configured in config.gui_preset")
  return false
end

-- Set the desc order param
if desc ~= true and desc ~= false then
  desc = false
end
 
-- Determines the desc order button text
local inv_txt
if not desc then
  inv_txt = _"INVERT ORDER FROM ASCENDING TO DESCENDING"
else
  inv_txt = _"INVERT ORDER FROM DESCENDING TO ASCENDING"
end
  
local issues_selector = area:get_reference_selector("issues")

execute.chunk{
  module    = "issue",
  chunk     = "_filters_ext",
  params    = { 
    state=state, 
    orderby=orderby, 
    desc=desc,
    interest=interest,
    selector=issues_selector
  }
}

-- Category, used for routing
local category

-- This holds issue-oriented description text for shown issues
local issues_desc

if state == "admission" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_admission or Issue:get_state_name_for_state('admission')
  category=1
elseif state == "development" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_development or _"Development"
  category=2
elseif state == "discussion" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_development or Issue:get_state_name_for_state('discussion')
  category=2
elseif state == "voting" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_development or Issue:get_state_name_for_state('voting')
  category=2
elseif state == "verification" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_development or Issue:get_state_name_for_state('verification')
  category=2
elseif state == "closed" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_closed or _"Closed"
  category=3
elseif state == "canceled" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_closed or _"Canceled"
  category=3
elseif state == "open" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_open or _"Open"
else
  issues_desc = _"Unknown"
end

-- Used to align buttons
local button_margin

ui.container{ attr = { class  = "unit_header_box" }, content = function()
  ui.link {
    attr = { id = "unit_button_back", class="button orange menuButton"  },
    module = "area",
    view = "filters",
    id = area.id,
    content = function()
      ui.image{ attr = { id = "unit_arrow_back" }, static = "arrow_left.png" }
      ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"BACK TO PREVIOUS PAGE" }
    end
  }
  ui.tag { tag = "p", attr = { id = "unit_title", class  = "welcome_text_l"}, content = _(config.gui_preset.M5S.units[unit_name].assembly_title, {realname = app.session.member.realname}) }
  ui.tag { tag = "p", attr = { id = "unit_title", class  = "welcome_text_xl"}, content = _"CHOOSE THE INITIATIVE TO EXAMINE:" }
end}

execute.view{
  module="index" ,
  view="_filter_ext" ,
  params={
    level=5,
    category=category,
    module="area",
    routing_page="show_ext",
    state=state, 
    orderby=orderby, 
    desc=desc
  }
}

    
ui.image{ attr = { id = "unit_parlamento_img" }, static = "parlamento_icon_small.png" }

ui.container{ attr = { class="unit_bottom_box"}, content=function()
  ui.tag { tag = "p", attr = { class  = "welcome_text_xl"  }, content = _(issues_desc) or "Initiatives:" }

  -- TODO Remove hard-coded check and test if area policy has a non null admission time instead
  if unit_name == "cittadini" or unit_name == "iscritti" then
    ui.link {
      attr = { id = "area_show_ext_button", class="button orange menuButton"  },
      module = "area",
      view = "show_ext",
      id = area.id,
      params = { state=state, orderby="supporters", desc=desc},
      content = function()
        ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"ORDER BY NUMBER OF SUPPORTERS" }
      end
    }
  else
    button_margin = "left: 140px;" 
  end

  ui.link {
    attr = { id = "area_show_ext_button", class="button orange menuButton", style = button_margin or nil  },
    module = "area",
    view = "show_ext",
    id = area.id,
    params = { state=state, orderby="creation_date", desc=desc },
    content = function()
      ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"ORDER BY DATE OF CREATION" }
    end
  }

  ui.link {
    attr = { id = "area_show_ext_button", class="button orange menuButton", style = button_margin or nil  },
    module = "area",
    view = "show_ext",
    id = area.id,
    params = { state=state, orderby="event", desc=desc},
    content = function()
      ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"ORDER BY LAST EVENT DATE" }
    end
  }

  ui.link {
    attr = { id = "area_show_ext_button", class="button orange menuButton", style = button_margin or nil  },
    module = "area",
    view = "show_ext",
    id = area.id,
    params = { state=state, orderby=orderby, desc=not(desc)},
    content = function()
      ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = inv_txt }
    end
  }

  ui.container{ attr = { class="area_issue_box"}, content=function()
    execute.view{
      module="issue" ,
      view="_list_ext" ,
      params={ issues_selector=issues_selector, member=member }
  }

  end }
end }
