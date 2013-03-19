local id = param.get_id()

local member = Member:by_id(id)

if member then
  ui.title(_("Member: '#{identification}' (#{name})", { identification = member.identification, name = member.name }))
else
  ui.title(_"Register new member")
end

local units_selector = Unit:new_selector()
  
if member then
  units_selector
    :left_join("privilege", nil, { "privilege.member_id = ? AND privilege.unit_id = unit.id", member.id })
    :add_field("privilege.voting_right", "voting_right")
end

local units = units_selector:exec()
  
ui.form{
  attr = { class = "vertical" },
  module = "admin",
  action = "member_update",
  id = member and member.id,
  record = member,
  readonly = not app.session.member.admin,
  routing = {
    default = {
      mode = "redirect",
      modules = "admin",
      view = "member_list"
    }
  },
  content = function()
    ui.field.text{     label = _"Identification", name = "identification" }
    ui.field.text{     label = _"Notification email", name = "notify_email" }
    if member and member.activated then
      ui.field.text{     label = _"Screen name",        name = "name" }
      ui.field.text{     label = _"Login name",        name = "login" }
    end
    ui.field.boolean{  label = _"Admin?",       name = "admin" }

    slot.put("<br />")
    
    for i, unit in ipairs(units) do
      ui.field.boolean{
        name = "unit_" .. unit.id,
        label = unit.name,
        value = unit.voting_right
      }
    end
    slot.put("<br /><br />")

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
