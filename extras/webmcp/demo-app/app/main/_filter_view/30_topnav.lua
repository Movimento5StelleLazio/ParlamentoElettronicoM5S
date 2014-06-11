-- display navigation only, if user is logged in
if app.session.user_id == nil then
  execute.inner()
  return
end

slot.select("topnav", function()
  ui.link{
    attr = { class = "nav" },
    text = _"Home",
    module = "index",
    view = "index"
  }
  ui.link{
    attr = { class = "nav" },
    text = _"Media",
    module = "medium"
  }
  ui.link{
    attr = { class = "nav" },
    text = _"Media types",
    module = "media_type"
  }
  ui.link{
    attr = { class = "nav" },
    text = _"Genres",
    module = "genre"
  }
  if app.session.user.admin then
    ui.link{
    attr = { class = "nav" },
      text = _"Users",
      module = "user"
    }
  end
  ui.container{
    attr = { class = "nav lang_chooser" },
    content = function()
      for i, lang in ipairs{"en", "de", "es"} do
        ui.container{
          content = function()
            ui.link{
              content = function()
                ui.image{
                  static = "lang/" .. lang .. ".png",
                  attr = { alt = lang }
                }
                slot.put(lang)
              end,
              module = "index",
              action = "set_lang",
              params = { lang = lang },
              routing = {
                default = {
                  mode = "redirect",
                  module = request.get_module(),
                  view = request.get_view(),
                  id = request.get_id_string(),
                  params = request.get_param_strings()
                }
              }
            }
          end
        }
      end
    end
  }

  ui.link{
    attr = { class = "nav" },
    text = _"Logout",
    module = "index",
    action = "logout",
    redirect_to = {
      ok = {
        module = "index",
        view = "login"
      }
    }
  }
end)

execute.inner()
