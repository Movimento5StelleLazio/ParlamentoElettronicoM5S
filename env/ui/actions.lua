function ui.actions(content)
  slot.select("head", function()
    ui.container{ attr = { class = "actions" }, content = content }
  end)
end