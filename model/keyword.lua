Keyword = mondelefant.new_class()
Keyword.table = 'keyword'
Keyword.primary_key = { "id" }


function Keyword:by_pk(id)
  return self:new_selector()
    :add_where{ "id = ?", id }
    :optional_object_mode()
    :exec()
end

function Keyword:by_name(name)
  return self:new_selector()
    :add_where{ "name = ?", name }
    :optional_object_mode()
    :exec()
end
