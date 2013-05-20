--[[--
ui._partial_load_js(
  {
    module = module,
    view   = view,
    id     = id,
    params = params,
    target = target
  },
  mode = mode
}

This function is not supposed to be called directly, but only to be used by
ui.link{...} and ui.form{...}.

It returns a JavaScript which can be used for onclick or onsubmit
attributes in HTML to cause a partial load of contents. Behaviour differs
for the following cases:
a) module, view and target (and optionally id) are given as parameters
b) neither module, view, id, nor target are given as parameters

In case of a) the function will create a JavaScript which requests the
given view (optionally with the given id and params) as JSON data.

In case of b) the function will create a JavaScript requesting the view
specified by the next outer ui.partial{...} call as JSON data. Request
parameters specified by previous calls of add_partial_param_names({...})
are copied from the GET/POST parameters of the current request, while they
can be overwritten using the "params" argument to this function.

If there is no outer ui.partial{...} call in case b), then this function
returns nil.

The called URL contains "_webmcp_json_slots[]" as GET parameters to
indicate that slot contents should be returned as a JSON object, instead of
being inserted to a page layout.

TODO: Currently the slots requested are "default", "trace" and
"system_error". The target for the slot "default" is passed as argument to
this function or to ui.partial{...}. The targets for the slots "trace" and
"system_error" are "trace" and "system_error". This is hardcoded and should
be possible to change in future. The JavaScript will fail, if there are no
HTML elements with id's "trace" and "system_error".

A mode can be passed as second parameter to this function. When this mode
is "nil" or non existent, the function creates JavaScript code to be used
as onclick event for normal (GET) links. When mode is set to "form_normal"
or "form_action", the returned code can be used as onsubmit event of web
forms. "form_normal" is used when the form calls a view, "form_action" is
used when the form calls an action.

--]]--

function ui._partial_load_js(args, mode)
  local args = args or {}
  local module
  local view
  local id
  local params = {}
  local target
  if args.view and args.target then
    module = args.module
    view   = args.view
    id     = args.id
    target = args.target
  elseif not args.view and not args.target then
    if not ui._partial_state then
      return nil
    end
    module = ui._partial_state.module
    view   = ui._partial_state.view
    id     = ui._partial_state.id
    target = ui._partial_state.target
  else
    error("Unexpected arguments passed to ui._partial_load_js{...}")
  end

  if ui._partial_state then
    -- TODO: do this only if args.view and args.target are unset!?
    if ui._partial_state.params then
      for key, value in pairs(ui._partial_state.params) do
        params[key] = value
      end
    end
    for param_name, dummy in pairs(ui._partial_state.param_name_hash) do
      params[param_name] = cgi.params[param_name]
    end
  end
  if args.params then
    for key, value in pairs(args.params) do
      params[key] = value
    end
  end
  local encoded_url = encode.json(
    encode.url{
      module = module,
      view   = view,
      id     = id,
      params = params
    }
  )

  if mode == "form_normal" then
    -- NOTE: action in "action_mode" refers to WebMCP actions, while action
    -- in "this.action" refers to the action attribute of HTML forms
    slot.put('this.action = ', encoded_url, '; ')
  end

  return slot.use_temporary(function()
    slot.put(
      'partialMultiLoad({',
        -- mapping:
        '"trace": "trace", "system_error": "system_error", ',
        encode.json(target), ': "default" }, ',
        -- tempLoadingContents:
        '{}, ',
        -- failureContents:
        '"error", ',
        -- url:
        (mode == "form_normal" or mode == "form_action") and (
          'this'
        ) or (
          encoded_url
        ), ', ',
        -- urlParams:
        '"_webmcp_json_slots[]=default&_webmcp_json_slots[]=trace&_webmcp_json_slots[]=system_error", ',
        -- postParams:
        '{}, ',
        -- successHandler:
        'function() {}, ',
        -- failureHandler:
        'function() {} ',
      '); ',
      'return false;'
    )
  end)
end
