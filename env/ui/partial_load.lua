function ui.partial_load(args)
  local hourglass_target = ui._partial.hourglass_target
  local target           = ui._partial.target
  local id               = param.get_id_cgi()
  local module           = ui._partial.module
  local view             = ui._partial.view
  local cgi_params       = cgi.params

  local params = {
  }

  if ui._partial and ui._partial.static_params then
    for key, value in pairs(ui._partial.static_params) do
      params[key] = value
    end
  end
  if ui._partial and ui._partial.params then
    for i, param_name in ipairs(ui._partial.params) do
      params[param_name] = cgi_params[param_name]
    end
  end
  if args.params then
    for key, value in pairs(args.params) do
      params[key] = value
    end
  end

  request.force_absolute_baseurl()

  return
    'var hourglass_el = document.getElementById("' .. hourglass_target .. '");' ..
    'var hourglass_src = hourglass_el.src;' ..
    'hourglass_el.src = "' .. encode.url{ static = "icons/16/connect.png" } .. '";' ..
    'partialMultiLoad(' ..
      '{ trace: "trace", system_error: "system_error", ' .. target .. ': "default" },' ..
    '{},' ..
    '"error",' ..
    '"' .. encode.url{
      module = module,
      view = view,
      id = id,
      params = params
      } .. '&_webmcp_json_slots[]=default&_webmcp_json_slots[]=trace&_webmcp_json_slots[]=system_error",' ..
    '{},' ..
    '{},' ..
    'function() {' ..
      'hourglass_el.src = hourglass_src;' ..
    '},' ..
    'function() {' ..
      'hourglass_el.src = hourglass_src;' ..
    '}' ..
  '); ' ..
  'return(false);'
end

