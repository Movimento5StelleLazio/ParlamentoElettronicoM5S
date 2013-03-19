Vote = mondelefant.new_class()
Vote.table = 'vote'
Vote.primary_key = { "initiative_id", "member_id" }

Vote:add_reference{
  mode          = 'm1',
  to            = "Issue",
  this_key      = 'issue_id',
  that_key      = 'id',
  ref           = 'issue',
}

Vote:add_reference{
  mode          = 'm1',
  to            = "Initiative",
  this_key      = 'initiative_id',
  that_key      = 'id',
  ref           = 'initiative',
}

Vote:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'author_id',
  that_key      = 'id',
  ref           = 'author',
}

function Vote:by_pk(initiative_id, member_id)
  return self:new_selector()
    :add_where{ "initiative_id = ? AND member_id = ?", initiative_id, member_id }
    :optional_object_mode()
    :exec()
end