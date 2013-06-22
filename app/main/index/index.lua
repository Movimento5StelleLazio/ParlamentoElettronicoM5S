local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1] or 'default'
 
if gui_preset and config.gui_preset and config.gui_preset[gui_preset]and config.gui_preset[gui_preset].name and config.gui_preset[gui_preset].name == gui_preset then
  execute.view{ module = "index", view = config.gui_preset[gui_preset].start_page }
  return
else
  execute.view{ module = "index", view = "_index_default" }
end
