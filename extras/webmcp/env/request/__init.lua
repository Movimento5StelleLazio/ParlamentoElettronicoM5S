request._status = nil
request._forward = nil
request._forward_processed = false
request._redirect = nil
request._absolute_baseurl = nil
request._is_404 = false
request._404_route = nil
request._force_absolute_baseurl = false
request._perm_params = {}
request._csrf_secret = nil
request._json_requests_allowed = false

request._params = {}
local depth
if cgi then  -- if-clause to support interactive mode
  if cgi.params._webmcp_404 then
    request.force_absolute_baseurl()
    request._is_404 = true
  end
  for key, value in pairs(cgi.params) do
    if not string.match(key, "^_webmcp_") then
      request._params[key] = value
    end
  end
  local path = cgi.params._webmcp_path
  if path then
    local function parse()
      local module, action, view, suffix, id
      if path == "" then
        request._module = "index"
        request._view   = "index"
        return
      end
      module = string.match(path, "^([^/]+)/$")
      if module then
        request._module = module
        request._view   = "index"
        return
      end
      module, action = string.match(path, "^([^/]+)/([^/.]+)$")
      if module then
        request._module = module
        request._action = action
        return
      end
      module, view, suffix = string.match(path, "^([^/]+)/([^/.]+)%.([^/]+)$")
      if module then
        request._module = module
        request._view   = view
        request._suffix = suffix
        return
      end
      module, view, id, suffix = string.match(path, "^([^/]+)/([^/]+)/([^/.]+)%.([^/]+)$")
      if module then
        request._module = module
        request._view   = view
        request._id     = id
        request._suffix = suffix
        return
      end
      request._is_404 = true
    end
    parse()
    -- allow id to also be set by "_webmcp_id" parameter
    if cgi.params._webmcp_id ~= nil then
      request._id = cgi.params._webmcp_id
    end
    depth = 0
    for match in string.gmatch(path, "/") do
      depth = depth + 1
    end
  else
    request._module = cgi.params._webmcp_module
    request._action = cgi.params._webmcp_action
    request._view   = cgi.params._webmcp_view
    request._suffix = cgi.params._webmcp_suffix
    request._id     = cgi.params._webmcp_id
    depth = tonumber(cgi.params._webmcp_urldepth)
  end
end
if depth and depth > 0 then
  local elements = {}
  for i = 1, depth do
    elements[#elements+1] = "../"
  end
  request._relative_baseurl = table.concat(elements)
else
  request._relative_baseurl = "./"
end

request._app_basepath = assert(
  os.getenv("WEBMCP_APP_BASEPATH"),
  'WEBMCP_APP_BASEPATH is not set.'
)
if not string.find(request._app_basepath, "/$") then
  request._app_basebase = request._app_basepath .. "/"
end
