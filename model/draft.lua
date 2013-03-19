Draft = mondelefant.new_class()
Draft.table = 'draft'

-- Many drafts belonging to an initiative
Draft:add_reference{
  mode          = 'm1',
  to            = "Initiative",
  this_key      = 'initiative_id',
  that_key      = 'id',
  ref           = 'initiative',
}

-- Many drafts are authored by a member
Draft:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'author_id',
  that_key      = 'id',
  ref           = 'author',
}

function Draft.object_get:author_name()
  return self.author and self.author.name or _"Unknown author"
end

model.has_rendered_content(Draft, RenderedDraft)
