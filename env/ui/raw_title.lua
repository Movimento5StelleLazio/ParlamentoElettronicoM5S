function ui.raw_title(content)
  slot.select("head", function()
    ui.container{ attr = { class = "title" }, content = function()
      slot.put(content)
    end }
  end)
end