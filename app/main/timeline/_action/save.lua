local id = param.get("id", atom.number)

local setting_key = "liquidfeedback_frontend_timeline_current_options"
local setting = Setting:by_pk(app.session.member.id, setting_key)
local options_string = setting.value

local timeline_filter

local subkey = param.get("name")

if not subkey or subkey == "" then
  slot.put_into("error", _"This name is really too short!")
  request.redirect{
    module = "timeline",
    view = "save_filter",
  }
  return
end

app.session.member:set_setting_map("timeline_filters", subkey, options_string)

local timeline_params = {}
if options_string then
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

request.redirect{
  module = "timeline",
  view = "index",
  params = timeline_params
}