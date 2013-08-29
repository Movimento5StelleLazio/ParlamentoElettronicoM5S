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
  ui.container{ attr = { class = "span12 alert alert-simple issue_box paper text-center"}, content = function()
  ui.form{
    attr = { class = "orizontal" },
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
        view = "member_edit"
      },
      error = {
        mode = "redirect",
        modules = "auditor",
        view = "index"
      }
    },
    content = function()
      ui.field.text{     label = _"Name",        name = "name" }
      ui.field.text{     label = _"Surname",     name = "surname" }
      ui.field.text{     label = _"NIN",         name = "nin" }
      --if member and member.activated then
      --  ui.field.text{     label = _"Login name",        name = "login" }
      --end
      ui.field.text{     label = _"Email", name = "notify_email" }
  
      slot.put("<br />")
      
      if not member or not member.activated then
        ui.field.boolean{  label = _"Send invite?",       name = "invite_member" }
      end
      
      if member and member.activated then
        ui.field.boolean{  label = _"Lock member?",       name = "locked" }
      end
      
      ui.field.boolean{ 
        label = _"Member inactive?", name = "deactivate",
        readonly = member and member.active, value = member and member.active == false
      }
      
      slot.put("<br />")
      ui.submit{         text  = _"Save" }
    end
  }
  end }
end }
