slot.put_into("title", encode.html(_"Password login"))

slot.select("main", function()

  ui.form{
    attr = { class = "vertical" },
    module = "index",
    action = "login", 
    routing = { 
      default = {
        mode = "redirect",
        module = "index",
        view = "index"
      }
    },
    content = function()

      ui.container{
        attr = { class = "lang_chooser" },
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
                  view = "login",
                  params = { lang = lang }
                }
              end
            }
          end
        end
      }

      ui.field.text{ label = _"Username", name = "ident" }
      ui.field.text{ label = _"Password", name = "password" }
      ui.submit{ text = _"Login" }
    end
  }
end)