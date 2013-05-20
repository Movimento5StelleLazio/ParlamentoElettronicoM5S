local media_type
local id = param.get_id()
if id then
  media_type = MediaType:by_id(id)
end

if media_type then
  slot.put_into("title", encode.html(_"Media type"))
else
  slot.put_into("title", encode.html(_"New media type"))
end

slot.select("actions", function()
  ui.link{
    content = _"Back",
    module = "media_type"
  }
  if media_type and app.session.user.write_priv then
    ui.link{
      content = _"Delete",
      form_attr = {
        onsubmit = "return confirm('" .. _'Are you sure?' .. "');"
      },
      module  = "media_type",
      action  = "update",
      id      = media_type.id,
      params = { delete = true },
      routing = {
        default = {
          mode = "redirect",
          module = "media_type",
          view = "index"
        }
      }
    }
  end
end)

slot.select("main", function()
  ui.form{
    attr = { class = "vertical" },
    record = media_type,
    readonly = not app.session.user.write_priv,
    module = "media_type",
    action = "update",
    id = id,
    routing = {
      default = {
        mode = "redirect",
        module = "media_type",
        view = "index"
      }
    },
    content = function()
      if id then
        ui.field.integer{ label = _"Id", name = "id", readonly = true }
      end
      ui.field.text{    label = _"Name",        name = "name"                          }
      ui.field.text{    label = _"Description", name = "description", multiline = true }
      ui.submit{ text = _"Save" }
    end
  }
end)
