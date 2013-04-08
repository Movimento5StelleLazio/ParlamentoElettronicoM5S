local lang = param.get("lang")
local valid_lang = false
for i, tmp_lang in ipairs(config.enabled_languages) do
  if lang == tmp_lang then
    valid_lang = true
  end
end
if valid_lang then
  app.session.lang = lang
  app.session:save()
  if app.session.member_id then
    app.session.member.lang = app.session.lang
    app.session.member:save()
  end
end
