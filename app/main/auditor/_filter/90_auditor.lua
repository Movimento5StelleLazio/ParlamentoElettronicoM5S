local module = request.get_module()
local view = request.get_view()
local action = request.get_action()

if not (module == 'auditor' and (view == 'login' or action == 'login')) then
    if not app.session.member.auditor then
        error('access denied')
    end
end
execute.inner()
