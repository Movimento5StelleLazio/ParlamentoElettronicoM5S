#!/usr/bin/env lua

if not pcall(
  function()
    extos = require "extos"
  end
) then
  io.stderr:write('Could not load library "extos".\n')
  io.stderr:write('Hint: Set LUA_CPATH="/path_to_extos_library/?.so;;"\n')
end


local args = {...}

if #args == 0 then
  print()
  print("This program creates translation files by traversing source directories.")
  print()
  print("Two formats are supported: lua files and po files.")
  print("At runtime a lua file is needed.")
  print("For use with po-file editors you may want to create po files first though.")
  print()
  print("Create or update a lua file: langtool.lua dir1/ dir2/ ... <basename>.lua")
  print("Create or update a po file:  langtool.lua dir1/ dir2/ ... <basename>.po")
  print("Convert po file to lua file: langtool.lua <basename>.po <basename>.lua")
  print("Convert lua file to po file: langtool.lua <basename>.lua <basename>.po")
  print()
end

local in_filename, in_filetype, out_filename, out_filetype
local directories = {}

for arg_num, arg in ipairs(args) do
  local function arg_error(msg)
    error("Illegal command line argument #" .. arg_num .. ": " .. msg)
  end
  local po = string.match(arg, "^po:(.*)$") or string.match(arg, "^(.*%.po)$")
  local lua = string.match(arg, "^lua:(.*)$") or string.match(arg, "^(.*%.lua)$")
  local filetype
  if po and not lua then filetype = "po"
    filetype = "po"
  elseif lua and not po then filetype = "lua"
    filetype = "lua"
  else
    filetype = "path"
  end
  if filetype == "path" then
    table.insert(directories, arg)
  elseif filetype == "po" or filetype == "lua" then
    if not out_filename then
      out_filename = arg
      out_filetype = filetype
    elseif not in_filename then
      in_filename = out_filename
      in_filetype = out_filetype
      out_filename = arg
      out_filetype = filetype
    else
      arg_error("Only two language files (one input and one output file) can be specified.")
    end
  else
    -- should not happen, as default type is "path"
    arg_error("Type not recognized")
  end
end

if #directories > 0 and not extos.listdir then
  io.stderr:write('Fatal: Cannot traverse directories without "extos" library -> Abort\n')
  os.exit(1)
end

if out_filename and not in_filename then
  local file = io.open(out_filename, "r")
  if file then
    in_filename = out_filename
    in_filetype = out_filetype
    file:close()
  end
end

local translations = { }

local function traverse(path)
  local filenames = extos.listdir(path)
  if not filenames then return false end
  for num, filename in ipairs(filenames) do
    if not string.find(filename, "^%.") then
      if string.find(filename, "%.lua$") then
        for line in io.lines(path .. "/" .. filename) do
          -- TODO: exact parsing of comments and escape characters
          for key in string.gmatch(line, "_%(?'([^'\]+)'") do
            if
              key ~= "([^" and
              (not string.find(key, "^%s*%.%.[^%.]")) and
              (not string.find(key, "^%s*,[^,]"))
            then
              local key = key:gsub("\\n", "\n")
              translations[key] = false
            end
          end
          for key in string.gmatch(line, '_%(?"([^"\]+)"') do
            if
              key ~= "([^" and
              (not string.find(key, "^%s*%.%.[^%.]")) and
              (not string.find(key, "^%s*,[^,]"))
            then
              local key = key:gsub("\\n", "\n")
              translations[key] = false
            end
          end
        end
      end
      traverse(path .. "/" .. filename)
    end
  end
  return true
end
for num, directory in ipairs(directories) do
  io.stderr:write('Parsing files in directory "', directory, '".\n')
  if not traverse(directory) then
    error('Could not read directory "' .. directory .. '".')
  end
end

local function update_translation(key, value)
  if #directories > 0 then
    if translations[key] ~= nil then translations[key] = value end
  else
    translations[key] = value
  end
end

if in_filetype == "po" then
  io.stderr:write('Reading translations from po file "', in_filename, '".\n')
  local next_line = io.lines(in_filename)
  for line in next_line do
    if not line then break end
    local key = string.match(line, '^msgid%s*"(.*)"%s*$')
    if key then
      local line = next_line()
      local value = string.match(line, '^msgstr%s*"(.*)"%s*$')
      if not value then
        error("Expected msgstr line in po file.")
      end
      if translations[key] then
        error("Duplicate key '" .. key .. "' in po file.")
      end
      if value == "" then value = false end
      update_translation(key, value)
    end
  end
elseif in_filetype == "lua" then
  io.stderr:write('Reading translations from lua file "', in_filename, '".\n')
  local func
  if _ENV then
    func = assert(loadfile(in_filename, "t", {}))
  else
    func = assert(loadfile(in_filename))
    setfenv(func, {})
  end
  local updates = func()
  for key, value in pairs(updates) do
    update_translation(key, value)
  end
end

local translation_keys = {}
for key in pairs(translations) do
  table.insert(translation_keys, key)
end
table.sort(translation_keys)

if out_filetype == "po" then
  io.stderr:write('Writing translations to po file "', out_filename, '".\n')
  local file = assert(io.open(out_filename, "w"))
  for num, key in ipairs(translation_keys) do
    local value = translations[key]
    file:write('msgid "', key, '"\nmsgstr "', value or "", '"\n\n')
  end
  io.close(file)
elseif out_filetype == "lua" then
  io.stderr:write('Writing translations to lua file "', out_filename, '".\n')
  local file = assert(io.open(out_filename, "w"))
  file:write("#!/usr/bin/env lua\n", "return {\n")
  for num, key in ipairs(translation_keys) do
    local value = translations[key]
    if value then
      file:write((string.format("[%q] = %q;\n", key, value):gsub("\\\n", "\\n"))) -- double () important to hide second result of gsub
    else
      file:write((string.format("[%q] = false;\n", key):gsub("\\\n", "\\n"))) -- double () important to hide second result of gsub
    end
  end
  file:write("}\n")
  io.close(file)
end
