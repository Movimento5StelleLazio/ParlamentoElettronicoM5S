if app.session then
  app.session:destroy()
  slot.put_into("notice", _"Logout successful")
end
