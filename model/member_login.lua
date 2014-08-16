MemberLogin = mondelefant.new_class()
MemberLogin.table = 'member_login'
MemberLogin.primary_key = { "member_id", "login_time" }

MemberLogin:add_reference {
    mode = 'm1',
    to = "Member",
    this_key = 'member_id',
    that_key = 'id',
    ref = 'member',
    default_order = '"login_time"'
}

function MemberLogin:by_pk(member_id, login_time)
    return self:new_selector():add_where { "member_login.member_id = ? AND member_login.login_time = ?", member_id, login_time }:optional_object_mode():exec()
end
