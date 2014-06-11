slot.put_into("title", encode.html(_"Genres"))

slot.select("actions", function()
  if app.session.user.write_priv then
    ui.link{
      content = _"Create new genre",
      module = "genre",
      view = "show"
    }
  end
end)


local selector = Genre:new_selector():add_order_by('"name", "id"')

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
                module  = "genre",
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
