slot.set_layout("custom")
ui.container{ attr = { class = "row-fluid" }, content = function()
  ui.heading{ level = 1, attr = { class = "span12 text-center" }, content = _"Certified users" }
end }

ui.container{ attr = { class = "row-fluid spaceline2" }, content = function()
  ui.container{ attr = { class = "span12 alert alert-simple issue_box paper text-center"}, content = function()
    local members_selector = Member:new_selector()
    members_selector:add_where{ "certifier_id = ?", app.session.member_id }

    ui.paginate{
      selector = members_selector,
      per_page = 30,
      content = function()
        ui.list{
          records = members_selector:exec(),
          columns = {
            {
              field_attr = { style = "padding-left: 5px;padding-right: 5px;text-align: right;border: 1px solid black;" },
              label = _"Id",
              name = "id"
            },
            {
              field_attr = { style = "padding-left: 5px;padding-right: 5px;border: 1px solid black;" },
              label = _"Name",
              name = "name"
            },
            {
              field_attr = { style = "padding-left: 5px;padding-right: 5px;border: 1px solid black;" },
              label = _"NIN",
              name = "nin"
            },
            {
              field_attr = { style = "padding-left: 5px;padding-right: 5px;border: 1px solid black;" },
              label = _"Surname",
              name = "surname"
            },
            {
              field_attr = { style = "padding-left: 5px;padding-right: 5px;border: 1px solid black;" },
              label = _"State",
              content = function(record)
                if not record.activated then
                  ui.field.text{ value = "not activated" }
                elseif not record.active then
                  ui.field.text{ value = "inactive" }
                else
                  ui.field.text{ value = "active" }
                end
              end
            },
            {
              field_attr = { style = "padding-left: 5px;padding-right: 5px;border: 1px solid black;" },
              label = _"Locked?",
              content = function(record)
                if record.locked then
                  ui.field.text{ value = "locked" }
                end
              end
            },
            {
              field_attr = { style = "padding-left: 5px;padding-right: 5px;border: 1px solid black;" },
              label = _"Actions",
              content = function(record)
                ui.link{
                  attr = { class = "action admin_only" },
                  text = _"Edit",
                  module = "admin",
                  view = "member_edit",
                  id = record.id
                }
              end
            }
          }
        }
      end 
    }
  end }
end }

