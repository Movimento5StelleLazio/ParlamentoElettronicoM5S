--[[--
request.set_cookie{
  name   = name,     -- name of cookie
  value  = value,    -- value of cookie
  domain = domain,   -- optional domain domain where cookie is transmitted
  path   = path,     -- optional path where cookie is transmitted, defaults to application base
  secure = secure    -- optional boolean, indicating if cookie should only be transmitted over HTTPS
}

This function is similar to rocketwiki.set_cookie{...}, except that it automatically sets the path to the application base. It also sets secure=true, if the secure option is unset and the application base URL starts with "https://".

--]]--

function request.set_cookie(args)
  local path = args.path
  if not path then
    path = string.match(
      request.get_absolute_baseurl(),
      "://[^/]*(.*)"
    )
    if path == nil or path == "" then
      path = "/"
    end
  end
  local secure = args.secure
  if secure == nil then
    if string.find(
      string.lower(request.get_absolute_baseurl()),
      "^https://"
    ) then
      secure = true
    else
      secure = false
    end
  end
  cgi.set_cookie{
    name   = args.name,
    value  = args.value,
    domain = args.domain,
    path   = path,
    secure = secure
  }
end
