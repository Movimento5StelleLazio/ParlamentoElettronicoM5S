--[[--
url,                         -- normalized URL or nil
auth.openid._normalize_url(
  url                        -- unnormalized URL
)

This function normalizes an URL, and returns nil if the given URL is not a
valid absolute URL. For security reasons only a restricted set of URLs is
valid.

--]]--

function auth.openid._normalize_url(url)
  local url = string.match(url, "^(.-)??$")  -- remove "?" at end
  local proto, host, path = string.match(
    url,
    "([A-Za-z]+)://([0-9A-Za-z.:_-]+)/?([0-9A-Za-z%%/._~-]*)$"
  )
  if not proto then
    return nil
  end
  proto = string.lower(proto)
  host  = string.lower(host)
  local port = string.match(host, ":(.*)")
  if port then
    if string.find(port, "^[0-9]+$") then
      port = tonumber(port)
      host = string.match(host, "^(.-):")
      if port < 1 or port > 65535 then
        return nil
      end
    else
      return nil
    end
  end
  if proto == "http" then
    if port == 80 then port = nil end
  elseif proto == "https" then
    if port == 443 then port = nil end
  else
    return nil
  end
  if
    string.find(host, "^%.") or
    string.find(host, "%.$") or
    string.find(host, "%.%.")
  then
    return nil
  end
  for part in string.gmatch(host, "[^.]+") do
    if not string.find(part, "[A-Za-z]") then
      return nil
    end
  end
  local path_parts = {}
  for part in string.gmatch(path, "[^/]+") do
    if part == "." then
      -- do nothing
    elseif part == ".." then
      path_parts[#path_parts] = nil
    else
      local fail = false
      local part = string.gsub(
        part,
        "%%([0-9A-Fa-f]?[0-9A-Fa-f]?)",
        function (hex)
          if #hex ~= 2 then
            fail = true
            return
          end
          local char = string.char(tonumber("0x" .. hex))
          if string.find(char, "[0-9A-Za-z._~-]") then
            return char
          else
            return "%" .. string.upper(hex)
          end
        end
      )
      if fail then
        return nil
      end
      path_parts[#path_parts+1] = part
    end
  end
  if string.find(path, "/$") then
    path_parts[#path_parts+1] = ""
  end
  path = table.concat(path_parts, "/")
  if port then
    host = host .. ":" .. tostring(port)
  end
  return proto .. "://" .. host .. "/" .. path
end
