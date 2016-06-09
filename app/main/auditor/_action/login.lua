local login = param.get("login")
local password = param.get("password")

local member = Member:by_login_and_password(login, password)

if member and member.auditor == true then
    member.last_login = "now"
    member.last_activity = "now"
    member.active = true
    if member.lang == nil then
        member.lang = app.session.lang
    else
        app.session.lang = member.lang
    end

    if member.password_hash_needs_update then
        member:set_password(password)
    end

    member:save()
    app.session.member = member
    app.session:save()
    trace.debug('User authenticated')

    local memberLogin = MemberLogin:new()
    memberLogin.member_id = app.session.member_id
    memberLogin.login_time = member.last_login
    memberLogin:save()

    ui.script { static = "js/position.js" }
    ui.script { script = 'set_login_position("' .. config.absolute_base_url .. '/member/update_position.html");' }

else
    slot.select("error", function()
        ui.tag { content = _ 'Invalid login name or password!' }
    end)
    trace.debug('User NOT authenticated')
    return false
end
