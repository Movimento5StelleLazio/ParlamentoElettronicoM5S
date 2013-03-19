local suggestion = param.get("suggestion", "table")

execute.view{
  module = "opinion",
  view = "_list",
  params = { 
    opinions_selector = Opinion:new_selector()
      :add_where{ "suggestion_id = ?", suggestion.id }
      :join("member", nil, "member.id = opinion.member_id")
      :add_order_by("member.id DESC")
  }
}
