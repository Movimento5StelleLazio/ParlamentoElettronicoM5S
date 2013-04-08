if cgi.cookies.liquid_feedback_session then
  app.session = Session:by_ident(cgi.cookies.liquid_feedback_session)
end
if not app.session then
  app.session = Session:new()
  request.set_cookie{
    name = "liquid_feedback_session",
    value = app.session.ident
  }
end

request.set_csrf_secret(app.session.additional_secret)

locale.set{ lang = app.session.lang or config.default_lang or "en" }

if locale.get("lang") == "de" then
  locale.set{
    date_format = 'DD.MM.YYYY',
    time_format = 'HH:MM{:SS} Uhr',
    decimal_point = ','
  }
end

execute.inner()
