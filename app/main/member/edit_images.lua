ui.title(_"Upload images")

util.help("member.edit_images", _"Images")

ui.form{
  record = app.session.member,
  attr = { 
    class = "vertical",
    enctype = 'multipart/form-data'
  },
  module = "member",
  action = "update_images",
  routing = {
    ok = {
      mode = "redirect",
      module = "member",
      view = "show",
      id = app.session.member_id
    }
  },
  content = function()
    execute.view{
      module = "member_image",
      view = "_show",
      params = {
        member = app.session.member, 
        image_type = "avatar"
      }
    }
    ui.field.image{ field_name = "avatar", label = _"Avatar" }
    execute.view{
      module = "member_image",
      view = "_show",
      params = {
        member = app.session.member, 
        image_type = "photo"
      }
    }
    ui.field.image{ field_name = "photo", label = _"Photo" }
    ui.submit{ value = _"Save" }
  end
}