execute.view{
  module = "timeline",
  view = "_constants"
}

local options_string = param.get("options_string")

if not options_string then
  local active_options = ""
  for event_ident, event_name in pairs(event_names) do
    if param.get("option_" .. event_ident, atom.boolean) then
      active_options = active_options .. event_ident .. ":"
      local filter_idents = {}
      for filter_ident, filter_name in pairs(filter_names) do
        if param.get("option_" .. event_ident .. "_" .. filter_ident, atom.boolean) then
          filter_idents[#filter_idents+1] = filter_ident
        end
      end
      if #filter_idents > 0 then
        active_options = active_options .. table.concat(filter_idents, "|") .. " "
      else
        active_options = active_options .. "* "
      end
    end
  end
  if #active_options > 0 then
    options_string = active_options
  end
end

if not options_string then
  options_string = "issue_created:* issue_finished_after_voting:* issue_accepted:* issue_voting_started:* suggestion_created:* issue_canceled:* initiative_created:* issue_finished_without_voting:* draft_created:* initiative_revoked:* issue_half_frozen:* "
end

if param.get_list("option_ignore_area", atom.string) then
  options_string = options_string.." ignore_area:"..table.concat(param.get_list("option_ignore_area", atom.string), "|")
end

local setting_key = "liquidfeedback_frontend_timeline_current_options"
local setting = Setting:by_pk(app.session.member.id, setting_key)

if not setting or setting.value ~= options_string then
  if not setting then
    setting = Setting:new()
    setting.member_id = app.session.member_id
    setting.key = setting_key
  end
  if options_string then
    setting.value = options_string
    setting:save()
  end
end

local date = param.get("date")

if param.get("search_from") == "last_24h" then
  date = "last_24h"
end

if date and #date > 0 then
  local setting_key = "liquidfeedback_frontend_timeline_current_date"
  local setting = Setting:by_pk(app.session.member.id, setting_key)
  if not setting or setting.value ~= date then
    if not setting then
      setting = Setting:new()
      setting.member_id = app.session.member.id
      setting.key = setting_key
    end
    setting.value = date
    setting:save()
  end
end

local setting_key = "liquidfeedback_frontend_timeline_current_options"
local setting = Setting:by_pk(app.session.member.id, setting_key)

local timeline_params = {}
if setting and setting.value then
  for event_ident, filter_idents in setting.value:gmatch("(%S+):(%S+)") do
    timeline_params["option_" .. event_ident] = true
    if filter_idents ~= "*" then
      for filter_ident in filter_idents:gmatch("([^\|]+)") do
        timeline_params["option_" .. event_ident .. "_" .. filter_ident] = true
      end
    end
  end
end

local setting_key = "liquidfeedback_frontend_timeline_current_date"
local setting = Setting:by_pk(app.session.member.id, setting_key)

if setting then
  timeline_params.date = setting.value
end

timeline_params.show_options = param.get("show_options", atom.boolean)

if param.get("save", atom.boolean) then
  request.redirect{
    module = "timeline",
    view = "save_filter",
    params = {
      current_name = param.get("current_name")
    }
  }
else
  request.redirect{
    module = "timeline",
    view = "index",
    params = timeline_params
  }
end