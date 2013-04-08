local module = request.get_module()
local view   = request.get_view()
local action = request.get_action()

local auth_needed = not (
  module == 'index'
  and (
       view   == "index"
    or view   == "login"
    or action == "login"
    or view   == "register"
    or action == "register"
    or view   == "about"
    or view   == "reset_password"
    or action == "reset_password"
    or view   == "confirm_notify_email"
    or action == "confirm_notify_email"
    or view   == "menu"
    or action == "set_lang"
    or view   == "404"
  )
)

if app.session:has_access("anonymous") then

  if
    module == "area" and view == "show"
    or module == "unit" and view == "show"
    or module == "policy" and view == "show"
    or module == "policy" and view == "list"
    or module == "issue" and view == "show"
    or module == "initiative" and view == "show"
    or module == "suggestion" and view == "show"
    or module == "draft" and view == "diff"
    or module == "draft" and view == "show"
    or module == "draft" and view == "list"
    or module == "index" and view == "search"
    or module == "index" and view == "usage_terms"
  then
    auth_needed = false
  end

end

if app.session:has_access("all_pseudonymous") then
  if module == "member_image" and view == "show"
   or module == "vote" and view == "show_incoming"
   or module == "interest" and view == "show_incoming"
   or module == "supporter" and view == "show_incoming" 
   or module == "vote" and view == "list" then
    auth_needed = false
  end
end

if app.session:has_access("everything") then
  if module == "member" and (view == "show" or view == "history") then
    auth_needed = false
  end
end

if module == "sitemap" then
  auth_needed = false
end

if app.session:has_access("anonymous") and not app.session.member_id and auth_needed and module == "index" and view == "index" then
  if config.single_unit_id then
    request.redirect{ module = "unit", view = "show", id = config.single_unit_id }
  else
    request.redirect{ module = "unit", view = "list" }
  end
  return
end

-- if not app.session.user_id then
--   trace.debug("DEBUG: AUTHENTICATION BYPASS ENABLED")
--   app.session.user_id = 1
-- end

if auth_needed and app.session.member == nil then
  trace.debug("Not authenticated yet.")
  request.redirect{
    module = 'index', view = 'login', params = {
      redirect_module = module,
      redirect_view = view,
      redirect_id = param.get_id()
    }
  }
elseif auth_needed and app.session.member.locked then
  trace.debug("Member locked.")
  request.redirect{ module = 'index', view = 'login' }
else
  if auth_needed then
    trace.debug("Authentication accepted.")
  else
    trace.debug("No authentication needed.")
  end

  --db:query("SELECT check_everything()")

  execute.inner()
  trace.debug("End of authentication filter.")
end

