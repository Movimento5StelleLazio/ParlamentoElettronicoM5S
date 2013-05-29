local genre
local id = param.get_id()
if id then
  genre = Genre:by_id(id)
end

if genre then
  slot.put_into("title", encode.html(_"Genre"))
else
  slot.put_into("title", encode.html(_"New genre"))
end

slot.select("actions", function()
  ui.link{
    content = _"Back",
    module = "genre"
  }
  if genre and app.session.user.write_priv then
    ui.link{
      content = _"Delete",
      form_attr = {
        onsubmit = "return confirm('" .. _'Are you sure?' .. "');"
      },
      module  = "genre",
      action  = "update",
      id      = genre.id,
      params = { delete = true },
      routing = {
        default = {
          mode = "redirect",
          module = "genre",
          view = "index"
        }
      }
    }
  end
end)

slot.select("main", function()
  ui.form{
    attr = { class = "vertical" },
    record = genre,
    readonly = not app.session.user.write_priv,
    module = "genre",
    action = "update",
    id = id,
    routing = {
      default = {
        mode = "redirect",
        module = "genre",
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
