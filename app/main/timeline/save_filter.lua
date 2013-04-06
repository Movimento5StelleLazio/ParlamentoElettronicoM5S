slot.put_into("title", _"Save timeline filters")

slot.select("actions", function()
  ui.link{
    content = function()
        ui.image{ static = "icons/16/cancel.png" }
        slot.put(_"Cancel")
    end,
    module = "timeline",
    view = "index"
  }
end)

ui.form{
  attr = { class = "vertical" },
  module = "timeline",
  action = "save",
  content = function()
    ui.field.text{
      label = _"Name",
      name = "name",
      value = param.get("current_name")
    }
    ui.submit{
      text = _"Save"
    }
  end
}
