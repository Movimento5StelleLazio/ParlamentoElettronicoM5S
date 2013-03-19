local initiative = Initiative:by_id(param.get("initiative_id"))

slot.put_into("title", _"Invite an initiator to initiative")

slot.select("actions", function()
  ui.link{
    content = function()
        ui.image{ static = "icons/16/cancel.png" }
        slot.put(_"Cancel")
    end,
    module = "initiative",
    view = "show",
    id = initiative.id,
    params = {
      tab = "initiators"
    }
  }
end)

util.help("initiative.add_initiator", _"Invite an initiator to initiative")

ui.form{
  attr = { class = "vertical" },
  module = "initiative",
  action = "add_initiator",
  params = {
    initiative_id = initiative.id,
  },
  routing = {
    ok = {
      mode = "redirect",
      module = "initiative",
      view = "show",
      id = initiative.id,
      params = {
        tab = "initiators",
      }
    }
  },
  content = function()
    local records = {
      {
        id = "-1",
        name = _"Choose member"
      }
    }
    local contact_members = app.session.member:get_reference_selector("saved_members"):add_order_by("name"):exec()
    for i, record in ipairs(contact_members) do
      records[#records+1] = record
    end
    ui.field.select{
      label = _"Member",
      name = "member_id",
      foreign_records = records,
      foreign_id = "id",
      foreign_name = "name"
    }
    ui.submit{ text = _"Save" }
  end
}