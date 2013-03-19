Opinion = mondelefant.new_class()
Opinion.table = 'opinion'
Opinion.primary_key = { "member_id", "suggestion_id" } 

Opinion:add_reference{
  mode          = 'm1',
  to            = "Initiative",
  this_key      = 'initiative_id',
  that_key      = 'id',
  ref           = 'initiative',
}

Opinion:add_reference{
  mode          = 'm1',
  to            = "Suggestion",
  this_key      = 'suggestion_id',
  that_key      = 'id',
  ref           = 'suggestion',
}

Opinion:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}

function Opinion:by_pk(member_id, suggestion_id)
  return self:new_selector()
    :add_where{ "member_id = ?",     member_id }
    :add_where{ "suggestion_id = ?", suggestion_id }
    :optional_object_mode()
    :exec()
end
