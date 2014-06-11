slot.put_into("title", encode.html(_"Media types"))

slot.select("actions", function()
  if app.session.user.write_priv then
    ui.link{
      content = _"Create new media type",
      module = "media_type",
      view = "show"
    }
  end
end)


local selector = MediaType:new_selector():add_order_by('"name", "id"')

slot.select("main", function()
  ui.paginate{
    selector = selector,
    content = function()
      ui.list{
        records = selector:exec(),
        columns = {
          {
            field_attr = { style = "float: right;" },
            label = _"Id",
            name = "id"
          },
          {
            label = _"Name",
            name = "name"
          },
          {
            content = function(record)
              ui.link{
                content = _"Show",
                module  = "media_type",
                view    = "show",
                id      = record.id
              }
            end
          },
        }
      }
    end
  }
end)
