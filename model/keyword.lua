Keyword = mondelefant.new_class()
Keyword.table = 'keyword'
Keyword.primary_key = { "id" }

function Keyword:by_pk(id)
    return self:new_selector():add_where { "id = ?", id }:optional_object_mode():exec()
end

function Keyword:by_name(name)
    return self:new_selector():add_where { "name LIKE ?", name }:optional_object_mode():exec()
end

function Keyword:by_technical(name)
    return self:new_selector():add_where { "technical_keyword = ?", name }:optional_object_mode():exec()
end

function Keyword:by_issue_id(issue_id)
    return self:new_selector():join("issue_keyword", nil, { "keyword.id = issue_keyword.keyword_id AND issue_keyword.issue_id = ?", issue_id }):add_group_by("keyword.id"):add_order_by("keyword.id"):exec()
end

function Keyword:by_name_and_issue_id(name, issue_id)
    self:new_selector():add_where { "name LIKE ?", name }:join("issue_keyword", nil, { "keyword.id = issue_keyword.keyword_id AND issue_keyword.issue_id = ?", issue_id }):add_group_by("keyword.id"):add_order_by("keyword.id"):exec()
end
