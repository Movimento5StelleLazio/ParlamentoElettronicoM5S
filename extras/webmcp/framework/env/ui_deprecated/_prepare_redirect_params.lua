function ui_deprecated._prepare_redirect_params(params, redirect_to)
  if redirect_to then
    for status, settings in pairs(redirect_to) do
      local module, view = settings.module, settings.view
      if not module then
        error("No redirection module specified.")
      end
      if not view then
        error("No redirection view specified.")
      end
      if status == "ok" then
        params["_webmcp_routing." .. status .. ".mode"] = "redirect"
      else
        params["_webmcp_routing." .. status .. ".mode"] = "forward"
      end
      params["_webmcp_routing." .. status .. ".module"] = settings.module
      params["_webmcp_routing." .. status .. ".view"]   = settings.view
      params["_webmcp_routing." .. status .. ".id"]     = settings.id
      if settings.params then
        for key, value in pairs(settings.params) do
          params["_webmcp_routing." .. status .. ".params." .. key] = value
        end
      end
    end
  end
end
