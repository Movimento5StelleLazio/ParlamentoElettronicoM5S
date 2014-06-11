#!/usr/bin/env lua

local args = {...}

if not args[1] or string.match(args[1], "^%-") then
  print("Usage: autodoc.lua srcdir/ > documentation.html")
  os.exit(1)
end

local entries = {}

for idx, srcdir in ipairs(args) do
  local find_proc = io.popen('find "' .. srcdir .. '" -name \\*.lua', "r")
  for filename in find_proc:lines() do
    local synopsis, comment, source
    local mode
    local function reset()
      synopsis, comment, source = {}, {}, {}
      mode = "idle"
    end
    reset()
    local function strip(tbl)
      while true do
        local line = tbl[#tbl]
        if line and string.find(line, "^%s*$") then
          tbl[#tbl] = nil
        else
          break
        end
      end
      if #tbl > 0 then
        local min_indent = math.huge
        for idx, line in ipairs(tbl) do
          local spaces = string.match(line, "^(%s*)")
          if min_indent > #spaces then
            min_indent = #spaces
          end
        end
        local pattern_parts = { "^" }
        for i = 1, min_indent do
          pattern_parts[#pattern_parts+1] = "%s"
        end
        pattern_parts[#pattern_parts+1] = "(.-)%s*$"
        local pattern = table.concat(pattern_parts)
        for idx, line in ipairs(tbl) do
          tbl[idx] = string.match(line, pattern)
        end
      end
    end
    local function entry_done()
      if #synopsis > 0 then
        strip(synopsis)
        strip(comment)
        strip(source)
        local stripped_synopsis = {}
        for idx, line in ipairs(synopsis) do
          local stripped_line = string.match(line, "^(.-)%-%-") or line
          stripped_line = string.match(stripped_line, "^(.-)%s*$")
          stripped_synopsis[#stripped_synopsis+1] = stripped_line
        end
        local concatted_synopsis = string.gsub(
          table.concat(stripped_synopsis, " "), "[%s]+", " "
        )
        local func_call = string.match(
          concatted_synopsis, "^[A-Za-z0-9_, ]+= ?(.-) ?$"
        )
        if not func_call then
          func_call = string.match(
            concatted_synopsis,
            "^ ?for[A-Za-z0-9_, ]+in (.-) ? do[ %.]+end ?$"
          )
        end
        if not func_call then
          func_call = string.match(concatted_synopsis, "^ ?(.-) ?$")
        end
        func_call = string.gsub(
          func_call,
          "^([^({]*)[({].*[,;].*[,;].*[,;].*[)}]$",
          function(base)
            return base .. "{ ... }"
          end
        )
        if entries[func_call] then
          error("Multiple occurrences of: " .. func_call)
        end
        entries[func_call] = {
          func_call   = func_call,
          synopsis    = synopsis,
          comment     = comment,
          source      = source
        }
      end
      reset()
    end
    for line in io.lines(filename, "r") do
      local function add_to(tbl)
        if #tbl > 0 or not string.match(line, "^%s*$") then
          tbl[#tbl+1] = line
        end
      end
      if mode == "idle" then
        if string.find(line, "^%s*%-%-%[%[%-%-%s*$") then
          mode = "synopsis"
        end
      elseif mode == "synopsis" then
        if string.find(line, "^%s*$") and #synopsis > 0 then
          mode = "comment"
        elseif string.find(line, "^%s*%-%-]]%-%-%s*$") then
          mode = "source"
        else
          add_to(synopsis)
        end
      elseif mode == "comment" then
        if string.find(line, "^%s*%-%-]]%-%-%s*$") then
          mode = "source"
        else
          add_to(comment)
        end
      elseif mode == "source" then
        if string.find(line, "^%s*%-%-//%-%-%s*$") then
          entry_done()
        else
          add_to(source)
        end
      end
    end
    entry_done()
  end
  find_proc:close()
end


function output(...)
  return io.stdout:write(...)
end

function encode(text)
  return (
    string.gsub(
      text, '[<>&"]',
      function(char)
        if char == '<' then
          return "&lt;"
        elseif char == '>' then
          return "&gt;"
        elseif char == '&' then
          return "&amp;"
        elseif char == '"' then
          return "&quot;"
        end
      end
    )
  )
end

function output_lines(tbl)
  for idx, line in ipairs(tbl) do
    if idx == 1 then
      output('<pre>')
    end
    local command, comment = string.match(line, "^(.-)(%-%-.*)$")
    if command then
      output(
        encode(command),
        '<span class="autodoc_comment_tail">', encode(comment), '</span>'
      )
    else
      output(encode(line))
    end
    if idx == #tbl then
      output('</pre>')
    end
    output('\n')
  end
end

keys = {}
for key in pairs(entries) do
  keys[#keys+1] = key
end
table.sort(keys)
for idx, key in ipairs(keys) do
  local entry = entries[key]
  output('<li class="autodoc_entry">\n')
  output(
    '  <div class="short_synopsis"',
    ' onclick="document.getElementById(\'autodoc_details_',
    idx,
    '\').style.display = document.getElementById(\'autodoc_details_',
    idx,
    '\').style.display ? \'\' : \'none\';">\n'
  )
  output('    ', encode(entry.func_call), '\n')
  output('  </div>\n')
  output(
    '  <div id="autodoc_details_',
    idx,
    '" class="autodoc_details" style="display: none;">\n'
  )
  output('    <div class="autodoc_synopsis">\n')
  output_lines(entry.synopsis)
  output('    </div>\n')
  output('    <div class="autodoc_comment">')
  for idx, line in ipairs(entry.comment) do
    output(encode(line))
    if idx < #entry.comment then
      output('<br/>')
    end
  end
  output('    </div>\n')
  output('    <div class="autodoc_source">\n')
  output_lines(entry.source)
  output('    </div>\n')
  output('  </div>\n')
  output('</li>\n')
end
