local initiative = param.get("initiative", "table")
local initiator = param.get("initiator", "table")
local initiators_members_selector = param.get("initiators_members_selector", "table")

local initiator_count = initiators_members_selector:count()

if initiator and initiator.accepted and not initiative.issue.fully_frozen and not initiative.issue.closed and not initiative.revoked then
  ui.link{
    attr = { class = "action" },
    content = function()
      ui.image{ static = "icons/16/user_add.png" }
      slot.put(_"Invite initiator")
    end,
    module = "initiative",
    view = "add_initiator",
    params = { initiative_id = initiative.id }
  }
  if initiator_count > 1 then
    ui.link{
      content = function()
        ui.image{ static = "icons/16/user_delete.png" }
        slot.put(_"Remove initiator")
      end,
      module = "initiative",
      view = "remove_initiator",
      params = { initiative_id = initiative.id }
    }
  end
end
if initiator and initiator.accepted == false then
    ui.link{
      image  = { static = "icons/16/user_delete.png" },
      text   = _"Cancel refuse of invitation",
      module = "initiative",
      action = "remove_initiator",
      params = {
        initiative_id = initiative.id,
        member_id = app.session.member.id
      },
      routing = {
        ok = {
          mode = "redirect",
          module = "initiative",
          view = "show",
          id = initiative.id
        }
      }
    }
end

execute.view{
  module = "member",
  view = "_list",
  params = {
    members_selector = initiators_members_selector,
    initiator = initiator
  }
}
