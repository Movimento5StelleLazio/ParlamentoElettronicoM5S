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
  or  module == 'idcard_scan'
)

if restricted and app.session.member.lqfb_access ~= true and app.session.member.admin ~= true then
  --error('The administrator has disabled the access to this module')
	slot.put("error", "You're account is not active yet: wait for/require your confirmation email or contact your auditor.")
	trace.debug("lqfb access refused")
	request.redirect{
    module = 'index', view = 'index', params = {
      redirect_module = module,
      redirect_view = view,
      redirect_id = param.get_id()
    }
  }  
else
	trace.debug("lqfb access: Member has access")
	execute.inner()
end
