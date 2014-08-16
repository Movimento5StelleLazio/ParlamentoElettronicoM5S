local lat = param.get("lat")
local lng = param.get("lng")

if app.session.member_id and lat and lng then
    local result = db:query { "UPDATE member_login SET geolat = ?, geolng = ? WHERE login_time = (SELECT last_login FROM member WHERE member.id = ?)", lat, lng, app.session.member_id }
end
slot.set_layout(nil, nil)
