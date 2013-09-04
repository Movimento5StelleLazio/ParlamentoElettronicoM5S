local module = request.get_module()
local view   = request.get_view()
local action = request.get_action()

local restricted = not (
  (module == 'index'
  and (
       view   == "index"
    or view   == "login"
    or action == "login"
    or action == "logout"
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
   ))
  or  module == 'auditor'
)

if restricted and app.session.member.lqfb_access ~= true and app.session.member.admin ~= true then
  trace.debug("lqfb access: Member has been disabled")
  error('The administrator has disabled the access to this module')
end
trace.debug("lqfb access: Member has access")
execute.inner()
