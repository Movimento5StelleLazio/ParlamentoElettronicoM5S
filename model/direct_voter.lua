DirectVoter = mondelefant.new_class()
DirectVoter.table = 'direct_voter'
DirectVoter.primary_key = { "issue_id", "member_id" }

DirectVoter:add_reference{
  mode          = 'm1',
  to            = "Issue",
  this_key      = 'issue_id',
  that_key      = 'id',
  ref           = 'issue',
}

DirectVoter:add_reference{
  mode          = 'm1',
  to            = "Member",
  this_key      = 'member_id',
  that_key      = 'id',
  ref           = 'member',
}

model.has_rendered_content(DirectVoter, RenderedVoterComment, "comment")

function DirectVoter:by_pk(issue_id, member_id)
  return self:new_selector()
    :add_where{ "issue_id = ? AND member_id = ?", issue_id, member_id }
    :optional_object_mode()
    :exec()
end