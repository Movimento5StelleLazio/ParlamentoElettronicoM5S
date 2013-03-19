ui.title(_"Change your password")

util.help("member.settings.password", _"Change password")

ui.form{
  attr = { class = "vertical" },
  module = "member",
  action = "update_password",
  routing = {
    ok = {
      mode = "redirect",
      module = "index",
      view = "index"
    }
  },
  content = function()
    ui.field.password{ label = _"Old password", name = "old_password" }
    ui.field.password{ label = _"New password", name = "new_password1" }
    ui.field.password{ label = _"Repeat new password", name = "new_password2" }
    ui.submit{ value = _"Change password" }
  end
}