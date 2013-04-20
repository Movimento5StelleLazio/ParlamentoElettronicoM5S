local area = Area:by_id(param.get_id())
local state = param.get("state")
local orderby = param.get("orderby")
local invert = param.get("invert",atom.boolean)
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

-- Set the invert order param
if invert ~= true and invert ~= false then
  invert = false
end
 
-- Determines the invert order button text
local inv_txt
if not invert then
  inv_txt = _"INVERT ORDER FROM ASCENDING TO DESCENDING"
else
  inv_txt = _"INVERT ORDER FROM DESCENDING TO ASCENDING"
end
  
-- This holds issue-oriented description text for shown issues
local issue_desc

local ord = ""
if invert then
  ord = " DESC"
end

if not state then
  state = "open"
end

local issues_selector = area:get_reference_selector("issues")
if state == "open" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_open
  issues_selector:add_where("issue.state in ('admission', 'discussion', 'verification', 'voting')")
--  issues_selector:add_order_by("coalesce(issue.fully_frozen + issue.voting_time, issue.half_frozen + issue.verification_time, issue.accepted + issue.discussion_time, issue.created + issue.admission_time) - now()")

elseif state == "new" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_new
  issues_selector:add_where("issue.state = 'admission'")

elseif state == "development" then
  -- TODO issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_development
  issues_selector:add_where("issue.state in ('discussion', 'verification', 'voting')")

elseif state == "voting" then
  -- TODO issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_voting
  issues_selector:add_where("issue.state = 'voting'")

elseif state == "verification" then
  -- TODO issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_verification
  issues_selector:add_where("issue.state = 'verification'")

elseif state == "closed" then
  issues_desc = config.gui_preset.M5S.units[unit_name].issues_desc_closed_or_canceled
  issues_selector:add_where("issue.closed NOTNULL")
--  issues_selector:add_order_by("issue.closed "..ord)
end
  
-- Checking orderby
if not orderby then
  orderby = "creation_date"
end 

if orderby == "creation_date" then
  issues_selector:add_order_by("issue.created"..ord)
elseif orderby == "supporters" then
  --issues_selector:add_order_by(""..ord)
elseif orderby == "last_event" then
  --issues_selector:add_order_by(""..ord)
else

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

  -- Filters div
  ui.container{ attr = { id  = "area_show_ext_filter_box" }, content = function()

    ui.link { 
      attr = { id = "area_show_ext_openfilter_button", class="button orange menuButton",onclick = "alert('TBD');"  },
      module = "area",
      view = "show_ext",
      id = area.id,
      content = function()
        ui.tag { tag = "p", attr = { class  = "button_text"  }, content = _"APPLY FILTERS" }
      end
    }

    ui.container{ attr = { id  = "area_show_ext_filter_phase_box" }, content = function()
    end }

    ui.container{ attr = { id  = "area_show_ext_filter_category_box" }, content = function()
    end }
    
  end }

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
      params = { state=state, orderby="supporters", invert=invert},
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
    params = { state=state, orderby="creation_date", invert=invert },
    content = function()
      ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"ORDER BY DATE OF CREATION" }
    end
  }

  ui.link {
    attr = { id = "area_show_ext_button", class="button orange menuButton", style = button_margin or nil  },
    module = "area",
    view = "show_ext",
    id = area.id,
    params = { state=state, orderby="last_event", invert=invert},
    content = function()
      ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"ORDER BY LAST EVENT DATE" }
    end
  }

  ui.link {
    attr = { id = "area_show_ext_button", class="button orange menuButton", style = button_margin or nil  },
    module = "area",
    view = "show_ext",
    id = area.id,
    params = { state=state, orderby=orderby, invert=not(invert)},
    content = function()
      ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = inv_txt }
    end
  }

  ui.container{ attr = { class="area_issue_box"}, content=function()
    ui.paginate{
      per_page = tonumber(param.get("per_page") or 25),
      selector = issues_selector,
      content = function()
        local issues = issues_selector:exec()
        issues:load_everything_for_member_id(member and member.id or nil)
  
        ui.container{ attr = { class = "issues" }, content = function()
          for i, issue in ipairs(issues) do
            execute.view{ module = "issue", view = "_show", params = {
              issue = issue, for_listing = true, for_member = member
            } }
          end
        end }
    end }
  end }
end }
