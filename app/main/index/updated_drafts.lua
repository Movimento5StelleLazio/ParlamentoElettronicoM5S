local initiatives_selector = Initiative:selector_for_updated_drafts(app.session.member_id)

ui.container{
  attr = { class = "heading" },
  content = _"Open initiatives you are supporting which has been updated their draft:"
}

slot.put("<br />")

execute.view{
  module = "initiative",
  view = "_list",
  params = { initiatives_selector = initiatives_selector }
}
