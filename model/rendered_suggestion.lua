RenderedSuggestion = mondelefant.new_class()
RenderedSuggestion.table = 'rendered_suggestion'
RenderedSuggestion.primary_key = { "suggestion_id", "format" }

RenderedSuggestion:add_reference{
  mode          = 'm1',
  to            = "Suggestion",
  this_key      = 'suggestion_id',
  that_key      = 'id',
  ref           = 'suggestion',
}
