--[[--
discovery_data,                                         -- table containing "claimed_identifier", "op_endpoint" and "op_local_identifier"
errmsg,                                                 -- error message in case of failure
errcode =                                               -- error code in case of failure (TODO: not implemented yet)
auth.openid.discover{
  user_supplied_identifier = user_supplied_identifier,  -- string given by user
  https_as_default         = https_as_default,          -- default to https
  curl_options             = curl_options               -- options passed to "curl" binary, when performing discovery
}

--]]--

-- helper function
local function decode_entities(str)
  local str = str
  str = string.gsub(value, "&lt;", '<')
  str = string.gsub(value, "&gt;", '>')
  str = string.gsub(value, "&quot;", '"')
  str = string.gsub(value, "&amp;", '&amp;')
  return str
end

-- helper function
local function get_tag_value(
  str,          -- HTML document or document snippet
  match_tag,    -- tag name
  match_key,    -- attribute key to match
  match_value,  -- attribute value to match
  result_key    -- attribute key of value to return
)
  -- NOTE: The following parameters are case insensitive
  local match_tag   = string.lower(match_tag)
  local match_key   = string.lower(match_key)
  local match_value = string.lower(match_value)
  local result_key  = string.lower(result_key)
  for tag, attributes in
    string.gmatch(str, "<([0-9A-Za-z_-]+) ([^>]*)>")
  do
    local tag = string.lower(tag)
    if tag == match_tag then
      local matching = false
      for key, value in
        string.gmatch(attributes, '([0-9A-Za-z_-]+)="([^"<>]*)"')
      do
        local key = string.lower(key)
        local value = decode_entities(value)
        if key == match_key then
          -- NOTE: match_key must only match one key of space seperated list
          for value in string.gmatch(value, "[^ ]+") do
            if string.lower(value) == match_value then
              matching = true
              break
            end
          end
        end
        if key == result_key then
          result_value = value
        end
      end
      if matching then
        return result_value
      end
    end
  end
  return nil
end

-- helper function
local function tag_contents(str, match_tag)
  local pos = 0
  local tagpos, closing, tag
  local function next_tag()
    local prefix
    tagpos, prefix, tag, pos = string.match(
      str,
      "()<(/?)([0-9A-Za-z:_-]+)[^>]*>()",
      pos
    )
    closing = (prefix == "/")
  end
  return function()
    repeat
      next_tag()
      if not tagpos then return nil end
      local stripped_tag
      if string.find(tag, ":") then
        stripped_tag = string.match(tag, ":([^:]*)$")
      else
        stripped_tag = tag
      end
    until stripped_tag == match_tag and not closing
    local content_start = pos
    local used_tag = tag
    local counter = 0
    while true do
      repeat
        next_tag()
        if not tagpos then return nil end
      until tag == used_tag
      if closing then
        if counter > 0 then
          counter = counter - 1
        else
          return string.sub(str, content_start, tagpos-1)
        end
      else
        counter = counter + 1
      end
    end
    local content = string.sub(rest, 1, startpos-1)
    str = string.sub(rest, endpos+1)
    return content
  end
end

local function strip(str)
  local str = str
  string.gsub(str, "^[ \t\r\n]+", "")
  string.gsub(str, "[ \t\r\n]+$", "")
  return str
end

function auth.openid.discover(args)
  local url = string.match(args.user_supplied_identifier, "[^#]*")
  -- NOTE: XRIs are not supported
  if
    string.find(url, "^[Xx][Rr][Ii]://") or
    string.find(url, "^[=@+$!(]")
  then
    return nil, "XRI identifiers are not supported."
  end
  -- Prepend http:// or https://, if neccessary:
  if not string.find(url, "://") then
    if args.default_to_https then
      url = "https://" .. url
    else
      url = "http://" .. url
    end
  end
  -- Either an xrds_document or an html_document will be fetched
  local xrds_document, html_document
  -- Repeat max 10 times to avoid endless redirection loops
  local redirects = 0
  while true do
    local status, headers, body = auth.openid._curl(url, args.curl_options)
    if not status then
      return nil, "Error while locating XRDS or HTML file for discovery."
    end
    -- Check, if we are redirected:
    local location = string.match(
      headers,
      "\r?\n[Ll][Oo][Cc][Aa][Tt][Ii][Oo][Nn]:[ \t]*([^\r\n]+)"
    )
    if location then
      -- If we are redirected too often, then return an error.
      if redirects >= 10 then
        return nil, "Too many redirects."
      end
      -- Otherwise follow the redirection by changing the variable "url"
      -- and by incrementing the redirect counter.
      url = location
      redirects = redirects + 1
    else
      -- Check, if there is an X-XRDS-Location header
      -- pointing to an XRDS document:
      local xrds_location = string.match(
        headers,
        "\r?\n[Xx]%-[Xx][Rr][Dd][Ss]%-[Ll][Oo][Cc][Aa][Tt][Ii][Oo][Nn]:[ \t]*([^\r\n]+)"
      )
      -- If there is no X-XRDS-Location header, there might be an
      -- http-equiv meta tag serving the same purpose:
      if not xrds_location and status == 200 then
        xrds_location = get_tag_value(body, "meta", "http-equiv", "X-XRDS-Location", "content")
      end
      if xrds_location then
        -- If we know the XRDS-Location, we can fetch the XRDS document
        -- from that location:
        local status, headers, body = auth.openid._curl(xrds_location, args.curl_options)
        if not status then
          return nil, "XRDS document could not be loaded."
        end
        if status ~= 200 then
          return nil, "XRDS document not found where expected."
        end
        xrds_document = body
        break
      elseif
        -- If the Content-Type header is set accordingly, then we already
        -- should have received an XRDS document:
        string.find(
          headers,
          "\r?\n[Cc][Oo][Nn][Tt][Ee][Nn][Tt]%-[Tt][Yy][Pp][Ee]:[ \t]*application/xrds%+xml\r?\n"
        )
      then
        if status ~= 200 then
          return nil, "XRDS document announced but not found."
        end
        xrds_document = body
        break
      else
        -- Otherwise we should have received an HTML document:
        if status ~= 200 then
          return nil, "No XRDS or HTML document found for discovery."
        end
        html_document = body
        break;
      end
    end
  end
  local claimed_identifier   -- OpenID identifier the user claims to own
  local op_endpoint          -- OpenID provider endpoint URL
  local op_local_identifier  -- optional user identifier, local to the OpenID provider
  if xrds_document then
    -- If we got an XRDS document, we look for a matching <Service> entry:
    for content in tag_contents(xrds_document, "Service") do
      local service_uri, service_localid
      for content in tag_contents(content, "URI") do
        if not string.find(content, "[<>]") then
          service_uri = strip(content)
          break
        end
      end
      for content in tag_contents(content, "LocalID") do
        if not string.find(content, "[<>]") then
          service_localid = strip(content)
          break
        end
      end
      for content in tag_contents(content, "Type") do
        if not string.find(content, "[<>]") then
          local content = strip(content)
          if content == "http://specs.openid.net/auth/2.0/server" then
            -- The user entered a provider identifier, thus claimed_identifier
            -- and op_local_identifier will be set to nil.
            op_endpoint = service_uri
            break
          elseif content == "http://specs.openid.net/auth/2.0/signon" then
            -- The user entered his/her own identifier.
            claimed_identifier  = url
            op_endpoint         = service_uri
            op_local_identifier = service_localid
            break
          end
        end
      end
    end
  elseif html_document then
    -- If we got an HTML document, we look for matching <link .../> tags:
    claimed_identifier = url
    op_endpoint = get_tag_value(
      html_document,
      "link", "rel", "openid2.provider", "href"
    )
    op_local_identifier = get_tag_value(
      html_document,
      "link", "rel", "openid2.local_id", "href"
    )
  else
    error("Assertion failed")  -- should not happen
  end
  if not op_endpoint then
    return nil, "No OpenID endpoint found."
  end
  if claimed_identifier then
    claimed_identifier = auth.openid._normalize_url(claimed_identifier)
    if not claimed_identifier then
      return nil, "Claimed identifier could not be normalized."
    end
  end
  return {
    claimed_identifier  = claimed_identifier,
    op_endpoint         = op_endpoint,
    op_local_identifier = op_local_identifier
  }
end
