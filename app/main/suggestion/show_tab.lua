local suggestion = param.get("suggestion", "table") or Suggestion:by_id(param.get("suggestion_id"))

local tabs = {
  module = "suggestion",
  view = "show_tab",
  static_params = {
    suggestion_id = suggestion.id
  },
}

tabs[#tabs+1] =
  {
    name = "description",
    label = _"Suggestion",
    module = "suggestion",
    view = "_suggestion",
    params = {
      suggestion = suggestion
    }
  }

if app.session.member_id then
  tabs[#tabs+1] =
    {
      name = "opinions",
      label = _"Opinions",
      module = "suggestion",
      view = "_opinions",
      params = {
        suggestion = suggestion
      }
    }
end

ui.tabs(tabs)