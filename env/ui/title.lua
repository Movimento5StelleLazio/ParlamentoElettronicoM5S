function ui.title(content)
  slot.select("head", function()
    ui.container{ attr = { class = "title" }, content = content }
  end)
end