local lat = param.get("lat")
local lon = param.get("lon")
if app.session.member_id then
  local memberLogin = MemberLogin:new()
  memberLogin.member_id=app.session.member_id
  if lat and lon then
    memberLogin.position = lat..","..lon
  else
    memberLogin.position = nil
  end
  memberLogin.login_time="now"
  memberLogin:save()
end
