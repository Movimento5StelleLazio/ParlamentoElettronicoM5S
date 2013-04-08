function ui.filters(args)
  local el_id = ui.create_unique_id()
  ui.container{
    attr = { class = "ui_filter" },
    content = function()
      for idx, filter in ipairs(args) do
        local filter_name = filter.name or "filter"
        local current_option = atom.string:load(cgi.params[filter_name])
        if not current_option then
          current_option = param.get(filter_name)
        end
        local current_option_valid = false
        for idx, option in ipairs(filter) do
          if current_option == option.name then
            current_option_valid = true
          end
        end
        if not current_option or #current_option == 0 or not current_option_valid then
          current_option = filter[1].name
        end
        local id     = param.get_id_cgi()
        local params = param.get_all_cgi()
        ui.container{
          attr = { class = "ui_filter_head" },
          content = function()
            slot.put(filter.label)
            for idx, option in ipairs(filter) do
              params[filter_name] = option.name
              local attr = {}
              if current_option == option.name then
                attr.class = "active"
                option.selector_modifier(args.selector)
              end
              if idx > 1 then
                slot.put(" ")
              end
              ui.link{
                attr    = attr,
                module  = request.get_module(),
                view    = request.get_view(),
                id      = id,
                params  = params,
                text    = option.label,
                partial = {
                  params = {
                    [filter_name] = option.name
                  }
                }
              }
            end
          end
        }
      end
    end
  }
  ui.container{
    attr = { class = "ui_filter_content" },
    content = function()
      args.content()
    end
  }
end
