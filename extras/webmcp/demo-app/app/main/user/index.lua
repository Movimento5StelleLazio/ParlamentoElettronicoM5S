slot.put_into("title", encode.html(_"Users"))

slot.select("actions", function()
  ui.link{
    content = _"Create new user",
    module = "user",
    view = "show"
  }
end)


local selector = User:new_selector():add_order_by('"ident", "id"')

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
            label = _"Ident",
            name = "ident"
          },
          {
            label = _"Name",
            name = "name"
          },
          {
            label = _"w",
            name = "write_priv"
          },
          {
            label = _"Admin",
            name = "admin"
          },
          {
            content = function(record)
              ui.link{
                content = _"Show",
                module  = "user",
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