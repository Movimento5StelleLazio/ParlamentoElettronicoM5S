RenderedMemberStatement = mondelefant.new_class()
RenderedMemberStatement.table = 'rendered_member_statement'
RenderedMemberStatement.primary_key = { "member_id", "format" }

RenderedMemberStatement:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}
