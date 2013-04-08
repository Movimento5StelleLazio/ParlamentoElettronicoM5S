Timeline = mondelefant.new_class()
Timeline.table = 'timeline'

Timeline:add_reference{
  mode          = '11',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member'
}

Timeline:add_reference{
  mode          = '11',
  to            = "Issue",
  this_key      = 'issue_id',
  that_key      = 'id',
  ref           = 'issue'
}

Timeline:add_reference{
  mode          = '11',
  to            = "Initiative",
  this_key      = 'initiative_id',
  that_key      = 'id',
  ref           = 'initiative'
}

Timeline:add_reference{
  mode          = '11',
  to            = "Draft",
  this_key      = 'draft_id',
  that_key      = 'id',
  ref           = 'draft'
}

Timeline:add_reference{
  mode          = '11',
  to            = "Suggestion",
  this_key      = 'suggestion_id',
  that_key      = 'id',
  ref           = 'suggestion'
}
