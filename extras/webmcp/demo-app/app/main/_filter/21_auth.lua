local auth_needed = not (
  request.get_module() == 'index'
  and (
    request.get_view() == 'login'
    or request.get_action() == 'login'
  )
)

-- if not app.session.user_id then
--   trace.debug("DEBUG: AUTHENTICATION BYPASS ENABLED")
--   app.session.user_id = 1
-- end

if app.session.user == nil and auth_needed then
  trace.debug("Not authenticated yet.")
  request.redirect{ module = 'index', view = 'login' }
else
  if auth_needed then
    trace.debug("Authentication accepted.")
  else
    trace.debug("No authentication needed.")
  end
  execute.inner()
  trace.debug("End of authentication filter.")
end
