local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1]
if gui_preset and config.gui_preset then
  for i=1, #config.gui_preset do
--    slot.put_into("notice", 'gui_preset: "'..config.gui_preset[i].name..'" gui_preset: "'..gui_preset..'"')
    if config.gui_preset[i].name and config.gui_preset[i].name  == gui_preset then
      execute.view{ module = "index", view = config.gui_preset[i].start_page }
      break
    end
  end
else
  execute.view{ module = "index", view = "_index_default" }
end
