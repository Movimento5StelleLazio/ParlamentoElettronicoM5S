local initiative = Initiative:by_id(param.get("initiative_id"))

local initiator = Initiator:by_pk(initiative.id, app.session.member.id)
if not initiator or initiator.accepted ~= true then
  error("access denied")
end

slot.put_into("title", _"Remove initiator from initiative")

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

util.help("initiative.remove_initiator", _"Remove initiator from initiative")

ui.form{
  attr = { class = "vertical" },
  module = "initiative",
  action = "remove_initiator",
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
        name = _"Choose initiator"
      }
    }
    local members = initiative:get_reference_selector("initiating_members"):add_where("accepted OR accepted ISNULL"):exec()
    for i, record in ipairs(members) do
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