--[[--
ui.link{
  external  = external,   -- external URL
  static    = static,     -- URL relative to the static file directory
  module    = module,     -- module name
  view      = view,       -- view name
  action    = action,     -- action name
  attr      = attr,       -- for views: table of HTML attributes
  a_attr    = a_attr,     -- for actions: table of HTML attributes for the "a" tag
  form_attr = form_attr,  -- for actions: table of HTML attributes for the "form" tag
  id        = id,         -- optional id to be passed to the view or action to select a particular data record
  params    = params,     -- optional parameters to be passed to the view or action
  routing   = routing,    -- optional routing information for action links, as described for ui.form{...}
  anchor    = anchor,     -- for views: anchor in destination URL
  text      = text,       -- link text
  content   = content,    -- link content (overrides link text, except for submit buttons for action calls without JavaScript)
  partial   = {           -- parameters for partial loading, see below
    module = module,
    view   = view,
    id     = id,
    params = params,
    target = target
  }
}

This function inserts a link into the active slot. It may be either an internal application link ('module' given and 'view' or 'action' given), or a link to an external web page ('external' given), or a link to a file in the static file directory of the application ('static' given).

When passing a table as "partial" argument, AND if partial loading has been enabled by calling ui.enable_partial_loading(), then ui._partial_load_js is
used to create an onclick event (onsubmit event for action links). The
"partial" setting table is passed to ui._partial_load_js as first argument.
See ui._partial_load_js(...) for further documentation.

--]]--

function ui.link(args)
  local args = args or {}
  local content = args.content or args.text
  assert(content, "ui.link{...} needs a text.")
  local function wrapped_content()
    if args.image then
      ui.image(args.image)
    end
    if type(content) == "function" then
      content()
    else
      slot.put(encode.html(content))
    end
  end
  if args.action then
    local form_attr   = table.new(args.form_attr)
    local form_id
    if form_attr.id then
      form_id = form_attr.id
    else
      form_id = ui.create_unique_id()
    end
    local quoted_form_id = encode.json(form_id)
    form_attr.id      = form_id
    local a_attr      = table.new(args.attr)
    a_attr.href       = "#"
    a_attr.onclick    =
      "var f = document.getElementById(" .. quoted_form_id .. "); if (! f.onsubmit || f.onsubmit() != false) { f.submit() }; return false;"
    ui.form{
      external = args.external,
      module   = args.module or request.get_module(),
      action   = args.action,
      id       = args.id,
      params   = args.params,
      routing  = args.routing,
      partial  = args.partial,
      attr     = form_attr,
      content  = function()
        ui.submit{ text = args.text, attr = args.submit_attr }
      end
    }
    ui.script{
      type = "text/javascript",
      script = (
        "document.getElementById(" ..
        quoted_form_id ..
        ").style.display = 'none'; document.write(" ..
        encode.json(
          slot.use_temporary(
            function()
              ui.tag{
                tag     = "a",
                attr    = a_attr,
                content = wrapped_content
              }
            end
          )
        ) ..
        ");"
      )
    }
  else
    -- TODO: support content function
    local a_attr = table.new(args.attr)
    a_attr.href = encode.url{
      external  = args.external,
      static    = args.static,
      module    = args.module or request.get_module(),
      view      = args.view,
      id        = args.id,
      params    = args.params,
      anchor    = args.anchor
    }
    if ui.is_partial_loading_enabled() and args.partial then
      a_attr.onclick = ui._partial_load_js(args.partial)
    end
    return ui.tag{ tag  = "a", attr = a_attr, content = wrapped_content }
  end
end
