Suggestion = mondelefant.new_class()
Suggestion.table = 'suggestion'

Suggestion:add_reference{
  mode          = 'm1',
  to            = "Initiative",
  this_key      = 'initiative_id',
  that_key      = 'id',
  ref           = 'initiative',
}

Suggestion:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'author_id',
  that_key      = 'id',
  ref           = 'author',
}

Suggestion:add_reference{
  mode          = '1m',
  to            = "Opinion",
  this_key      = 'id',
  that_key      = 'issue_id',
  ref           = 'opinions',
  back_ref      = 'issue',
  default_order = '"id"'
}

model.has_rendered_content(Suggestion, RenderedSuggestion)
