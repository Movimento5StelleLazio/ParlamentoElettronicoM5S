function ui.actions(content)
    slot.select("head", function()
        ui.container { attr = { class = "row-fluid" }, content = content }
    end)
end
