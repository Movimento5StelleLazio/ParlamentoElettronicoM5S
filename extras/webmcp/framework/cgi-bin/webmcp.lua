#!/usr/bin/env lua

_WEBMCP_VERSION = "1.2.5"

-- Lua 5.1 compatibility
if not table.unpack then
  table.unpack = unpack
end
do
  local old_load = load
  function load(ld, ...)
    if type(ld) == "string" then
      local done = false
      local func = function()
        if not done then
          done = true
          return ld
        end
      end
      return old_load(func, ...)
    else
      return old_load(ld, ...)
    end
  end
end

-- include "../lib/" in search path for libraries
if not WEBMCP_PATH then
  WEBMCP_PATH = "../"
end
do
  package.path = WEBMCP_PATH .. 'lib/?.lua;' .. package.path
  -- find out which file name extension shared libraries have
  local slib_exts = {}
  for ext in string.gmatch(package.cpath, "%?%.([A-Za-z0-9_-]+)") do
    slib_exts[ext] = true
  end
  local paths = {}
  for ext in pairs(slib_exts) do
    paths[#paths+1] = WEBMCP_PATH .. "accelerator/?." .. ext
  end
  for ext in pairs(slib_exts) do
    paths[#paths+1] = WEBMCP_PATH .. "lib/?." .. ext
  end
  paths[#paths+1] = package.cpath
  package.cpath = table.concat(paths, ";")
end

-- load os extensions for lua
-- (should happen as soon as possible due to run time measurement)
extos = require 'extos'

-- load nihil library
nihil = require 'nihil'

-- load random generator library
multirand = require 'multirand'

-- load rocketcgi library and map it to cgi, unless interactive
do
  local option = os.getenv("WEBMCP_INTERACTIVE")
  if option and option ~= "" and option ~= "0" then
    cgi = nil
  else
    rocketcgi = require 'rocketcgi'  -- TODO: no "rocketcgi" alias
    cgi = rocketcgi
  end
end

-- load database access library with object relational mapper
mondelefant = require 'mondelefant'
mondelefant.connection_prototype.error_objects = true

-- load type system "atom"
atom = require 'atom'

-- load mondelefant atom connector
require 'mondelefant_atom_connector'

--[[--
cloned_table =  -- newly generated table
table.new(
  table_or_nil  -- keys of a given table will be copied to the new table
)

If a table is given, then a cloned table is returned.
If nil is given, then a new empty table is returned.

--]]--
function table.new(tbl)
  new_tbl = {}
  if tbl then
    for key, value in pairs(tbl) do
      new_tbl[key] = value
    end
  end
  return new_tbl
end
--//--

--[[--
at_exit(
  func  -- function to be called before the process is ending
)

Registers a function to be called before the CGI process is exiting.
--]]--
do
  local exit_handlers = {}
  function at_exit(func)
    table.insert(exit_handlers, func)
  end
  function exit(code)
    for i = #exit_handlers, 1, -1 do
      exit_handlers[i]()
    end
    os.exit(code)
  end
end
--//--

--[[--
app  -- table to store an application state

'app' is a global table for storing any application state data
--]]--
app = {}
--//--

--[[--
config  -- table to store application configuration

'config' is a global table, which can be modified by a config file of an application to modify the behaviour of that application.
--]]--
config = {}
--//--

-- autoloader system for WebMCP environment "../env/",
-- application environment extensions "$WEBMCP_APP_BASE/env/"
-- and models "$WEBMCP_APP_BASE/model/"
do
  local app_base = os.getenv("WEBMCP_APP_BASEPATH")
  if not app_base then
    error(
      "Failed to initialize autoloader " ..
      "due to unset WEBMCP_APP_BASEPATH environment variable."
    )
  end
  local weakkey_mt = { __mode = "k" }
  local autoloader_category = setmetatable({}, weakkey_mt)
  local autoloader_path     = setmetatable({}, weakkey_mt)
  local autoloader_mt       = {}
  local function install_autoloader(self, category, path)
    autoloader_category[self] = category
    autoloader_path[self]     = path
    setmetatable(self, autoloader_mt)
  end
  local function try_exec(filename)
    local file = io.open(filename, "r")
    if file then
      local filedata = file:read("*a")
      io.close(file)
      local func, errmsg = load(filedata, "=" .. filename)
      if func then
        func()
        return true
      else
        error(errmsg, 0)
      end
    else
      return false
    end
  end
  local function compose_path_string(base, path, key)
    return string.gsub(
      base .. table.concat(path, "/") .. "/" .. key, "/+", "/"
    )
  end
  function autoloader_mt.__index(self, key)
    local category, base_path, merge_base_path, file_key
    local merge = false
    if
      string.find(key, "^[a-z_][A-Za-z0-9_]*$") and
      not string.find(key, "^__")
    then
      category        = "env"
      base_path       = WEBMCP_PATH .. "/env/"
      merge           = true
      merge_base_path = app_base .. "/env/"
      file_key        = key
    elseif string.find(key, "^[A-Z][A-Za-z0-9]*$") then
      category        = "model"
      base_path       = app_base .. "/model/"
      local first = true
      file_key = string.gsub(key, "[A-Z]",
        function(c)
          if first then
            first = false
            return string.lower(c)
          else
            return "_" .. string.lower(c)
          end
        end
      )
    else
      return
    end
    local required_category = autoloader_category[self]
    if required_category and required_category ~= category then return end
    local path = autoloader_path[self]
    local path_string = compose_path_string(base_path, path, file_key)
    local merge_path_string
    if merge then
      merge_path_string = compose_path_string(
        merge_base_path, path, file_key
      )
    end
    local function try_dir(dirname)
      local dir = io.open(dirname)
      if dir then
        io.close(dir)
        local obj = {}
        local sub_path = {}
        for i, v in ipairs(path) do sub_path[i] = v end
        table.insert(sub_path, file_key)
        install_autoloader(obj, category, sub_path)
        rawset(self, key, obj)
        try_exec(path_string .. "/__init.lua")
        if merge then try_exec(merge_path_string .. "/__init.lua") end
        return true
      else
        return false
      end
    end
    if merge and try_exec(merge_path_string .. ".lua") then
    elseif merge and try_dir(merge_path_string .. "/") then
    elseif try_exec(path_string .. ".lua") then
    elseif try_dir(path_string .. "/") then
    else end
    return rawget(self, key)
  end
  install_autoloader(_G, nil, {})
  try_exec(WEBMCP_PATH .. "env/__init.lua")
end

-- interactive console mode
if not cgi then
  trace.disable()  -- avoids memory leakage
  local config_name = request.get_config_name()
  if config_name then
    execute.config(config_name)
  end
  return
end

local success, error_info = xpcall(
  function()

    -- execute configuration file
    do
      local config_name = request.get_config_name()
      if config_name then
        execute.config(config_name)
      end
    end

    -- restore slots if coming from http redirect
    if cgi.params.tempstore then
      trace.restore_slots{}
      local blob = tempstore.pop(cgi.params.tempstore)
      if blob then slot.restore_all(blob) end
    end

    local function file_exists(filename)
      local file = io.open(filename, "r")
      if file then
        io.close(file)
        return true
      else
        return false
      end
    end

    if request.is_404() then
      request.set_status("404 Not Found")
      if request.get_404_route() then
        request.forward(request.get_404_route())
      else
        error("No 404 page set.")
      end
    elseif request.get_action() then
      trace.request{
        module = request.get_module(),
        action = request.get_action()
      }
      if
        request.get_404_route() and
        not file_exists(
          encode.action_file_path{
            module = request.get_module(),
            action = request.get_action()
          }
        )
      then
        request.set_status("404 Not Found")
        request.forward(request.get_404_route())
      else
        if cgi.method ~= "POST" then
          request.set_status("405 Method Not Allowed")
          cgi.add_header("Allow: POST")
          error("Tried to invoke an action with a GET request.")
        end
        local action_status = execute.filtered_action{
          module = request.get_module(),
          action = request.get_action(),
        }
        if not request.is_rerouted() then
          local routing_mode, routing_module, routing_view
          routing_mode   = cgi.params["_webmcp_routing." .. action_status .. ".mode"]
          routing_module = cgi.params["_webmcp_routing." .. action_status .. ".module"]
          routing_view   = cgi.params["_webmcp_routing." .. action_status .. ".view"]
          if not (routing_mode or routing_module or routing_view) then
            action_status = "default"
            routing_mode   = cgi.params["_webmcp_routing.default.mode"]
            routing_module = cgi.params["_webmcp_routing.default.module"]
            routing_view   = cgi.params["_webmcp_routing.default.view"]
          end
          assert(routing_module, "Routing information has no module.")
          assert(routing_view,   "Routing information has no view.")
          if routing_mode == "redirect" then
            local routing_params = {}
            for key, value in pairs(cgi.params) do
              local status, stripped_key = string.match(
                key, "^_webmcp_routing%.([^%.]*)%.params%.(.*)$"
              )
              if status == action_status then
                routing_params[stripped_key] = value
              end
            end
            request.redirect{
              module = routing_module,
              view   = routing_view,
              id     = cgi.params["_webmcp_routing." .. action_status .. ".id"],
              params = routing_params
            }
          elseif routing_mode == "forward" then
            request.forward{ module = routing_module, view = routing_view }
          else
            error("Missing or unknown routing mode in request parameters.")
          end
        end
      end
    else
      -- no action
      trace.request{
        module = request.get_module(),
        view   = request.get_view()
      }
      if
        request.get_404_route() and
        not file_exists(
          encode.view_file_path{
            module = request.get_module(),
            view   = request.get_view()
          }
        )
      then
        request.set_status("404 Not Found")
        request.forward(request.get_404_route())
      end
    end

    if not request.get_redirect_data() then
      request.process_forward()
      local view = request.get_view()
      if string.find(view, "^_") then
        error("Tried to call a private view (prefixed with underscore).")
      end
      execute.filtered_view{
        module = request.get_module(),
        view   = view,
      }
    end

    -- force error due to missing absolute base URL until its too late to display error message
    --if request.get_redirect_data() then
    --  request.get_absolute_baseurl()
    --end

  end,

  function(errobj)
    return {
      errobj = errobj,
      stacktrace = string.gsub(
        debug.traceback('', 2),
        "^\r?\n?stack traceback:\r?\n?", ""
      )
    }
  end
)

if not success then trace.error{} end

-- laufzeitermittlung
trace.exectime{ real = extos.monotonic_hires_time(), cpu = os.clock() }

slot.select('trace', trace.render)  -- render trace information

local redirect_data = request.get_redirect_data()

-- log error and switch to error layout, unless success
if not success then
  local errobj     = error_info.errobj
  local stacktrace = error_info.stacktrace
  if not request.get_status() and not request.get_json_request_slots() then
    request.set_status("500 Internal Server Error")
  end
  slot.set_layout('system_error')
  slot.select('system_error', function()
    if getmetatable(errobj) == mondelefant.errorobject_metatable then
      slot.put(
        "<p>Database error of class <b>",
        encode.html(errobj.code),
        "</b> occured:<br/><b>",
        encode.html(errobj.message),
        "</b></p>"
      )
    else
      slot.put("<p><b>", encode.html(tostring(errobj)), "</b></p>")
    end
    slot.put("<p>Stack trace follows:<br/>")
    slot.put(encode.html_newlines(encode.html(stacktrace)))
    slot.put("</p>")
  end)
elseif redirect_data then
  local redirect_params = {}
  for key, value in pairs(redirect_data.params) do
    redirect_params[key] = value
  end
  local slot_dump = slot.dump_all()
  if slot_dump ~= "" then
    redirect_params.tempstore = tempstore.save(slot_dump)
  end
  local json_request_slots = request.get_json_request_slots()
  if json_request_slots then
    redirect_params["_webmcp_json_slots[]"] = json_request_slots  
  end
  cgi.redirect(
    encode.url{
      base   = request.get_absolute_baseurl(),
      module = redirect_data.module,
      view   = redirect_data.view,
      id     = redirect_data.id,
      params = redirect_params
    }
  )
  cgi.send_data()
end

if not success or not redirect_data then

  local http_status = request.get_status()
  if http_status then
    cgi.set_status(http_status)
  end

  local json_request_slots = request.get_json_request_slots()
  if json_request_slots then
    cgi.set_content_type('application/json')
    local data = {}
    for idx, slot_ident in ipairs(json_request_slots) do
      data[slot_ident] = slot.get_content(slot_ident)
    end
    cgi.send_data(encode.json(data))
  else
    cgi.set_content_type(slot.get_content_type())
    cgi.send_data(slot.render_layout())
  end
end

exit()
