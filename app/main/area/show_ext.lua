local area = Area:by_id(param.get_id())
local filter = param.get("filter")


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

local issue_desc
if filter == "open" then
  issue_desc = config.gui_preset.M5S.units[unit_name].issue_desc_open
elseif filter == "closed_or_canceled" then
  issue_desc = config.gui_preset.M5S.units[unit_name].issue_desc_closed_or_canceled
elseif filter == "new" then
  issue_desc = config.gui_preset.M5S.units[unit_name].issue_desc_new
else
  slot.put_into("error", "Invalid filter selected")
  return false
end
  

local open_issues_selector = area:get_reference_selector("issues")
  :add_where("issue.closed ISNULL")
  :add_order_by("coalesce(issue.fully_frozen + issue.voting_time, issue.half_frozen + issue.verification_time, issue.accepted + issue.discussion_time, issue.created + issue.admission_time) - now()")

local closed_issues_selector = area:get_reference_selector("issues")
  :add_where("issue.closed NOTNULL")
  :add_order_by("issue.closed DESC")

local members_selector = area:get_reference_selector("members"):add_where("member.active")
local delegations_selector = area:get_reference_selector("delegations")
  :join("member", "truster", "truster.id = delegation.truster_id AND truster.active")
  :join("member", "trustee", "trustee.id = delegation.trustee_id AND trustee.active")




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

ui.image{ attr = { id = "unit_parlamento_img" }, static = "parlamento_icon_small.png" }

ui.container{ attr = { class="unit_bottom_box"}, content=function()
  ui.tag { tag = "p", attr = { class  = "welcome_text_xl"  }, content = _(issue_desc) }

ui.link {
    attr = { id = "area_show_ext_button", class="button orange menuButton"  },
    module = "area",
    view = "show_ext",
    id = area.id,
    content = function()
      ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"ORDER BY NUMBER OF SUPPORTERS" }
    end
  }

ui.link {
    attr = { id = "area_show_ext_button", class="button orange menuButton"  },
    module = "area",
    view = "show_ext",
    id = area.id,
    content = function()
      ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"ORDER BY DATE OF CREATION" }
    end
  }

ui.link {
    attr = { id = "area_show_ext_button", class="button orange menuButton"  },
    module = "area",
    view = "show_ext",
    id = area.id,
    content = function()
      ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"ORDER BY LAST EVENT DATE" }
    end
  }

ui.link {
    attr = { id = "area_show_ext_button", class="button orange menuButton"  },
    module = "area",
    view = "show_ext",
    id = area.id,
    content = function()
      ui.tag {  tag = "p", attr = { class  = "button_text"  }, content = _"INVERT ORDER FROM DESCENDING TO ASCENDING" }
    end
  }

ui.container{ attr = { class="area_issue_box"}, content=function()
    execute.view{
      module = "issue",
      view = "_list",
      params = {
        for_state = "open",
        issues_selector = open_issues_selector, for_area = true
      }
    }
  end
}

end}











local tabs = {
  module = "area",
  view = "show_tab",
  static_params = { area_id = area.id },
}

tabs[#tabs+1] = {
  name = "timeline",
  label = _"Latest events",
  module = "event",
  view = "_list",
  params = { for_area = area }
}

tabs[#tabs+1] = {
  name = "open",
  label = _"Open issues",
  module = "issue",
  view = "_list",
  params = {
    for_state = "open",
    issues_selector = open_issues_selector, for_area = true
  }
}
tabs[#tabs+1] = {
  name = "closed",
  label = _"Closed issues",
  module = "issue",
  view = "_list",
  params = {
    for_state = "closed",
    issues_selector = closed_issues_selector, for_area = true
  }
}

if app.session:has_access("all_pseudonymous") then
  tabs[#tabs+1] =
    {
      name = "members",
      label = _"Participants" .. " (" .. tostring(members_selector:count()) .. ")",
      icon = { static = "icons/16/group.png" },
      module = "member",
      view = "_list",
      params = { members_selector = members_selector }
    }

  tabs[#tabs+1] =
    {
      name = "delegations",
      label = _"Delegations" .. " (" .. tostring(delegations_selector:count()) .. ")",
      icon = { static = "icons/16/table_go.png" },
      module = "delegation",
      view = "_list",
      params = { delegations_selector = delegations_selector }
    }
end

--ui.tabs(tabs)
