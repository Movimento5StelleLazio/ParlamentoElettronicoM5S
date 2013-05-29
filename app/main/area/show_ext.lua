local area = Area:by_id(param.get_id())
local state = param.get("state")
local orderby = param.get("orderby")
local desc = param.get("desc",atom.boolean) or false
local interest = param.get("interest")
local member = app.session.member
local ftl_btns = param.get("ftl_btns",atom.boolean) or false

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

-- Determines the desc order button text
local inv_txt
if not desc then
  inv_txt = _"INVERT ORDER FROM ASCENDING TO DESCENDING"
else
  inv_txt = _"INVERT ORDER FROM DESCENDING TO ASCENDING"
end

local selector = area:get_reference_selector("issues")
  
execute.chunk{
  module    = "issue",
  chunk     = "_filters_ext",
  id = area.id,
  params    = { 
    state=state, 
    orderby=orderby, 
    desc=desc,
    interest=interest,
    selector=selector
  }
}

-- Category, used for routing
local category

-- This holds issue-oriented description text for shown issues
local issues_desc

if state == "admission" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_admission or Issue:get_state_name_for_state('admission')
elseif state == "development" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_development or _"Development"
elseif state == "discussion" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_development or Issue:get_state_name_for_state('discussion')
elseif state == "voting" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_development or Issue:get_state_name_for_state('voting')
elseif state == "verification" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_development or Issue:get_state_name_for_state('verification')
elseif state == "committee" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_development or _"Committee"
elseif state == "closed" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_closed or _"Closed"
elseif state == "canceled" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_closed or _"Canceled"
elseif state == "finished" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_closed or _"Finished"
elseif state == "finished_with_winner" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_closed or _"Finished (with winner)"
elseif state == "finished_without_winner" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_closed or _"Finished (without winner)"
elseif state == "open" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_open or _"Open"
elseif state == "any" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_any or _"Any"
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

if state == "development" or state == "verification" or state == "discussion" or state == "voting" or state == "committee" then
btns = {
  default_state = 'development',
  state = { "discussion", "verification", "voting", "committee" },
  default_interest = 'any',
  interest = { "any", "not_interested", "interested", "initiated", "supported", "potentially_supported", "voted" }
}
elseif state == "closed" or state == "canceled" or state == "finished" then
btns = {
  default_state = 'closed',
  default_interest = 'any',
  interest = { "any", "not_interested", "interested", "initiated", "supported", "potentially_supported", "voted" }
}
elseif state == "admission" then  
  btns = {
  default_state = 'admission',
  default_interest = 'any',
  interest = { "any", "not_interested", "interested", "initiated", "supported", "potentially_supported", "voted" }
}
else
  btns = {
  default_state = 'any',
    state = {
      "any",
      "open",
      "development",
      "admission",
      "discussion",
      "voting",
      "verification",
      "canceled",
      "committee",
      "finished",
      "finished_with_winner",
      "finished_without_winner",
      "closed"
    },
    default_interest = 'any',
    interest = {
      "any",
      "interested",
      "not_interested",
      "initiated",
      "supported",
      "potentially_supported",
      "voted",
      "not_voted"
    },
    default_scope = "any",
    scope = {
      "all_units",
      "my_units",
      "my_areas"
    }
  }
end

execute.chunk{
  module = "issue" ,
  chunk = "_filters_btn" ,
  id = area.id,
  params = {
    state = state,
    orderby = orderby,
    desc = desc,
    interest = interest,
    btns = btns,
    ftl_btns = ftl_btns
  }
}

ui.container{ attr = { id="unit_img_box"}, content=function()
  ui.image{ attr = { id = "unit_parlamento_img" }, static = "parlamento_icon_small.png" }
end }

ui.container{ attr = { id="area_show_bottom_box"}, content=function()
  
  ui.container{ attr = { class="unit_bottom_box"}, content=function()
    ui.tag { tag = "p", attr = { class  = "welcome_text_xl"  }, content = _(issues_desc) or "Initiatives:" }
  
    ui.container{ attr = { class="unit_button_box"}, content=function()
  
      -- TODO Remove hard-coded check and test if area policy has a non null admission time instead
      if unit_name == "cittadini" or unit_name == "iscritti" then
        ui.link {
          attr = { class="area_show_ext_button button orange" },
          module = "area",
          view = "show_ext",
          id = area.id,
          params = { state=state, orderby="supporters", interest=interest, desc=desc, ftl_btns=ftl_btns},
          content = function()
            ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"ORDER BY NUMBER OF SUPPORTERS" }
          end
        }
      else
        button_margin = "left: 140px;" 
      end
    
      ui.link {
        attr = { class="area_show_ext_button button orange" },
        module = "area",
        view = "show_ext",
        id = area.id,
        params = { state=state, orderby="creation_date", interest=interest, desc=desc, ftl_btns=ftl_btns },
        content = function()
          ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"ORDER BY DATE OF CREATION" }
        end
      }
  
      ui.link {
        attr = { class="area_show_ext_button button orange" },
        module = "area",
        view = "show_ext",
        id = area.id,
        params = { state=state, orderby="event", interest=interest, desc=desc, ftl_btns=ftl_btns},
        content = function()
          ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"ORDER BY LAST EVENT DATE" }
        end
      }
  
      ui.link {
        attr = { class="area_show_ext_button button orange" },
        module = "area",
        view = "show_ext",
        id = area.id,
        params = { state=state, orderby=orderby, interest=interest, desc=not(desc), ftl_btns=ftl_btns},
        content = function()
          ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = inv_txt }
        end
      }
     
    end }
  
    ui.container{ attr = { class="area_issue_box"}, content=function()
      execute.view{
        module="issue" ,
        view="_list_ext",
        params={ selector=selector, member=member }
    }
  
    end }
  end }
end }
