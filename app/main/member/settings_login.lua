ui.title(_"Change your login")

util.help("member.settings.login", _"Change login")

ui.form{
  attr = { class = "vertical" },
  module = "member",
  action = "update_login",
  routing = {
    ok = {
      mode = "redirect",
      module = "index",
      view = "index"
    }
  },
  content = function()
    ui.field.text{ label = _"Login", name = "login", value = app.session.member.login }
    ui.submit{ value = _"Change login" }
  end
}

