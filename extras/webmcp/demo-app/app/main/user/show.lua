local user
local id = param.get_id()
if id then
  user = User:by_id(id)
end

if user then
  slot.put_into("title", encode.html(_"User"))
else
  slot.put_into("title", encode.html(_"New user"))
end

slot.select("actions", function()
  ui.link{
    content = _"Back",
    module = "user"
  }
  if user then
    ui.link{
      content = _"Delete",
      form_attr = {
        onsubmit = "return confirm('" .. _'Are you sure?' .. "');"
      },
      module  = "user",
      action  = "update",
      id      = user.id,
      params = { delete = true },
      routing = {
        default = {
          mode = "redirect",
          module = "user",
          view = "index"
        }
      }
    }
  end
end)

slot.select("main", function()
  ui.form{
    attr = { class = "vertical" },
    record = user,
    module = "user",
    action = "update",
    id = id,
    routing = {
      default = {
        mode = "redirect",
        module = "user",
        view = "index"
      }
    },
    content = function()
      if id then
        ui.field.integer{ label = _"Id", name = "id", readonly = true }
      end
      ui.field.text{    label = _"Ident",      name = "ident"      }
      ui.field.text{    label = _"Password",   name = "password"   }
      ui.field.text{    label = _"Name",       name = "name"       }
      ui.field.boolean{ label = _"Write Priv", name = "write_priv" }
      ui.field.boolean{ label = _"Admin",      name = "admin"      }
      ui.submit{ text = _"Save" }
    end
  }
end)
