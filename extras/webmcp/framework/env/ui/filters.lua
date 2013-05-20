--[[--
ui.filters{
  selector = selector,  -- selector to be modified
  label    = label,     -- text to be displayed when filters are collapsed
  {
    name  = name1,      -- name of first filter (used as GET param)
    label = label1,     -- label of first filter
    {
      name  = name1a,   -- name of first option of first filter
      label = label1a,  -- label of first option of first filter
      selector_modifier = function(selector)
        ...
      end
    },
    {
      name  = name1b,   -- name of second option of first filter
      label = label1b,  -- label of second option of first filter
      selector_modifier = function(selector)
        ...
      end
    },
    ...
  },
  {
    name  = name2,      -- name of second filter (used as GET param)
    label = label2,     -- label of second filter
    {
      ...
    }, {
      ...
    },
    ...
  },
  ...
  content = function()
    ...                 -- inner code where filter is to be applied
  end
}

--]]--

function ui.filters(args)
  local el_id = ui.create_unique_id()
  ui.container{
    attr = { class = "ui_filter" },
    content = function()
      ui.container{
        attr = {
          class = "ui_filter_closed_head"
        },
        content = function()
          ui.tag{
            tag = "span",
            content = function()
              local current_options = {}
              for idx, filter in ipairs(args) do
                local filter_name = filter.name or "filter"
                local current_option = atom.string:load(cgi.params[filter_name])
                if not current_option then
                  current_option = param.get(filter_name)
                end
                if not current_option or #current_option == 0 then
                  current_option = filter[1].name
                end
                for idx, option in ipairs(filter) do
                  if current_option == option.name then
                    current_options[#current_options+1] = encode.html(filter.label) .. ": " .. encode.html(option.label)
                  end
                end
              end
              slot.put(table.concat(current_options, "; "))
            end
          }
          slot.put(" (")
          ui.link{
            attr = {
              onclick = "this.parentNode.style.display='none'; document.getElementById('" .. el_id .. "_head').style.display='block'; return(false);"
            },
            text = args.label,
            external = "#"
          }
          slot.put(")")
        end
      }
      ui.container{
        attr = {
          id = el_id .. "_head",
          style = "display: none;"
        },
        content = function()
          for idx, filter in ipairs(args) do
            local filter_name = filter.name or "filter"
            local current_option = atom.string:load(cgi.params[filter_name])
            if not current_option then
              current_option = param.get(filter_name)
            end
            if not current_option or #current_option == 0 then
              current_option = filter[1].name
            end
            local id     = request.get_id_string()
            local params = request.get_param_strings()
            ui.container{
              attr = { class = "ui_filter_head" },
              content = function()
                slot.put(filter.label or "Filter", ": ")
                for idx, option in ipairs(filter) do
                  params[filter_name] = option.name
                  local attr = {}
                  if current_option == option.name then
                    attr.class = "active"
                    option.selector_modifier(args.selector)
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
    end
  }
  ui.container{
    attr = { class = "ui_filter_content" },
    content = function()
      args.content()
    end
  }
end
