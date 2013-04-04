local lat = param.get("lat")
local lon = param.get("lon")
if app.session.member_id then
  local memberConnection = MemberConnection:new()
  memberConnection.member_id=app.session.member_id
  if lat and lon then
    memberConnection.position = lat..","..lon
  else
    memberConnection.position = nil
  end
  memberConnection.login_time="now"
  memberConnection:save()
end
