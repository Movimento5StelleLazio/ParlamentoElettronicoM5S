--[[--
url_string =              -- a string containing an URL
encode.url{
  external  = external,   -- external URL (instead of specifying base, module, etc. below)
  base      = base,       -- optional string containing a base URL of a WebMCP application
  static    = static,     -- an URL relative to the static file directory
  module    = module,     -- a module name of the WebMCP application
  view      = view,       -- a view name of the WebMCP application
  action    = action,     -- an action name of the WebMCP application
  id        = id,         -- optional id to be passed to the view or action to select a particular data record
  params    = params,     -- optional parameters to be passed to the view or action
  anchor    = anchor      -- anchor in URL
}

This function creates URLs to external locations, to static files within the WebMCP application or to a certain view or action inside a module.

--]]--

function encode.url(args)
  local external  = args.external
  local base      = args.base or request.get_relative_baseurl()
  local static    = args.static
  local module    = args.module
  local view      = args.view
  local action    = args.action
  local id        = args.id
  local params    = args.params or {}
  local anchor    = args.anchor
  local result    = {}
  local id_as_param = false
  local function add(...)
    for i = 1, math.huge do
      local v = select(i, ...)
      if v == nil then break end
      result[#result+1] = v
    end
  end
  if external then
    add(external)
  else
    add(base)
    if not string.find(base, "/$") then
      add("/")
    end
    if static then
      add("static/")
      add(static)
    elseif module or view or action or id then
      assert(module, "Module not specified.")
      add(encode.url_part(module), "/")
      if view and not action then
        local view_base, view_suffix = string.match(
          view,
          "^([^.]*)(.*)$"
        )
        add(encode.url_part(view_base))
        if args.id then
          add("/", encode.url_part(id))
        end
        if view_suffix == "" then
          add(".html")
        else
          add(view_suffix)  -- view_suffix includes dot as first character
        end
      elseif action and not view then
        add(encode.url_part(action))
        id_as_param = true
      elseif view and action then
        error("Both a view and an action was specified.")
      end
    end
    do
      local new_params = request.get_perm_params()
      for key, value in pairs(params) do
        new_params[key] = value
      end
      params = new_params
    end
  end
  if next(params) ~= nil or (id and id_as_param) then
    add("?")
    if id and id_as_param then
      add("_webmcp_id=", encode.url_part(id), "&")
    end
    for key, value in pairs(params) do
      -- TODO: better way to detect arrays?
      if string.match(key, "%[%]$") then
        for idx, entry in ipairs(value) do
          add(encode.url_part(key), "=", encode.url_part(entry), "&")
        end
      else
        add(encode.url_part(key), "=", encode.url_part(value), "&")
      end
    end
    result[#result] = nil  -- remove last '&' or '?'
  end
  local string_result = table.concat(result)
  if anchor ~= nil then
    string_result = string.match(string_result, "^[^#]*")
    if anchor then
      string_result = string_result .. "#" .. encode.url_part(anchor)
    end
  end
  return string_result
end
