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

local math      = math
local string    = string
local table     = table

local mondelefant = require("mondelefant")
local atom        = require("atom")

local _M = {}
if _ENV then
  _ENV = _M
else
  _G[...] = _M
  setfenv(1, _M)
end


input_converters = setmetatable({}, { __mode = "k" })

input_converters["boolean"] = function(conn, value)
  if value then return "TRUE" else return "FALSE" end
end

input_converters["number"] = function(conn, value)
  local str = tostring(value)
  if string.find(str, "^[0-9%.e%-]+$") then
    return str
  else
    return "'NaN'"
  end
end

input_converters[atom.fraction] = function(conn, value)
  if value.invalid then
    return "'NaN'"
  else
    local n, d = tostring(value.numerator), tostring(value.denominator)
    if string.find(n, "^%-?[0-9]+$") and string.find(d, "^%-?[0-9]+$") then
      return "(" .. n .. "::numeric / " .. d .. "::numeric)"
    else
      return "'NaN'"
    end
  end
end

input_converters[atom.date] = function(conn, value)
  return conn:quote_string(tostring(value)) .. "::date"
end

input_converters[atom.timestamp] = function(conn, value)
  return conn:quote_string(tostring(value))  -- don't define type
end

input_converters[atom.time] = function(conn, value)
  return conn:quote_string(tostring(value)) .. "::time"
end


output_converters = setmetatable({}, { __mode = "k" })

output_converters.int8 = function(str) return atom.integer:load(str) end
output_converters.int4 = function(str) return atom.integer:load(str) end
output_converters.int2 = function(str) return atom.integer:load(str) end

output_converters.numeric = function(str) return atom.number:load(str) end
output_converters.float4  = function(str) return atom.number:load(str) end
output_converters.float8  = function(str) return atom.number:load(str) end

output_converters.bool = function(str) return atom.boolean:load(str) end

output_converters.date = function(str) return atom.date:load(str) end

local timestamp_loader_func = function(str)
  local year, month, day, hour, minute, second = string.match(
    str,
    "^([0-9][0-9][0-9][0-9])%-([0-9][0-9])%-([0-9][0-9]) ([0-9]?[0-9]):([0-9][0-9]):([0-9][0-9])"
  )
  if year then
    return atom.timestamp{
      year   = tonumber(year),
      month  = tonumber(month),
      day    = tonumber(day),
      hour   = tonumber(hour),
      minute = tonumber(minute),
      second = tonumber(second)
    }
  else
    return atom.timestamp.invalid
  end
end
output_converters.timestamp = timestamp_loader_func
output_converters.timestamptz = timestamp_loader_func

local time_loader_func = function(str)
  local hour, minute, second = string.match(
    str,
    "^([0-9]?[0-9]):([0-9][0-9]):([0-9][0-9])"
  )
  if hour then
    return atom.time{
      hour   = tonumber(hour),
      minute = tonumber(minute),
      second = tonumber(second)
    }
  else
    return atom.time.invalid
  end
end
output_converters.time = time_loader_func
output_converters.timetz = time_loader_func

mondelefant.postgresql_connection_prototype.type_mappings = {
  int8 = atom.integer,
  int4 = atom.integer,
  int2 = atom.integer,
  bool = atom.boolean,
  date = atom.date,
  timestamp = atom.timestamp,
  time = atom.time,
  text = atom.string,
  varchar = atom.string,
}


function mondelefant.postgresql_connection_prototype.input_converter(conn, value, info)
  if value == nil then
    return "NULL"
  else
    local converter =
      input_converters[getmetatable(value)] or
      input_converters[type(value)]
    if converter then
      return converter(conn, value)
    else
      return conn:quote_string(tostring(value))
    end
  end
end

function mondelefant.postgresql_connection_prototype.output_converter(conn, value, info)
  if value == nil then
    return nil
  else
    local converter = output_converters[info.type]
    if converter then
      return converter(value)
    else
      return value
    end
  end
end

return _M


--[[

db = assert(mondelefant.connect{engine='postgresql', dbname='test'})
result = db:query{'SELECT ? + 1', atom.date{ year=1999, month=12, day=31}}
print(result[1][1].year)

--]]
