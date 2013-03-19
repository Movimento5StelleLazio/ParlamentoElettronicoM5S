execute.inner()

if util._hidden_helps ~= nil then
  slot.select("help_hidden", function()
    for i, help in ipairs(util._hidden_helps) do 
      ui.link{
        attr = {
          class = "help_hidden",
          title = _("Help for: #{text}", { text = help.title })
        },
        module = "help",
        action = "update",
        params = {
          help_ident = help.id,
          hide = false
        },
        routing = {
          default = {
            mode = "redirect",
            module = request.get_module(),
            view = request.get_view(),
            id = param.get_id_cgi(),
            params = param.get_all_cgi()
          }
        },
        content = function()
          ui.image{
            attr = { class = "help_icon" },
            static = "icons/16/help.png"
          }
        end,
        text = _"Show help text"
      }
    end
  end)
end
