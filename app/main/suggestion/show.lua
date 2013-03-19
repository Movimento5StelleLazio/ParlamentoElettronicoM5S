local suggestion = Suggestion:by_id(param.get_id())

-- redirect to initiative if suggestion does not exist anymore
if not suggestion then
  local initiative_id = param.get('initiative_id', atom.integer)
  if initiative_id then
    slot.reset_all{except={"notice", "error"}}
    request.redirect{
      module='initiative',
      view='show',
      id=initiative_id,
      params = { tab = "suggestions" }
    }
  else
    slot.put_into('error', _"Suggestion does not exist anymore")
  end
  return
end


app.html_title.title = suggestion.name
app.html_title.subtitle = _("Suggestion ##{id}", { id = suggestion.id })

ui.title(_"Suggestion for initiative: '#{name}'":gsub("#{name}", suggestion.initiative.name))

ui.actions(function()
  ui.link{
    content = function()
        ui.image{ static = "icons/16/resultset_previous.png" }
        slot.put(_"Back")
    end,
    module = "initiative",
    view = "show",
    id = suggestion.initiative.id,
    params = { tab = "suggestions" }
  }
end)

execute.view{
  module = "suggestion",
  view = "show_tab",
  params = {
    suggestion = suggestion
  }
}
