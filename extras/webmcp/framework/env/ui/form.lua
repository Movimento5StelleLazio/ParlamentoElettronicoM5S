--[[--
ui.form{
  record      = record,       -- optional record to be used 
  read_only   = read_only,    -- set to true, if form should be read-only (no submit button)
  file_upload = file_upload,  -- must be set to true, if form contains file upload element
  external    = external,     -- external URL to be used as HTML form action
  module      = module,       -- module name to be used for HTML form action
  view        = view,         -- view name   to be used for HTML form action
  action      = action,       -- action name to be used for HTML form action
  routing = {
    default = {           -- default routing for called action
      mode   = mode,      -- "forward" or "redirect"
      module = module,    -- optional module name, defaults to current module
      view   = view,      -- view name
      id     = id,        -- optional id to be passed to the view
      params = params     -- optional params to be passed to the view
    },
    ok    = { ... },      -- routing when "ok"    is returned by the called action
    error = { ... },      -- routing when "error" is returned by the called action
    ...   = { ... }       -- routing when "..."   is returned by the called action
  },
  partial = {             -- parameters for partial loading, see below
    module = module,
    view   = view,
    id     = id,
    params = params,
    target = target
  },
  content = function()
    ...                   -- code creating the contents of the form
  end
}

This functions creates a web form, which encloses the content created by the given 'content' function. When a 'record' is given, ui.field.* helper functions will be able to automatically determine field values by using the given record. If 'read_only' is set to true, then a call of ui.submit{...} will be ignored, and ui.field.* helper functions will behave differently.

When passing a table as "partial" argument, AND if partial loading has been enabled by calling ui.enable_partial_loading(), then ui._partial_load_js is
used to create an onsubmit event. The "partial" setting table is passed to ui._partial_load_js as first argument. See ui._partial_load_js(...) for
further documentation.

--]]--

local function prepare_routing_params(params, routing, default_module)
  local routing_default_given = false
  if routing then
    for status, settings in pairs(routing) do
      if status == "default" then
        routing_default_given = true
      end
      local module = settings.module or default_module or request.get_module()
      assert(settings.mode, "No mode specified in routing entry.")
      assert(settings.view, "No view specified in routing entry.")
      params["_webmcp_routing." .. status .. ".mode"]   = settings.mode
      params["_webmcp_routing." .. status .. ".module"] = module
      params["_webmcp_routing." .. status .. ".view"]   = settings.view
      params["_webmcp_routing." .. status .. ".id"]     = settings.id
      if settings.params then
        for key, value in pairs(settings.params) do
          params["_webmcp_routing." .. status .. ".params." .. key] = value
        end
      end
    end
  end
  if not routing_default_given then
    params["_webmcp_routing.default.mode"]   = "forward"
    params["_webmcp_routing.default.module"] = request.get_module()
    params["_webmcp_routing.default.view"]   = request.get_view()
  end
  return params
end

function ui.form(args)
  local args = args or {}
  local slot_state = slot.get_state_table()
  local old_record      = slot_state.form_record
  local old_readonly    = slot_state.form_readonly
  local old_file_upload = slot_state.form_file_upload
  slot_state.form_record = args.record
  if args.readonly then
    slot_state.form_readonly = true
    ui.container{ attr = args.attr, content = args.content }
  else
    slot_state.form_readonly = false
    local params = table.new(args.params)
    prepare_routing_params(params, args.routing, args.module)
    params._webmcp_csrf_secret = request.get_csrf_secret()
    local attr = table.new(args.attr)
    if attr.enctype=="multipart/form-data" or args.file_upload then
      slot_state.form_file_upload = true
      if attr.enctype == nil then
        attr.enctype = "multipart/form-data"
      end
    end
    attr.action = encode.url{
      external  = args.external,
      module    = args.module or request.get_module(),
      view      = args.view,
      action    = args.action,
    }
    attr.method = args.method and string.upper(args.method) or "POST"
    if ui.is_partial_loading_enabled() and args.partial then
      attr.onsubmit = slot.use_temporary(function()
        local partial_mode = "form_normal"
        if args.action then
          partial_mode = "form_action"
          slot.put(
            'var element; ',
            'var formElements = []; ',
            'for (var i=0; i<this.elements.length; i++) { ',
              'formElements[formElements.length] = this.elements[i]; ',
            '} ',
            'for (i=0; i<formElements.length; i++) { ',
              'element = formElements[i]; ',
              'if (element.name.search(/^_webmcp_routing\\./) >= 0) { ',
                'element.parentNode.removeChild(element); ',
              '} ',
            '}'
          )
          local routing_params = {}
          prepare_routing_params(
            routing_params,
            args.partial.routing,
            args.partial.module
          )
          for key, value in pairs(routing_params) do
            slot.put(
              ' ',
              'element = document.createElement("input"); ',
              'element.setAttribute("type", "hidden"); ',
              'element.setAttribute("name", ', encode.json(key), '); ',
              'element.setAttribute("value", ', encode.json(value), '); ',
              'this.appendChild(element);'
            )
          end
          slot.put(' ')
        end
        slot.put(ui._partial_load_js(args.partial, partial_mode))
      end)
    end
    if slot_state.form_opened then
      error("Cannot open a non-readonly form inside a non-readonly form.")
    end
    slot_state.form_opened = true
    ui.tag {
      tag     = "form",
      attr    = attr,
      content = function()
        if args.id then
          ui.hidden_field{ name = "_webmcp_id", value = args.id }
        end
        for key, value in pairs(params) do
          ui.hidden_field{ name = key, value = value }
        end
        if args.content then
          args.content()
        end
      end
    }
    slot_state.form_opened = false
  end
  slot_state.form_file_upload = old_file_upload
  slot_state.form_readonly    = old_readonly
  slot_state.form_record      = old_record
end
