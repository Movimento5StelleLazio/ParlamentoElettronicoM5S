--[[--
ui.paginate{
  selector       = selector,       -- a selector for items from the database (will be modified)
  anchor         = anchor,         -- optional name of anchor in document to jump to
  per_page       = per_page,       -- items per page, defaults to 10
  container_attr = container_attr  -- html attr for the container element
  name           = name,           -- name of the CGI get variable, defaults to "page"
  page           = page,           -- directly specify a page, and ignore 'name' parameter
  content        = function()
    ...                            -- code block which should be encapsulated with page selection links
  end
}

This function preceeds and appends the output of the given 'content' function with page selection links. The passed selector will be modified to show only a limited amount ('per_page') of items. The currently displayed page will be determined directly by cgi.params, and not via the param.get(...) function, in order to pass page selections automatically to sub-views.

--]]--

function ui.paginate(args)
  local selector = args.selector
  local per_page = args.per_page or 10
  local name     = args.name or 'page'
  local content  = args.content
  local count_selector = selector:get_db_conn():new_selector()
  count_selector:add_field('count(1)')
  count_selector:add_from(selector)
  count_selector:single_object_mode()
  local count = count_selector:exec().count
  local page_count = 1
  if count > 0 then
    page_count = math.floor((count - 1) / per_page) + 1
  end
  local current_page = atom.integer:load(cgi.params[name]) or 1
  if current_page > page_count then
    current_page = page_count
  end
  selector:limit(per_page)
  selector:offset((current_page - 1) * per_page)
  local id     = request.get_id_string()
  local params = request.get_param_strings()
  local function pagination_elements()
    if page_count > 1 then
      for page = 1, page_count do
        if page > 1 then
          slot.put(" ")
        end
        params[name] = page
        local attr = {}
        if current_page == page then
          attr.class = "active"
        end
        local partial
        if ui.is_partial_loading_enabled() then
          partial = {
            params = {
              [name] = tostring(page)
            }
          }
        end
        ui.link{
          attr   = attr,
          module = request.get_module(),
          view   = request.get_view(),
          id     = id,
          params = params,
          anchor = args.anchor,
          text   = tostring(page),
          partial = partial
        }
      end
    end
  end
  ui.container{
    attr = args.container_attr or { class = 'ui_paginate' },
    content = function()
      ui.container{
        attr = { class = 'ui_paginate_head ui_paginate_select' },
        content = pagination_elements
      }
      ui.container{
        attr = { class = 'ui_paginate_content' },
        content = content
      }
      ui.container{
        attr = { class = 'ui_paginate_foot ui_paginate_select' },
        content = pagination_elements
      }
    end
  }
end
