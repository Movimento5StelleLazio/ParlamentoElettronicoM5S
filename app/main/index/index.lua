local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1]

if not gui_preset or not config.gui_preset then
  execute.view{ module = "index", view = "_index_default" }
else
  for i=1, #config.gui_preset do
    if config.gui_preset[i].name and config.gui_preset[i].name  == gui_preset then
      execute.view{ module = "index", view = config.gui_preset[i].start_page }
      return
    end
  end
end
execute.view{ module = "index", view = "_index_default" }
