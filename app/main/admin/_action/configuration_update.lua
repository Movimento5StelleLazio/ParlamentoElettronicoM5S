local gui_presetId = param.get("gui_preset", atom.integer)

if gui_presetId ~= nil  and config.gui_preset[gui_presetId] and config.gui_preset[gui_presetId].name then
  db:query{"UPDATE system_setting SET gui_preset = ?",config.gui_preset[gui_presetId].name}
  slot.put_into("notice",'GUI Preset: "'..config.gui_preset[gui_presetId].name..'" saved as default')
  return true
else
  slot.put_into("error",'Choose a valid GUI Preset')
  return false
end
