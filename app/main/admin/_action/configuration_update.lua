local gui_preset = param.get("gui_preset")

if gui_preset and config.gui_preset[gui_preset] and config.gui_preset[gui_preset].name then
    db:query { "UPDATE system_setting SET gui_preset = ?", config.gui_preset[gui_preset].name }
    slot.put_into("notice", 'GUI Preset: "' .. config.gui_preset[gui_preset].name .. '" saved as default')
    return true
else
    slot.put_into("error", 'Choose a valid GUI Preset')
    return false
end
