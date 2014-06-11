#!/usr/bin/env lua

local assert         = assert
local collectgarbage = collectgarbage
local error          = error
local getmetatable   = getmetatable
local ipairs         = ipairs
local next           = next
local pairs          = pairs
local print          = print
local rawequal       = rawequal
local rawget         = rawget
local rawlen         = rawlen
local rawset         = rawset
local select         = select
local setmetatable   = setmetatable
local tonumber       = tonumber
local tostring       = tostring
local type           = type

local io     = io
local math   = math
local os     = os
local string = string
local table  = table

local _M = {}
if _ENV then
  _ENV = _M
else
  _G[...] = _M
  setfenv(1, _M)
end

data_sent = false

--[[--
rocketcgi.add_header(
  string_part1,        -- string
  string_part2,        -- optional second part of string to be concatted
  ...
)

Sends a header line to the browser. Multiple arguments are concatted to form a single string.

--]]--
function add_header(...)
  if data_sent then
    error("Can not add header after data has been sent.", 2)
  end
  io.stdout:write(...)
  io.stdout:write("\r\n")
end
--//--

--[[--
rocketcgi.send_data(
  string_part1,       -- string
  string_part2,       -- optional second part of string to be concatted
  ...
)

Sends document data to the browser. Multiple arguments are concatted to form a single string.

--]]--
function send_data(...)
  if not data_sent then
    io.stdout:write("\r\n")
    data_sent = true
  end
  io.stdout:write(...)
end
--//--

--[[--
rocketcgi.set_status(
  status               -- Status code and description, e.g. "404 Not Found"
)

Sends a header line to the browser, indicating a given HTTP status.

--]]--
function set_status(status)
  add_header("Status: ", status)
end
--//--

--[[--
rocketcgi.redirect(
  status             -- Absolute URL to redirect the browser to
)

Redirects the browser to the given absolute URL, using a 303 Redirect.

--]]--
function redirect(location)
  set_status("303 See Other")
  add_header("Location: ", location)
end
--//--

--[[--
rocketcgi.set_content_type(
  content_type               -- MIME content type
)

Sends a header line specifying the content-type to the browser.

--]]--
function set_content_type(content_type)
  add_header("Content-Type: ", content_type)
end
--//--

--[[--
rocketcgi.set_cookie{
  name   = name,       -- name of cookie
  value  = value,      -- value of cookie
  domain = domain,     -- domain where cookie is transmitted
  path   = path,       -- path where cookie is transmitted
  secure = secure      -- boolean, indicating if cookie should only be transmitted over HTTPS
}

Sends a header line setting a cookie. NOTE: Currently only session cookies are supported.

--]]--
function set_cookie(args)
  assert(string.find(args.name, "^[0-9A-Za-z%%._~-]+$"), "Illegal cookie name")
  assert(string.find(args.value, "^[0-9A-Za-z%%._~-]+$"), "Illegal cookie value")
  local parts = {"Set-Cookie: " .. args.name .. "=" .. args.value}
  if args.domain then
    assert(
      string.find(args.path, "^[0-9A-Za-z%%/._~-]+$"),
      "Illegal cookie domain"
    )
    parts[#parts+1] = "domain=" .. args.domain
  end
  if args.path then
    assert(
      string.find(args.path, "^[0-9A-Za-z%%/._~-]+$"),
      "Illegal cookie path"
    )
    parts[#parts+1] = "path=" .. args.path
  end
  if args.secure then
    parts[#parts+1] = "secure"
  end
  add_header(table.concat(parts, "; "))
end
--//--

method = os.getenv("REQUEST_METHOD") or false
query = os.getenv("QUERY_STRING") or false
cookie_data = os.getenv("HTTP_COOKIE") or false
post_data = io.stdin:read("*a") or false
post_contenttype = os.getenv("CONTENT_TYPE") or false
params = {}
get_params = {}
cookies = {}
post_params = {}
post_filenames = {}
post_types = {}

local urldecode
do
  local b0 = string.byte("0")
  local b9 = string.byte("9")
  local bA = string.byte("A")
  local bF = string.byte("F")
  local ba = string.byte("a")
  local bf = string.byte("f")
  function urldecode(str)
    return (
      string.gsub(
        string.gsub(str, "%+", " "),
        "%%([0-9A-Fa-f][0-9A-Fa-f])",
        function(hex)
          local n1, n2 = string.byte(hex, 1, 2)
          if n1 >= b0 and n1 <= b9 then n1 = n1 - b0
          elseif n1 >= bA and n1 <= bF then n1 = n1 - bA + 10
          elseif n1 >= ba and n1 <= bf then n1 = n1 - ba + 10
          else return end
          if n2 >= b0 and n2 <= b9 then n2 = n2 - b0
          elseif n2 >= bA and n2 <= bF then n2 = n2 - bA + 10
          elseif n2 >= ba and n2 <= bf then n2 = n2 - ba + 10
          else return end
          return string.char(n1 * 16 + n2)
        end
      )
    )
  end
end

local function proc_param(tbl, key, value)
  if string.find(key, "%[%]$") then
    if tbl[key] then
      table.insert(tbl[key], value)
    else
      local list = { value }
      params[key] = list
      tbl[key] = list
    end
  else
    params[key] = value
    tbl[key] = value
  end
end

local function read_urlencoded_form(tbl, data)
  for rawkey, rawvalue in string.gmatch(data, "([^=&]*)=([^=&]*)") do
    proc_param(tbl, urldecode(rawkey), urldecode(rawvalue))
  end
end

if query then
  read_urlencoded_form(get_params, query)
end

if cookie_data then
  for rawkey, rawvalue in string.gmatch(cookie_data, "([^=; ]*)=([^=; ]*)") do
    cookies[urldecode(rawkey)] = urldecode(rawvalue)
  end
end

if post_contenttype and (
  post_contenttype == "application/x-www-form-urlencoded" or
  string.match(post_contenttype, "^application/x%-www%-form%-urlencoded[ ;]")
) then
  read_urlencoded_form(post_params, post_data)
elseif post_contenttype then
  local boundary = string.match(
    post_contenttype,
    '^multipart/form%-data[ \t]*;[ \t]*boundary="([^"]+)"'
  ) or string.match(
      post_contenttype,
      '^multipart/form%-data[ \t]*;[ \t]*boundary=([^"; \t]+)'
  )
  if boundary then
    local parts = {}
    do
      local boundary = "\r\n--" .. boundary
      local post_data = "\r\n" .. post_data
      local pos1, pos2 = string.find(post_data, boundary, 1, true)
      while true do
        local ind = string.sub(post_data, pos2 + 1, pos2 + 2)
        if ind == "\r\n" then
          local pos3, pos4 = string.find(post_data, boundary, pos2 + 1, true)
          if pos3 then
            parts[#parts + 1] = string.sub(post_data, pos2 + 3, pos3 - 1)
          else
            error("Illegal POST data.")
          end
          pos1, pos2 = pos3, pos4
        elseif ind == "--" then
          break
        else
          error("Illegal POST data.")
        end
      end
    end
    for i, part in ipairs(parts) do
      local pos = 1
      local name, filename, contenttype
      while true do
        local header
        do
          local oldpos = pos
          pos = string.find(part, "\r\n", oldpos, true)
          if not pos then
            error("Illegal POST data.")
          end
          if pos == oldpos then break end
          header = string.sub(part, oldpos, pos - 1)
          pos = pos + 2
        end
        if string.find(
          string.lower(header),
          "^content%-disposition:[ \t]*form%-data[ \t]*;"
        ) then
          -- TODO: handle all cases correctly
          name = string.match(header, ';[ \t]*name="([^"]*)"') or
            string.match(header, ';[ \t]*name=([^"; \t]+)')
          filename = string.match(header, ';[ \t]*filename="([^"]*)"') or
            string.match(header, ';[ \t]*filename=([^"; \t]+)')
        else
          local dummy, subpos = string.find(
            string.lower(header),
            "^content%-type:[ \t]*"
          )
          if subpos then
            contenttype = string.sub(header, subpos + 1, #header)
          end
        end
      end
      local content = string.sub(part, pos + 2, #part)
      if not name then
        error("Illegal POST data.")
      end
      proc_param(post_params, name, content)
      post_filenames[name] = filename
      post_types[name] = contenttype
    end
  end
end

if post_data and #post_data > 262144 then
  post_data = nil
  collectgarbage("collect")
else
  post_data = nil
end

return _M
