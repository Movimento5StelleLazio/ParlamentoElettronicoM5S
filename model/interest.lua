Interest = mondelefant.new_class()
Interest.table = 'interest'
Interest.primary_key = { "issue_id", "member_id" }
Interest:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}

Interest:add_reference{
  mode          = 'm1',
  to            = "Issue",
  this_key      = 'issue_id',
  that_key      = 'id',
  ref           = 'issue',
}

function Interest:by_pk(issue_id, member_id)
  return self:new_selector()
    :add_where{ "issue_id = ? AND member_id = ?", issue_id, member_id }
    :optional_object_mode()
    :exec()
end