local initiative = Initiative:by_id(param.get_id())

slot.put_into("title", _"Revoke initiative")

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

util.help("initiative.revoke")

ui.form{
  attr = { class = "vertical" },
  module = "initiative",
  action = "revoke",
  id = initiative.id,
  routing = {
    ok = {
      mode = "redirect",
      module = "initiative",
      view = "show",
      id = initiative.id
    }
  },
  content = function()
    local initiatives = app.session.member
      :get_reference_selector("supported_initiatives")
      :join("issue", nil, "issue.id = initiative.issue_id")
      :add_field("'Issue #' || issue.id || ': ' || initiative.name", "myname")
      :exec()

    local tmp = { { id = -1, myname = _"Suggest no initiative" }}
    for i, initiative in ipairs(initiatives) do
      tmp[#tmp+1] = initiative
    end
    ui.field.select{
      label = _"Suggested initiative",
      name = "suggested_initiative_id",
      foreign_records = tmp,
      foreign_id = "id",
      foreign_name = "myname",
      value = param.get("suggested_initiative_id", atom.integer)
    }
    slot.put("")
    ui.field.boolean{
      label = _"Are you sure?",
      name = "are_you_sure",
    }

    ui.submit{ text = _"Revoke initiative" }
  end
}