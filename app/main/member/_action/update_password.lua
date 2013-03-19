local old_password = param.get("old_password")
local new_password1 = param.get("new_password1")
local new_password2 = param.get("new_password2")

if not Member:by_login_and_password(app.session.member.login, old_password) then
  slot.put_into("error", _"Old password is wrong")
  return false
end

if new_password1 ~= new_password2 then
  slot.put_into("error", _"New passwords does not match.")
  return false
end

if #new_password1 < 8 then
  slot.put_into("error", _"New passwords is too short.")
  return false
end

app.session.member:set_password(new_password1)
app.session.member:save()

slot.put_into("notice", _"Your password has been updated successfully")
