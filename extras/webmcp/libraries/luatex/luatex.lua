#!/usr/bin/env lua

local _G             = _G
local _VERSION       = _VERSION
local assert         = assert
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

local io        = io
local math      = math
local os        = os
local string    = string
local table     = table

local multirand = require("multirand")

local _M = {}
if _ENV then
  _ENV = _M
else
  _G[...] = _M
  setfenv(1, _M)
end

-- NOTE:
-- temp_dir MUST NOT contain any charactes interpreted by system shell
-- and has to be set to a private directory (/tmp may be unsafe)
temp_dir = false

function escape(str)
  return (
    string.gsub(
      str,
      "[\001-\031\127\\#$&~_^%%{}]",
      function(char)
        local b = string.byte(char)
        if (b > 1 and b < 31) or b == 127 then
          return " "
        elseif
          char == "#" or char == "$" or char == "&" or char == "_" or
          char == "%" or char == "{" or char == "}"
        then
          return "\\" .. char
        else
          return "\\symbol{" .. b .. "}"
        end
      end
    )
  )
end

document_methods = {}

document_mt = {
  __index = document_methods,
  __call = function(...) return document_methods.write(...) end
}

function new_document()
  return setmetatable({}, document_mt)
end

function document_methods:write(...)
  local i = 1
  while true do
    local v = select(i, ...)
    if v == nil then
      break
    end
    self[#self+1] = v
    i = i + 1
  end
end

function document_methods:get_latex()
  local str = table.concat(self)
  for i in ipairs(self) do
    self[i] = nil
  end
  self[1] = str
  return str
end

function document_methods:get_pdf()
  -- TODO: proper escaping of shell commands
  -- (not a security risk, as args are safe)
  if not temp_dir then
    error("luatex.temp_dir not set")
  end
  local basename = temp_dir .. "/tmp.luatex_" .. multirand.string(16)
  local latex_file = assert(io.open(basename .. ".tex", "w"))
  latex_file:write(self:get_latex())
  latex_file:close()
  local result1, result2, result3 = os.execute(
    'latex -output-format=pdf "-output-directory=' .. temp_dir .. '" ' ..
    basename .. '< /dev/null > /dev/null 2> /dev/null'
  )
  -- NOTE: use result1 and result3 for lua5.1 and lua5.2 compatibility
  if not (result1 == 0 or (result2 == "exit" and result3 == 0)) then
    error('LaTeX failed, see "' .. basename .. '.log" for details.')
  end
  local pdf_file = assert(io.open(basename .. ".pdf", "r"))
  local pdf_data = pdf_file:read("*a")
  pdf_file:close()
  os.execute('rm -f "' .. basename .. '.*"')
  return pdf_data
end

return _M

--[[

luatex = require("luatex")
luatex.temp_dir = "."

local tex = luatex.new_document()

tex "\\documentclass[a4paper,12pt]{article}\n"
tex "\\usepackage{german}\n"
tex "\\usepackage{amsfonts}\n"
tex "\\usepackage{amssymb}\n"
tex "\\usepackage{ulem}\n"
tex "\\pagestyle{headings}\n"
tex "\\begin{document}\n"
tex "\\title{Demo}\n"
tex "\\author{John Doe}\n"
tex "\\date{\\small 25. August 2008}\n"
tex "\\maketitle\n"
tex "\\end{document}\n"

local pdf = tex:get_pdf()

--]]
