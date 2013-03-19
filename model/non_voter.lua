NonVoter = mondelefant.new_class()
NonVoter.table = 'non_voter'
NonVoter.primary_key = { "issue_id", "member_id" }

function NonVoter:by_pk(issue_id, member_id)
  return self:new_selector()
    :add_where{ "issue_id = ? AND member_id = ?", issue_id, member_id }
    :optional_object_mode()
    :exec()
end