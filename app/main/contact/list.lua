local contacts_selector = Contact:build_selector{
  member_id = app.session.member_id,
  order = "name"
}

ui.title(_"Contacts")


util.help("contact.list")


ui.paginate{
  selector = contacts_selector,
  content = function()
    local contacts = contacts_selector:exec()
    if #contacts == 0 then
      ui.field.text{ value = _"You didn't save any member as contact yet." }
    else
      ui.list{
        records = contacts,
        columns = {
          {
            label = _"Name",
            content = function(record)
              ui.link{
                text = record.other_member.name,
                module = "member",
                view = "show",
                id = record.other_member_id
              }
            end
          },
          {
            label = _"Published",
            content = function(record)
              ui.field.boolean{ value = record.public }
            end
          },
          {
            content = function(record)
              if record.public then
                ui.link{
                  attr = { class = "action" },
                  text = _"Hide",
                  module = "contact",
                  action = "add_member",
                  id = record.other_member_id,
                  params = { public = false },
                  routing = {
                    default = {
                      mode = "redirect",
                      module = request.get_module(),
                      view = request.get_view(),
                      id = param.get_id_cgi(),
                      params = param.get_all_cgi()
                    }
                  }
                }
              else
                ui.link{
                  attr = { class = "action" },
                  text = _"Publish",
                  module = "contact",
                  action = "add_member",
                  id = record.other_member_id,
                  params = { public = true },
                  routing = {
                    default = {
                      mode = "redirect",
                      module = request.get_module(),
                      view = request.get_view(),
                      id = param.get_id_cgi(),
                      params = param.get_all_cgi()
                    }
                  }
                }
              end
            end
          },
          {
            content = function(record)
              ui.link{
                attr = { class = "action" },
                text = _"Remove",
                module = "contact",
                action = "remove_member",
                id = record.other_member_id,
                routing = {
                  default = {
                    mode = "redirect",
                    module = request.get_module(),
                    view = request.get_view(),
                    id = param.get_id_cgi(),
                    params = param.get_all_cgi()
                  }
                }
              }
            end
          },
        }
      }
    end
  end
}
