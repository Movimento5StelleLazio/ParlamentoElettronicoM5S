if cgi.cookies.session then
  app.session = Session:by_ident(cgi.cookies.session)
end
if not app.session then
  app.session = Session:new()
  cgi.add_header('Set-Cookie: session=' .. app.session.ident .. '; path=/' )
end

request.set_csrf_secret(app.session.csrf_secret)

if app.session.user then
  locale.set{ lang = app.session.user.lang or "en" }
end

if param.get("lang") then
  locale.set{ lang = param.get("lang") }
end

execute.inner()
