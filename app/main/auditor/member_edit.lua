slot.set_layout("custom")
local id = param.get_id()

local member = Member:by_id(id)

ui.container{ attr = { class = "row-fluid" }, content = function()
  ui.container{ attr = { class = "span12 well" }, content = function()
    ui.container{ attr = { class = "row-fluid" }, content = function()
      ui.container{ attr = { class = "span12 text-center" }, content = function()
        ui.heading{ level = 1, attr = { class = "uppercase"  }, content = function()
          if member then
            slot.put(_("Member: #{name} #{surname}", { name = member.name, surname = member.surname }))
          else
            slot.put(_"Register new member")
          end
        end }
      end }
    end }
  end }
end }

ui.container{ attr = { class = "row-fluid spaceline2" }, content = function()
  ui.container{ attr = { class = "span12 alert alert-simple issue_box paper"}, content = function()
    ui.form{
      attr = { class = "", role="form" },
      module = "auditor",
      action = "member_update",
      id = member and member.id,
      record = member,
      readonly = not app.session.member.auditor,
      routing = {
        default = {
          mode = "redirect",
          modules = "auditor",
          view = "index"
        },
        ok = {
          mode = "redirect",
          modules = "auditor",
          view = "member_edit",
          id = member.id
        },
        error = {
          mode = "redirect",
          modules = "auditor",
          view = "index"
        }
      },
      content = function()
        ui.field.text{ label_attr={class="auditor_input_label"},  label = _"Name",        name = "name" }
        ui.field.text{ label_attr={class="auditor_input_label"},  label = _"Surname",     name = "surname" }
        ui.field.text{ label_attr={class="auditor_input_label"}, label = _"NIN",         name = "nin" }
        --if member and member.activated then
        --  ui.field.text{     label = _"Login name",        name = "login" }
        --end
        ui.field.text{ label_attr={class="auditor_input_label"},  label = _"Email", name = "notify_email" }
        ui.field.text{label_attr={class="auditor_input_label"},   label = _"Birthplace", name = "birthplace" }
        --[[
        ui.tag{tag = "label", content =_"Birthdate"}
        ui.tag{tag = "input", attr={placeholder="mm"},content =""}
        --]]
        ui.field.text{label_attr={class="auditor_input_label"},   label = _"Birthdate", name = "birthdate" }
    
        slot.put("<br />")
        
        if not member or not member.activated then
          ui.field.boolean{label_attr={class="auditor_input_label"},  label = _"Send invite?",       name = "invite_member" }
        end
        
        if member and member.activated then
          ui.field.boolean{label_attr={class="auditor_input_label"},  label = _"Lock member?",       name = "locked" }
        end
        
        ui.field.boolean{ 
          label_attr={class="auditor_input_label"},
          label = _"Member inactive?", name = "deactivate",
          readonly = member and member.active, value = member and member.active == false
        }
        
        slot.put("<br />")
        
        ui.container{ attr = { class = "row-fluid text-center" }, content = function()
            ui.container{ attr = { class = "span6 offset3" }, content = function()
              ui.tag{
                tag="button",
                attr = { type="submit", class="btn btn-primary btn-large fixclick" },
                content= function()
                  ui.heading{ level=4, attr = { class="inline-block"}, content= _"Save"}
                end
              }
            end }
          end }
      end
    }
  end }
end }
