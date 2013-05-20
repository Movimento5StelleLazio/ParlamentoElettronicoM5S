if 
  not (request.get_module() == "index" and request.get_action() == "login")
  and not (request.get_module() == "index" and request.get_action() == "logout")
then
  app.session.user:require_privilege("write")
end
execute.inner()
