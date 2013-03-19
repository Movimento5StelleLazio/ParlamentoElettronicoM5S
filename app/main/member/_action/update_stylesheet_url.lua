
local setting_key = "liquidfeedback_frontend_developer_features"
local setting = Setting:by_pk(app.session.member.id, setting_key)

if not setting then
  error("access denied")
end

local stylesheet_url = util.trim(param.get("stylesheet_url"))
local setting_key = "liquidfeedback_frontend_stylesheet_url"
local setting = Setting:by_pk(app.session.member.id, setting_key)

if stylesheet_url and #stylesheet_url > 0 then
  if not setting then
    setting = Setting:new()
    setting.member_id = app.session.member.id
    setting.key = setting_key
  end
  setting.value = stylesheet_url
  setting:save()
elseif setting then
  setting:destroy()
end

slot.put_into("notice", _"Stylesheet URL has been updated")
