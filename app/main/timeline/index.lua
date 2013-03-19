execute.view{
  module = "timeline",
  view = "_constants"
}

local active_name = ""
local areas_ignored = {}
local options_box_count = param.get("options_box_count", atom.number) or 1
if options_box_count > 10 then
  options_box_count = 10
end

local function format_dow(dow)
  local dows = {
    _"Monday",
    _"Tuesday",
    _"Wednesday",
    _"Thursday",
    _"Friday",
    _"Saturday",
    _"Sunday"
  }
  return dows[dow+1]
end
slot.put_into("title", _"Timeline")

slot.select("actions", function()
  local setting_key = "liquidfeedback_frontend_timeline_current_options"
  local setting = Setting:by_pk(app.session.member.id, setting_key)
  local current_options = ""
  if setting then
    current_options = setting.value
  end
  local setting_maps = app.session.member:get_setting_maps_by_key("timeline_filters")
  for i, setting_map in ipairs(setting_maps) do
    local active
    local options_string = setting_map.value
    local name = setting_map.subkey
    if options_string == current_options then
      active = true
      active_name = name
    end
    ui.link{
      image  = { static = "icons/16/time.png" },
      attr   = { class = active and "action_active" or nil },
      text   = name,
      form_attr = { class = "inline" },
      module = 'timeline',
      action = 'update',
      params = {
        options_string = options_string
      },
    }
  end
  if #setting_maps > 0 then
    ui.link{
      content = function()
        ui.image{ static = "icons/16/wrench.png" }
        slot.put(_"Manage filter")
      end,
      module = "timeline",
      view = "list_filter",
    }
  end
  ui.link{
    content = function()
      ui.image{ static = "icons/16/bullet_disk.png" }
      slot.put(_"Save current filter")
    end,
    module = "timeline",
    view = "save_filter",
    params = {
      current_name = active_name
    },
    attr = { 
      onclick = "el=document.getElementById('timeline_save');el.checked=true;el.form.submit();return(false);"
    }
  }
end)

util.help("timeline.index", _"Timeline")

ui.form{
  module = "timeline",
  action = "update",
  content = function()
    ui.container{

      content = function()

        ui.tag{
          tag = "input",
          attr = {
            type = "radio",
            id = "timeline_search_last_24h",
            name = "search_from",
            value = "last_24h",
            checked = param.get("date") == "last_24h" and "checked" or nil
          },
        }

        ui.tag{
          tag = "label",
          attr = {
            ["for"] = "timeline_search_last_24h" 
          },
          content = " " .. _"last 24 hours" .. " "
        }

        ui.tag{
          tag = "input",
          attr = {
            type = "radio",
            id = "timeline_search_from_date",
            name = "search_from",
            value = "date",
            checked = not (param.get("date") == "last_24h") and "checked" or nil
          },
        }

        slot.put(" ")
        local current_date = param.get("date")
        if not current_date or #current_date == 0 or current_date == "last_24h" then
          current_date = tostring(db:query("select now()::date as date")[1].date)
        end
        ui.tag{
          tag = "input",
          attr = {
            type = "text",
            id = "timeline_search_date",
            style = "width: 10em;",
            onchange = "this.form.submit();",
            onclick = "document.getElementById('timeline_search_from_date').checked = true;",
            name = "date",
            value = current_date
          },
          content = function() end
        }
    
        ui.script{ static = "gregor.js/gregor.js" }
        util.gregor("timeline_search_date", true)
    
    
        ui.link{
          attr = { style = "margin-left: 1em; font-weight: bold;", onclick = "document.getElementById('timeline_search_date').form.submit();return(false);" },
          content = function()
            ui.image{
              attr = { style = "margin-right: 0.25em;" },
              static = "icons/16/magnifier.png"
            }
            slot.put(_"Search")
          end,
          external = "#",
        }
        local show_options = param.get("show_options", atom.boolean)
        ui.link{
          attr = { style = "margin-left: 1em;", onclick = "el=document.getElementById('timeline_show_options');el.checked=" .. tostring(not show_options) .. ";el.form.submit();return(false);" },
          content = function()
            ui.image{
              attr = { style = "margin-right: 0.25em;" },
              static = "icons/16/text_list_bullets.png"
            }
            slot.put(not show_options and _"Show filter details" or _"Hide filter details")
          end,
          external = "#",
        }

        ui.field.boolean{
          attr = { id = "timeline_show_options", style = "display: none;", onchange="this.form.submit();" },
          name = "show_options",
          value = param.get("show_options", atom.boolean)
        }
        ui.hidden_field{ name = "current_name", value = active_name }
        ui.field.boolean{
          attr = { id = "timeline_save", style = "display: none;", onchange="this.form.submit();" },
          name = "save",
          value = false
        }

      end
    }

    ui.container{
      attr = { 
        id = "timeline_options_boxes",
        class = "vertical",
        style = not param.get("show_options", atom.boolean) and "display: none;" or nil
      },
      content = function()

        local function option_field(event_ident, filter_ident)
          local param_name
          if not filter_ident then
            param_name = "option_" .. event_ident
          else
            param_name = "option_" .. event_ident .. "_" .. filter_ident
          end
          local value = param.get(param_name, atom.boolean)
          ui.field.boolean{
            attr = { id = param_name },
            name = param_name,
            value = value,
          }
        end

        local function filter_option_fields(event_ident, filter_idents)

          for i, filter_ident in ipairs(filter_idents) do
              slot.put("<td>")
              option_field(event_ident, filter_ident)
              slot.put("</td><td><div class='ui_field_label label_right'>")
              ui.tag{
                attr = { ["for"] = "option_" .. event_ident .. "_" .. filter_ident },
                tag = "label",
                content = filter_names[filter_ident]
              }
              slot.put("</div></td>")
          end

        end

        local event_groups = {
          {
            title = _"Issue events",
            event_idents = {
              "issue_created",
              "issue_canceled",
              "issue_accepted",
              "issue_half_frozen",
              "issue_finished_without_voting",
              "issue_voting_started",
              "issue_finished_after_voting",
            },
            filter_idents = {
              "membership",
              "interested"
            }
          },
          {
            title = _"Initiative events",
            event_idents = {
              "initiative_created",
              "initiative_revoked",
              "draft_created",
              "suggestion_created",
            },
            filter_idents = {
              "membership",
              "interested",
              "supporter",
              "potential_supporter",
              "initiator"
            }
          }
        }

        slot.put("<table>")

        for i_event_group, event_group in ipairs(event_groups) do
          slot.put("<tr>")
          slot.put("<th colspan='2'>")
          slot.put(event_group.title)
          slot.put("</th><th colspan='10'>")
          slot.put(_"Show only events which match... (or associtated)")
          slot.put("</th>")
          slot.put("</tr>")
          local event_idents = event_group.event_idents
          for i, event_ident in ipairs(event_idents) do
            slot.put("<tr><td>")
            option_field(event_ident)
            slot.put("</td><td><div class='ui_field_label label_right'>")
            ui.tag{
              attr = { ["for"] = "option_" .. event_ident },
              tag = "label",
              content = event_names[event_ident]
            }
            slot.put("</div></td>")
            filter_option_fields(event_ident, event_group.filter_idents)
            slot.put("</tr>")
          end
        end

        slot.put("</table>")

        local areas = Area:new_selector():add_where("active='t'"):exec()
        for i, area in ipairs(areas) do
          if param.get("option_ignore_area_"..tostring(area.id)) then
            areas_ignored[#areas_ignored+1] = area.id
          end
        end

        ui.multiselect{
          style = "checkbox",
          selected_ids = areas_ignored, 
          container_attr = { class = "ignore_area_list" },
          container2_attr = { class = "ignore_area_item" },
          label = _"Ignore Areas",
          name = "option_ignore_area[]",
          foreign_records = areas,
          foreign_id      = "id",
          foreign_name    = "name"
        }

      end
    }
  end
}

local date = param.get("date")

if not date or #date == 0 then
  date = "today"
end

local timeline_selector

for event, event_name in pairs(event_names) do

  if param.get("option_" .. event, atom.boolean) then

    local tmp = Timeline:new_selector()
      if event == "draft_created" then
        tmp
          :reset_fields()
          :add_field("max(timeline.occurrence)", "occurrence")
          :add_field("timeline.event", nil,  { "grouped" })
          :add_field("timeline.issue_id", nil, { "grouped" })
          :add_field("draft.initiative_id", nil, { "grouped" })
          :add_field("max(timeline.draft_id)", "draft_id")
          :add_field("timeline.suggestion_id", nil, { "grouped" })
          :add_field("COUNT(*)", "count")
      else
        tmp
          :add_field("1", "count")
      end

      if date == "last_24h" then
        tmp:add_where{ "occurrence > now() - '24 hours'::interval" }
      else
        local start,stop = string.gmatch(date, "(%d+-%d+-%d+):(%d+-%d+-%d+)")()
        if start and stop then
          tmp:add_where{ "occurrence::date >= ?::date AND occurrence::date <= ?::date", start, stop }
        else
          local age = string.gmatch(date, "age:(.+)")()
          if age then
            tmp:add_where{ "occurrence >= now() - ?::interval", age }
          else 
            local since = string.gmatch(date, "since:%s*(%d+-%d+-%d+)%s*")()
            if since then
              tmp:add_where{ "occurrence::date >= ?::date", since }
            else
              tmp:add_where{ "occurrence::date = ?::date", date }
            end
          end
        end
      end
      tmp
        :left_join("draft", nil, "draft.id = timeline.draft_id")
        :left_join("suggestion", nil, "suggestion.id = timeline.suggestion_id")
        :left_join("initiative", nil, "initiative.id = timeline.initiative_id or initiative.id = draft.initiative_id or initiative.id = suggestion.initiative_id")
        :left_join("issue", nil, "issue.id = timeline.issue_id or issue.id = initiative.issue_id")
        :left_join("area", nil, "area.id = issue.area_id")

        :left_join("interest", "_interest", { "_interest.issue_id = issue.id AND _interest.member_id = ?", app.session.member.id} )
        :left_join("initiator", "_initiator", { "_initiator.initiative_id = initiative.id AND _initiator.member_id = ?", app.session.member.id} )
        :left_join("membership", "_membership", { "_membership.area_id = area.id AND _membership.member_id = ?", app.session.member.id} )
        :left_join("supporter", "_supporter", { "_supporter.initiative_id = initiative.id AND _supporter.member_id = ?", app.session.member.id} )

      local group
      if event == "draft_created" then
        group = { "grouped" }
        tmp:add_where{"EXISTS(SELECT 1 from draft as cdraft WHERE draft.initiative_id = cdraft.initiative_id AND cdraft.id != draft.id ORDER BY cdraft.id DESC)"}
      end

      tmp
        :add_field("(_interest.member_id NOTNULL)", "is_interested", group)
        :add_field("(_initiator.member_id NOTNULL)", "is_initiator", group)
        :add_field({"(_supporter.member_id NOTNULL) AND NOT EXISTS(SELECT NULL FROM opinion WHERE opinion.initiative_id = initiative.id AND opinion.member_id = ? AND ((opinion.degree = 2 AND NOT fulfilled) OR (opinion.degree = -2 AND fulfilled)) LIMIT 1)", app.session.member.id }, "is_supporter", group)
        :add_field({"EXISTS(SELECT NULL FROM opinion WHERE opinion.initiative_id = initiative.id AND opinion.member_id = ? AND ((opinion.degree = 2 AND NOT fulfilled) OR (opinion.degree = -2 AND fulfilled)) LIMIT 1)", app.session.member.id }, "is_potential_supporter", group)
  --    :left_join("member", nil, "member.id = timeline.member_id", group)

      if #areas_ignored > 0 then
        tmp:add_where{"area.id NOT IN ($)", areas_ignored}
      end

    tmp:add_where{ "event = ?", event }

    local filters = {}
    if param.get("option_" .. event .. "_membership", atom.boolean) then
      filters[#filters+1] = "(timeline.initiative_id ISNULL AND timeline.issue_id ISNULL AND timeline.draft_id ISNULL AND timeline.suggestion_id ISNULL) OR _membership.member_id NOTNULL"
    end

    if param.get("option_" .. event .. "_supporter", atom.boolean) then
      filters[#filters+1] = "(timeline.initiative_id ISNULL AND timeline.issue_id ISNULL AND timeline.draft_id ISNULL AND timeline.suggestion_id ISNULL) OR ((_supporter.member_id NOTNULL) AND NOT EXISTS(SELECT NULL FROM opinion WHERE opinion.initiative_id = initiative.id AND opinion.member_id = ? AND ((opinion.degree = 2 AND NOT fulfilled) OR (opinion.degree = -2 AND fulfilled)) LIMIT 1))"
    end

    if param.get("option_" .. event .. "_potential_supporter", atom.boolean) then
      filters[#filters+1] = "(timeline.initiative_id ISNULL AND timeline.issue_id ISNULL AND timeline.draft_id ISNULL AND timeline.suggestion_id ISNULL) OR ((_supporter.member_id NOTNULL) AND EXISTS(SELECT NULL FROM opinion WHERE opinion.initiative_id = initiative.id AND opinion.member_id = ? AND ((opinion.degree = 2 AND NOT fulfilled) OR (opinion.degree = -2 AND fulfilled)) LIMIT 1))"
    end

    if param.get("option_" .. event .. "_interested", atom.boolean) then
      filters[#filters+1] = "(timeline.initiative_id ISNULL AND timeline.issue_id ISNULL AND timeline.draft_id ISNULL AND timeline.suggestion_id ISNULL) OR _interest.member_id NOTNULL"
    end

    if param.get("option_" .. event .. "_initiator", atom.boolean) then
      filters[#filters+1] = "(timeline.initiative_id ISNULL AND timeline.issue_id ISNULL AND timeline.draft_id ISNULL AND timeline.suggestion_id ISNULL) OR _initiator.member_id NOTNULL"
    end

    if #filters > 0 then
      local filter_string = "(" .. table.concat(filters, ") OR (") .. ")"
      tmp:add_where{ filter_string, app.session.member.id, app.session.member.id }
    end
  
    if not timeline_selector then
      timeline_selector = tmp
    else
      timeline_selector:union_all(tmp)
    end
  end
end

if timeline_selector then
  
  local initiatives_per_page = param.get("initiatives_per_page", atom.number)
  
  local outer_timeline_selector = db:new_selector()
  outer_timeline_selector._class = Timeline
  outer_timeline_selector
    :add_field{ "timeline.*" }
    :from({"($)", { timeline_selector }}, "timeline" )
    :add_order_by("occurrence DESC")

  slot.put("<br />")
  execute.view{
    module = "timeline",
    view = "_list",
    params = {
      timeline_selector = outer_timeline_selector,
      per_page = param.get("per_page", atom.number),
      event_names = event_names,
      initiatives_per_page = initiatives_per_page
    }
  }

else

  slot.put(_"No events selected to list")

end