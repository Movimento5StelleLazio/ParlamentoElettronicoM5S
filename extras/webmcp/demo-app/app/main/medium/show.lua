local medium
local id = param.get_id()
if id then
  medium = Medium:by_id(id)
end

if medium then
  slot.put_into("title", encode.html(_"Medium"))
else
  slot.put_into("title", encode.html(_"New medium"))
end

slot.select("actions", function()
  ui.link{
    content = _"Back",
    module = "medium"
  }
  if medium and app.session.user.write_priv then
    ui.link{
      content = _"Delete",
      form_attr = {
        onsubmit = "return confirm(" .. encode.json(_'Are you sure?') .. ");"
      },
      module  = "medium",
      action  = "update",
      id      = medium.id,
      params = { delete = true },
      routing = {
        default = {
          mode = "redirect",
          module = "medium",
          view = "index"
        }
      }
    }
  end
end)

slot.select("main", function()
  ui.form{
    attr = { class = "vertical" },
    record = medium,
    readonly = not app.session.user.write_priv,
    module = "medium",
    action = "update",
    id = id,
    routing = {
      default = {
        mode = "redirect",
        module = "medium",
        view = "index"
      }
    },
    content = function()
      if id then
        ui.field.integer{ label = _"Id", name = "id", readonly = true }
      end
      ui.field.select{
        label = _"Media type",
        name  = "media_type_id",
        foreign_records = MediaType:new_selector():exec(),
        foreign_id = "id",
        foreign_name = "name"
      }
      ui.field.text{    label = _"Name",           name = "name"           }
      ui.field.boolean{ label = _"Copy protected", name = "copyprotected"  }

      ui.multiselect{
        name               = "genres[]",
        label              = _"Genres",
        style              = "select",
        attr = { size = 5 },
        foreign_records    = Genre:new_selector():exec(),
        connecting_records = medium and medium.classifications or {},
        own_id             = "id",
        own_reference      = "medium_id",
        foreign_reference  = "genre_id",
        foreign_id         = "id",
        foreign_name       = "name",
      }
      local tracks = medium and medium.tracks or {}
      for i = 1, 5 do
        tracks[#tracks+1] = Track:new()
      end
      ui.list{
        label = _"Tracks",
        prefix = "tracks",
        records = tracks,
        columns = {
          {
            label = _"Pos",
            name = "position",
          },
          {
            label = _"Name",
            name = "name",
          },
          {
            label = _"Description",
            name = "description",
          },
          {
            label = _"Duration",
            name = "duration",
          },
          {
            content = function()
              ui.field.hidden{ name = "id" }
            end
          }
        }
      }

      ui.submit{ text = _"Save" }
    end
  }
end)
