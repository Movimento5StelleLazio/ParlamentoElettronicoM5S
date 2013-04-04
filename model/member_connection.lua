MemberConnection = mondelefant.new_class()
MemberConnection.table = 'member_connection'
MemberConnection.primary_key = { "member_id" }

RenderedDraft:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}
