MemberLogin = mondelefant.new_class()
MemberLogin.table = 'member_login'
MemberLogin.primary_key = { "member_id" }

MemberLogin:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}
