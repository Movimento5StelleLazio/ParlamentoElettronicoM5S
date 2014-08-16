IssueKeyword = mondelefant.new_class()
IssueKeyword.table = 'issue_keyword'
IssueKeyword.primary_key = { "issue_id", "keyword_id" }

function IssueKeyword:by_pk(issue_id, keyword_id)
    return self:new_selector():add_where { "issue_id = ? AND keyword_id = ?", issue_id, keyword_id }:optional_object_mode():exec()
end
