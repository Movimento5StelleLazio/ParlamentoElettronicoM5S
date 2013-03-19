ui.title(_"Change your screen name")

util.help("member.settings.name", _"Change name")

ui.form{
  attr = { class = "vertical" },
  module = "member",
  action = "update_name",
  routing = {
    ok = {
      mode = "redirect",
      module = "index",
      view = "index"
    }
  },
  content = function()
    ui.field.text{ label = _"Name", name = "name", value = app.session.member.name }
    ui.submit{ value = _"Change name" }
  end
}
