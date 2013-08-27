if app.session then
  app.session:destroy()
  slot.put_into("notice", _"Logout successful")
  if config.etherpad then
    request.set_cookie{
      path = config.etherpad.cookie_path,
      name = "sessionID",
      value = "invalid"
    }
  end
end
