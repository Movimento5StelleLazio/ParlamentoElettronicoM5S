RenderedDraft = mondelefant.new_class()
RenderedDraft.table = 'rendered_draft'
RenderedDraft.primary_key = { "draft_id", "format" }

RenderedDraft:add_reference{
  mode          = 'm1',
  to            = "Draft",
  this_key      = 'draft_id',
  that_key      = 'id',
  ref           = 'draft',
}
