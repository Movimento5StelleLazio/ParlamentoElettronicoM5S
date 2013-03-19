if request.get_view() == "index" and not param.get("date") then
  local setting
  local setting_key = "liquidfeedback_frontend_timeline_current_options"
  if app.session.member_id then
    setting = Setting:by_pk(app.session.member.id, setting_key)
  end

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

  local setting
  local setting_key = "liquidfeedback_frontend_timeline_current_date"
  if app.session.member_id then
    setting = Setting:by_pk(app.session.member.id, setting_key)
  end

  if setting then
    timeline_params.date = setting.value
  else
    timeline_params.date = "last_24h"
  end

  timeline_params.show_options = param.get("show_options", atom.boolean)

  request.redirect{
    module = "timeline",
    view = "index",
    params = timeline_params
  }
else
  execute.inner()
end

