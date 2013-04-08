function util.help(id, title)
  if not app.session.member_id then
    return
  end
  local setting_key = "liquidfeedback_frontend_hidden_help_" .. id
  local setting = Setting:by_pk(app.session.member.id, setting_key)
  if not setting then
    ui.container{
      attr = { class = "help help_visible" },
      content = function()
        ui.image{
          attr = { class = "help_icon" },
          static = "icons/16/help.png"
        }
        ui.container{
          attr = { class = "help_actions" },
          content = function()
            ui.link{
              text   = _"Hide this help message",
              module = "help",
              action = "update",
              params = {
                help_ident = id,
                hide = true
              },
              routing = {
                default = {
                  mode = "redirect",
                  module = request.get_module(),
                  view = request.get_view(),
                  id = param.get_id_cgi(),
                  params = param.get_all_cgi()
                }
              }
            }
          end
        }
        local lang = locale.get("lang")
        local basepath = request.get_app_basepath() 
        local file_name = basepath .. "/locale/help/" .. id .. "." .. lang .. ".txt.html"
        local file = io.open(file_name)
        if file ~= nil then
          local help_text = file:read("*a")
          if #help_text > 0 then
            ui.container{
              attr = { class = "wiki" },
              content = function()
                slot.put(help_text)
              end
            }
          else
            ui.field.text{ value = _("Empty help text: #{id}.#{lang}.txt", { id = id, lang = lang }) }
          end
        else
          ui.field.text{ value = _("Missing help text: #{id}.#{lang}.txt", { id = id, lang = lang }) }
        end
      end
    }
  else
    if util._hidden_helps == nil then
      util._hidden_helps = {}
    end
    util._hidden_helps[#util._hidden_helps+1] = {
      id = id,
      title = title
    }
  end
end