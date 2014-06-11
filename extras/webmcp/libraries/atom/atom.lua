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
local os        = os
local string    = string
local table     = table

local _M = {}
if _ENV then
  _ENV = _M
else
  _G[...] = _M
  setfenv(1, _M)
end



---------------------------------------
-- general functions and definitions --
---------------------------------------

--[[--
bool =            -- true, if value is an integer within resolution
atom.is_integer(
  value           -- value to be tested
)

This function returns true if the given object is an integer within resolution.

--]]--
function is_integer(i)
  return
    type(i) == "number" and i % 1 == 0 and
    (i + 1) - i == 1 and i - (i - 1) == 1
end
--//--

--[[--
atom.not_a_number

Value representing an invalid numeric result. Used for atom.integer.invalid and atom.number.invalid.

--]]--
not_a_number = 0 / 0
--//--

do

  local shadow = setmetatable({}, { __mode = "k" })

  local type_mt = { __index = {} }

  function type_mt:__call(...)
    return self:new(...)
  end

  function type_mt.__index:_create(data)
    local value = setmetatable({}, self)
    shadow[value] = data
    return value
  end

  local function write_prohibited()
    error("Modification of an atom is prohibited.")
  end

  -- returns a new type as a table, which serves also as metatable
  function create_new_type(name)
    local t = setmetatable(
      { methods = {}, getters = {}, name = name },
      type_mt
    )
    function t.__index(self, key)
      local data = shadow[self]
      local value = data[key]
      if value ~= nil then return value end
      local method = t.methods[key]
      if method then return method end
      local getter = t.getters[key]
      if getter then return getter(self) end
    end
    t.__newindex = write_prohibited
    return t
  end

  --[[--
  bool =          -- true, if 'value' is of type 't'
  atom.has_type(
    value,        -- any value
    t             -- atom time, e.g. atom.date, or lua type, e.g. "string"
  )

  This function checks, if a value is of a given type. The value may be an invalid value though, e.g. atom.date.invalid.

  --]]--
  function has_type(value, t)
    if t == nil then error("No type passed to has_type(...) function.") end
    local lua_type = type(value)
    return
      lua_type == t or
      getmetatable(value) == t or
      (lua_type == "boolean" and t == _M.boolean) or
      (lua_type == "string" and t == _M.string) or (
        lua_type == "number" and
        (t == _M.number or (
          t == _M.integer and (
            not (value <= 0 or value >= 0) or (
              value % 1 == 0 and
              (value + 1) - value == 1 and
              value - (value - 1) == 1
            )
          )
        ))
      )
  end
  --//--

  --[[--
  bool =          -- true, if 'value' is of type 't'
  atom.is_valid(
    value,        -- any value
    t             -- atom time, e.g. atom.date, or lua type, e.g. "string"
  )

  This function checks, if a value is valid. It optionally checks, if the value is of a given type.

  --]]--
  function is_valid(value, t)
    local lua_type = type(value)
    if lua_type == "table" then
      local mt = getmetatable(value)
      if t then
        return t == mt and not value.invalid
      else
        return (getmetatable(mt) == type_mt) and not value.invalid
      end
    elseif lua_type == "boolean" then
      return not t or t == "boolean" or t == _M.boolean
    elseif lua_type == "string" then
      return not t or t == "string" or t == _M.string
    elseif lua_type == "number" then
      if t == _M.integer then
        return
          value % 1 == 0 and
          (value + 1) - value == 1 and
          value - (value - 1) == 1
      else
        return
          (not t or t == "number" or t == _M.number) and
          (value <= 0 or value >= 0)
      end
    else
      return false
    end
  end
  --//--

end

--[[--
string =    -- string representation to be passed to a load function
atom.dump(
  value     -- value to be dumped
)

This function returns a string representation of the given value.

--]]--
function dump(obj)
  if obj == nil then
    return ""
  else
    return tostring(obj)
  end
end
--//--



-------------
-- boolean --
-------------

boolean = { name = "boolean" }

--[[--
bool =              -- true, false, or nil
atom.boolean:load(
  string            -- string to be interpreted as boolean
)

This method returns true or false or nil, depending on the input string.

--]]--
function boolean:load(str)
  if str == nil or str == "" then
    return nil
  elseif type(str) ~= "string" then
    error("String expected")
  elseif string.find(str, "^[TtYy1]") then
    return true
  elseif string.find(str, "^[FfNn0]") then
    return false
  else
    return nil  -- we don't have an undefined bool
  end
end
--//--



------------
-- string --
------------

_M.string = { name = "string" }

--[[--
string =            -- the same string
atom.string:load(
  string            -- a string
)

This method returns the passed string, or throws an error, if the passed argument is not a string.

--]]--
function _M.string:load(str)
  if str == nil then
    return nil
  elseif type(str) ~= "string" then
    error("String expected")
  else
    return str
  end
end
--//--



-------------
-- integer --
-------------

integer = { name = "integer" }

--[[--
int =              -- an integer or atom.integer.invalid (atom.not_a_number)
atom.integer:load(
  string           -- a string representing an integer
)

This method returns an integer represented by the given string. If the string doesn't represent a valid integer, then not-a-number is returned.

--]]--
function integer:load(str)
  if str == nil or str == "" then
    return nil
  elseif type(str) ~= "string" then
    error("String expected")
  else
    local num = tonumber(str)
    if is_integer(num) then return num else return not_a_number end
  end
end
--//--

--[[--
atom.integer.invalid

This represents an invalid integer.

--]]--
integer.invalid = not_a_number
--//



------------
-- number --
------------

number = create_new_type("number")

--[[--
int =              -- a number or atom.number.invalid (atom.not_a_number)
atom.number:load(
  string           -- a string representing a number
)

This method returns a number represented by the given string. If the string doesn't represent a valid number, then not-a-number is returned.

--]]--
function number:load(str)
  if str == nil or str == "" then
    return nil
  elseif type(str) ~= "string" then
    error("String expected")
  else
    return tonumber(str) or not_a_number
  end
end
--//--

--[[--
atom.number.invalid

This represents an invalid number.

--]]--
number.invalid = not_a_number
--//--



--------------
-- fraction --
--------------

fraction = create_new_type("fraction")

--[[--
i =        -- the greatest common divisor (GCD) of all given natural numbers
atom.gcd(
  a,      -- a natural number
  b,      -- another natural number
  ...     -- optionally more natural numbers
)

This function returns the greatest common divisor (GCD) of two or more natural numbers.

--]]--
function gcd(a, b, ...)
  if a % 1 ~= 0 or a <= 0 then return 0 / 0 end
  if b == nil then
    return a
  else
    if b % 1 ~= 0 or b <= 0 then return 0 / 0 end
    if ... == nil then
      local k = 0
      local t
      while a % 2 == 0 and b % 2 == 0 do
        a = a / 2; b = b / 2; k = k + 1
      end
      if a % 2 == 0 then t = a else t = -b end
      while t ~= 0 do
        while t % 2 == 0 do t = t / 2 end
        if t > 0 then a = t else b = -t end
        t = a - b
      end
      return a * 2 ^ k
    else
      return gcd(gcd(a, b), ...)
    end
  end
end
--//--

--[[--
i =        --the least common multiple (LCD) of all given natural numbers
atom.lcm(
  a,       -- a natural number
  b,       -- another natural number
  ...      -- optionally more natural numbers
)

This function returns the least common multiple (LCD) of two or more natural numbers.

--]]--
function lcm(a, b, ...)
  if a % 1 ~= 0 or a <= 0 then return 0 / 0 end
  if b == nil then
    return a
  else
    if b % 1 ~= 0 or b <= 0 then return 0 / 0 end
    if ... == nil then
      return a * b / gcd(a, b)
    else
      return lcm(lcm(a, b), ...)
    end
  end
end
--//--

--[[--
atom.fraction.invalid

Value representing an invalid fraction.

--]]--
fraction.invalid = fraction:_create{
  numerator = not_a_number, denominator = not_a_number, invalid = true
}
--//--

--[[--
frac =              -- fraction
atom.fraction:new(
  numerator,        -- numerator
  denominator       -- denominator
)

This method creates a new fraction.

--]]--
function fraction:new(numerator, denominator)
  if not (
    (numerator == nil   or type(numerator)   == "number") and
    (denominator == nil or type(denominator) == "number")
  ) then
    error("Invalid arguments passed to fraction constructor.")
  elseif
    (not is_integer(numerator)) or
    (denominator and (not is_integer(denominator)))
  then
    return fraction.invalid
  elseif denominator then
    if denominator == 0 then
      return fraction.invalid
    elseif numerator == 0 then
      return fraction:_create{ numerator = 0, denominator = 1, float = 0 }
    else
      local d = gcd(math.abs(numerator), math.abs(denominator))
      if denominator < 0 then d = -d end
      local numerator2, denominator2 = numerator / d, denominator / d
      return fraction:_create{
        numerator   = numerator2,
        denominator = denominator2,
        float       = numerator2 / denominator2
      }
    end
  else
    return fraction:_create{
      numerator = numerator, denominator = 1, float = numerator
    }
  end
end
--//--

--[[--
frac =               -- fraction represented by the given string
atom.fraction:load(
  string             -- string representation of a fraction
)

This method returns a fraction represented by the given string.

--]]--
function fraction:load(str)
  if str == nil or str == "" then
    return nil
  elseif type(str) ~= "string" then
    error("String expected")
  else
    local sign, int = string.match(str, "^(%-?)([0-9]+)$")
    if sign == "" then return fraction:new(tonumber(int))
    elseif sign == "-" then return fraction:new(- tonumber(int))
    end
    local sign, n, d = string.match(str, "^(%-?)([0-9]+)/([0-9]+)$")
    if sign == "" then return fraction:new(tonumber(n), tonumber(d))
    elseif sign == "-" then return fraction:new(- tonumber(n), tonumber(d))
    end
    return fraction.invalid
  end
end
--//--

function fraction:__tostring()
  if self.invalid then
    return "not_a_fraction"
  else
    return self.numerator .. "/" .. self.denominator
  end
end

function fraction.__eq(value1, value2)
  if value1.invalid or value2.invalid then
    return false
  else
    return
      value1.numerator == value2.numerator and
      value1.denominator == value2.denominator
  end
end

function fraction.__lt(value1, value2)
  if value1.invalid or value2.invalid then
    return false
  else
    return value1.float < value2.float
  end
end

function fraction.__le(value1, value2)
  if value1.invalid or value2.invalid then
    return false
  else
    return value1.float <= value2.float
  end
end

function fraction:__unm()
  return fraction(-self.numerator, self.denominator)
end

do

  local function extract(value1, value2)
    local n1, d1, n2, d2
    if getmetatable(value1) == fraction then
      n1 = value1.numerator
      d1 = value1.denominator
    elseif type(value1) == "number" then
      n1 = value1
      d1 = 1
    else
      error("Left operand of operator has wrong type.")
    end
    if getmetatable(value2) == fraction then
      n2 = value2.numerator
      d2 = value2.denominator
    elseif type(value2) == "number" then
      n2 = value2
      d2 = 1
    else
      error("Right operand of operator has wrong type.")
    end
    return n1, d1, n2, d2
  end

  function fraction.__add(value1, value2)
    local n1, d1, n2, d2 = extract(value1, value2)
    return fraction(n1 * d2 + n2 * d1, d1 * d2)
  end

  function fraction.__sub(value1, value2)
    local n1, d1, n2, d2 = extract(value1, value2)
    return fraction(n1 * d2 - n2 * d1, d1 * d2)
  end

  function fraction.__mul(value1, value2)
    local n1, d1, n2, d2 = extract(value1, value2)
    return fraction(n1 * n2, d1 * d2)
  end

  function fraction.__div(value1, value2)
    local n1, d1, n2, d2 = extract(value1, value2)
    return fraction(n1 * d2, d1 * n2)
  end

  function fraction.__pow(value1, value2)
    local n1, d1, n2, d2 = extract(value1, value2)
    local n1_abs = math.abs(n1)
    local d1_abs = math.abs(d1)
    local n2_abs = math.abs(n2)
    local d2_abs = math.abs(d2)
    local numerator, denominator
    if d2_abs == 1 then
      numerator = n1_abs
      denominator = d1_abs
    else
      numerator = 0
      while true do
        local t = numerator ^ d2_abs
        if t == n1_abs then break end
        if not (t < n1_abs) then return value1.float / value2.float end
        numerator = numerator + 1
      end
      denominator = 1
      while true do
        local t = denominator ^ d2_abs
        if t == d1_abs then break end
        if not (t < d1_abs) then return value1.float / value2.float end
        denominator = denominator + 1
      end
    end
    if n1 < 0 then
      if d2_abs % 2 == 1 then
        numerator = -numerator
      else
        return fraction.invalid
      end
    end
    if n2 < 0 then
      numerator, denominator = denominator, numerator
    end
    return fraction(numerator ^ n2_abs, denominator ^ n2_abs)
  end

end



----------
-- date --
----------

date = create_new_type("date")

do
  local c1 = 365             -- days of a non-leap year
  local c4 = 4 * c1 + 1      -- days of a full 4 year cycle
  local c100 = 25 * c4 - 1   -- days of a full 100 year cycle
  local c400 = 4 * c100 + 1  -- days of a full 400 year cycle
  local get_month_offset     -- function returning days elapsed within
                             -- the given year until the given month
                             -- (exclusive the given month)
  do
    local normal_month_offsets = {}
    local normal_month_lengths = {
      31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
    }
    local sum = 0
    for i = 1, 12 do
      normal_month_offsets[i] = sum
      sum = sum + normal_month_lengths[i]
    end
    function get_month_offset(year, month)
      if
        (((year % 4 == 0) and not (year % 100 == 0)) or (year % 400 == 0))
        and month > 2
      then
        return normal_month_offsets[month] + 1
      else
        return normal_month_offsets[month]
      end
    end
  end

  --[[--
  jd =                  -- days from January 1st 1970
  atom.date.ymd_to_jd(
    year,               -- year
    month,              -- month from 1 to 12
    day                 -- day from 1 to 31
  )

  This function calculates the days from January 1st 1970 for a given year, month and day.

  --]]--
  local offset = 0
  function date.ymd_to_jd(year, month, day)
    assert(is_integer(year), "Invalid year specified.")
    assert(is_integer(month), "Invalid month specified.")
    assert(is_integer(day), "Invalid day specified.")
    local calc_year = year - 1
    local n400 = math.floor(calc_year / 400)
    local r400 = calc_year % 400
    local n100 = math.floor(r400 / 100)
    local r100 = r400 % 100
    local n4 = math.floor(r100 / 4)
    local n1 = r100 % 4
    local jd = (
      c400 * n400 + c100 * n100 + c4 * n4 + c1 * n1 +
      get_month_offset(year, month) + (day - 1)
    )
    return jd - offset
  end
  offset = date.ymd_to_jd(1970, 1, 1)
  --//--

  --[[--
  year,                 -- year
  month,                -- month from 1 to 12
  day =                 -- day from 1 to 31
  atom.date.jd_to_ymd(
    jd,                 -- days from January 1st 1970
  )

  Given the days from January 1st 1970 this function returns year, month and day.

  --]]--
  function date.jd_to_ymd(jd)
    assert(is_integer(jd), "Invalid julian date specified.")
    local calc_jd = jd + offset
    assert(is_integer(calc_jd), "Julian date is out of range.")
    local n400 = math.floor(calc_jd / c400)
    local r400 = calc_jd % c400
    local n100 = math.floor(r400 / c100)
    local r100 = r400 % c100
    if n100 == 4 then n100, r100 = 3, c100 end
    local n4 = math.floor(r100 / c4)
    local r4 = r100 % c4
    local n1 = math.floor(r4 / c1)
    local r1 = r4 % c1
    if n1 == 4 then n1, r1 = 3, c1 end
    local year = 1 + 400 * n400 + 100 * n100 + 4 * n4 + n1
    local month = 1 + math.floor(r1 / 31)
    local month_offset = get_month_offset(year, month)
    if month < 12 then
      local next_month_offset = get_month_offset(year, month + 1)
      if r1 >= next_month_offset then
        month = month + 1
        month_offset = next_month_offset
      end
    end
    local day = 1 + r1 - month_offset
    return year, month, day
  end
  --//--
end

--[[--
atom.date.invalid

Value representing an invalid date.

--]]--
date.invalid = date:_create{
  jd = not_a_number,
  year = not_a_number, month = not_a_number, day = not_a_number,
  invalid = true
}
--//--

--[[--
d =                             -- date based on the given data
atom.date:new{
  jd           = jd,            -- days since January 1st 1970
  year         = year,          -- year
  month        = month,         -- month from 1 to 12
  day          = day,           -- day from 1 to 31
  iso_weekyear = iso_weekyear,  -- year according to ISO 8601
  iso_week     = iso_week,      -- week number according to ISO 8601
  iso_weekday  = iso_weekday,   -- day of week from 1 for monday to 7 for sunday
  us_weekyear  = us_weekyear,   -- year
  us_week      = us_week,       -- week number according to US style counting
  us_weekday   = us_weekday     -- day of week from 1 for sunday to 7 for saturday
}

This method returns a new date value, based on given data.

--]]--
function date:new(args)
  local args = args
  if type(args) == "number" then args = { jd = args } end
  if type(args) == "table" then
    local year, month, day = args.year, args.month, args.day
    local jd = args.jd
    local iso_weekyear = args.iso_weekyear
    local iso_week     = args.iso_week
    local iso_weekday  = args.iso_weekday
    local us_week      = args.us_week
    local us_weekday   = args.us_weekday
    if
      type(year)  == "number" and
      type(month) == "number" and
      type(day)   == "number"
    then
      if
        is_integer(year)  and year >= 1  and year <= 9999 and
        is_integer(month) and month >= 1 and month <= 12  and
        is_integer(day)   and day >= 1   and day <= 31
      then
        return date:_create{
          jd = date.ymd_to_jd(year, month, day),
          year = year, month = month, day = day
        }
      else
        return date.invalid
      end
    elseif type(jd) == "number" then
      if is_integer(jd) and jd >= -719162 and jd <= 2932896 then
        local year, month, day = date.jd_to_ymd(jd)
        return date:_create{
          jd = jd, year = year, month = month, day = day
        }
      else
        return date.invalid
      end
    elseif
      type(year)        == "number" and not iso_weekyear and
      type(iso_week)    == "number" and
      type(iso_weekday) == "number"
    then
      if
        is_integer(year) and
        is_integer(iso_week)     and iso_week >= 0 and iso_week <= 53 and
        is_integer(iso_weekday)  and iso_weekday >= 1 and iso_weekday <= 7
      then
        local jan4 = date{ year = year, month = 1, day = 4 }
        local reference = jan4 - jan4.iso_weekday - 7  -- Sun. of week -1
        return date(reference + 7 * iso_week + iso_weekday)
      else
        return date.invalid
      end
    elseif
      type(iso_weekyear) == "number" and not year and
      type(iso_week)     == "number" and
      type(iso_weekday)  == "number"
    then
      if
        is_integer(iso_weekyear) and
        is_integer(iso_week)     and iso_week >= 0 and iso_week <= 53 and
        is_integer(iso_weekday)  and iso_weekday >= 1 and iso_weekday <= 7
      then
        local guessed = date{
          year        = iso_weekyear,
          iso_week    = iso_week,
          iso_weekday = iso_weekday
        }
        if guessed.invalid or guessed.iso_weekyear == iso_weekyear then
          return guessed
        else
          local year
          if iso_week <= 1 then
            year = iso_weekyear - 1
          elseif iso_week >= 52 then
            year = iso_weekyear + 1
          else
            error("Internal error in ISO week computation occured.")
          end
          return date{
            year = year, iso_week = iso_week, iso_weekday = iso_weekday
          }
        end
      else
        return date.invalid
      end
    elseif
      type(year) == "number" and
      type(us_week)     == "number" and
      type(us_weekday)  == "number"
    then
      if
        is_integer(year) and
        is_integer(us_week)     and us_week >= 0    and us_week <= 54   and
        is_integer(us_weekday)  and us_weekday >= 1 and us_weekday <= 7
      then
        local jan1 = date{ year = year, month = 1, day = 1 }
        local reference = jan1 - jan1.us_weekday - 7  -- Sat. of week -1
        return date(reference + 7 * us_week + us_weekday)
      else
        return date.invalid
      end
    end
  end
  error("Illegal arguments passed to date constructor.")
end
--//--

--[[--
atom.date:get_current()

This function returns today's date.

--]]--
function date:get_current()
  local now = os.date("*t")
  return date{
    year = now.year, month = now.month, day = now.day
  }
end
--//--

--[[--
date =           -- date represented by the string
atom.date:load(
  string         -- string representing a date
)

This method returns a date represented by the given string.

--]]--
function date:load(str)
  if str == nil or str == "" then
    return nil
  elseif type(str) ~= "string" then
    error("String expected")
  else
    local year, month, day = string.match(
      str, "^([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])$"
    )
    if year then
      return date{
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day)
      }
    else
      return date.invalid
    end
  end
end
--//--

function date:__tostring()
  if self.invalid then
    return "invalid_date"
  else
    return string.format(
      "%04i-%02i-%02i", self.year, self.month, self.day
    )
  end
end

function date.getters:midnight()
  return timestamp{ year = self.year, month = self.month, day = self.day }
end

function date.getters:midday()
  return timestamp{
    year = self.year, month = self.month, day = self.day,
    hour = 12
  }
end

function date.getters:iso_weekday()  -- 1 = Monday
  return (self.jd + 3) % 7 + 1
end

function date.getters:us_weekday()  -- 1 = Sunday
  return (self.jd + 4) % 7 + 1
end

function date.getters:iso_weekyear()  -- ISO week-numbering year
  local year, month, day = self.year, self.month, self.day
  local iso_weekday      = self.iso_weekday
  if month == 1 then
    if
      (day == 3 and iso_weekday == 7) or
      (day == 2 and iso_weekday >= 6) or
      (day == 1 and iso_weekday >= 5)
    then
      return year - 1
    end
  elseif month == 12 then
    if
      (day == 29 and iso_weekday == 1) or
      (day == 30 and iso_weekday <= 2) or
      (day == 31 and iso_weekday <= 3)
    then
      return year + 1
    end
  end
  return year
end

function date.getters:iso_week()
  local jan4 = date{ year = self.iso_weekyear, month = 1, day = 4 }
  local reference = jan4.jd - jan4.iso_weekday - 6  -- monday of week 0
  return math.floor((self.jd - reference) / 7)
end

function date.getters:us_week()
  local jan1 = date{ year = self.year, month = 1, day = 1 }
  local reference = jan1.jd - jan1.us_weekday - 6  -- sunday of week 0
  return math.floor((self.jd - reference) / 7)
end

function date.__eq(value1, value2)
  if value1.invalid or value2.invalid then
    return false
  else
    return value1.jd == value2.jd
  end
end

function date.__lt(value1, value2)
  if value1.invalid or value2.invalid then
    return false
  else
    return value1.jd < value2.jd
  end
end

function date.__le(value1, value2)
  if value1.invalid or value2.invalid then
    return false
  else
    return value1.jd <= value2.jd
  end
end

function date.__add(value1, value2)
  if getmetatable(value1) == date then
    if getmetatable(value2) == date then
      error("Can not add two dates.")
    elseif type(value2) == "number" then
      return date(value1.jd + value2)
    else
      error("Right operand of '+' operator has wrong type.")
    end
  elseif type(value1) == "number" then
    if getmetatable(value2) == date then
      return date(value1 + value2.jd)
    else
      error("Assertion failed")
    end
  else
    error("Left operand of '+' operator has wrong type.")
  end
end

function date.__sub(value1, value2)
  if not getmetatable(value1) == date then
    error("Left operand of '-' operator has wrong type.")
  end
  if getmetatable(value2) == date then
    return value1.jd - value2.jd  -- TODO: transform to interval
  elseif type(value2) == "number" then
    return date(value1.jd - value2)
  else
    error("Right operand of '-' operator has wrong type.")
  end
end



---------------
-- timestamp --
---------------

timestamp = create_new_type("timestamp")

--[[--
tsec =                          -- seconds since January 1st 1970 00:00
atom.timestamp.ymdhms_to_tsec(
  year,                         -- year
  month,                        -- month from 1 to 12
  day,                          -- day from 1 to 31
  hour,                         -- hour from 0 to 23
  minute,                       -- minute from 0 to 59
  second                        -- second from 0 to 59
)

Given the year, month, day, hour, minute and second, this function returns the number of seconds since January 1st 1970 00:00.

--]]--
function timestamp.ymdhms_to_tsec(year, month, day, hour, minute, second)
  return
    86400 * date.ymd_to_jd(year, month, day) +
    3600 * hour + 60 * minute + second
end
--//--

--[[--
year,                      -- year
month,                     -- month from 1 to 12
day,                       -- day from 1 to 31
hour,                      -- hour from 0 to 23
minute,                    -- minute from 0 to 59
second =                   -- second from 0 to 59
atom.timestamp.tsec_to_ymdhms(
  tsec                     -- seconds since January 1st 1970 00:00
)

Given the seconds since January 1st 1970 00:00, this function returns the year, month, day, hour, minute and second.

--]]--
function timestamp.tsec_to_ymdhms(tsec)
  local jd   = math.floor(tsec / 86400)
  local dsec = tsec % 86400
  local year, month, day = date.jd_to_ymd(jd)
  local hour   = math.floor(dsec / 3600)
  local minute = math.floor((dsec % 3600) / 60)
  local second = dsec % 60
  return year, month, day, hour, minute, second
end
--//--

--[[--
timestamp.invalid

Value representing an invalid timestamp.

--]]--
timestamp.invalid = timestamp:_create{
  tsec = not_a_number,
  year = not_a_number, month = not_a_number, day = not_a_number,
  hour = not_a_number, minute = not_a_number, second = not_a_number,
  invalid = true
}
--//--

--[[--
ts =                 -- timestamp based on given data
atom.timestamp:new{
  tsec   = tsec,     -- seconds since January 1st 1970 00:00
  year   = year,     -- year
  month  = month,    -- month from 1 to 12
  day    = day,      -- day from 1 to 31
  hour   = hour,     -- hour from 0 to 23
  minute = minute,   -- minute from 0 to 59
  second = second    -- second from 0 to 59
}

This method returns a new timestamp value, based on given data.

--]]--
function timestamp:new(args)
  local args = args
  if type(args) == "number" then args = { tsec = args } end
  if type(args) == "table" then
    if not args.second then
      args.second = 0
      if not args.minute then
        args.minute = 0
        if not args.hour then
          args.hour = 0
        end
      end
    end
    if
      type(args.year)   == "number" and
      type(args.month)  == "number" and
      type(args.day)    == "number" and
      type(args.hour)   == "number" and
      type(args.minute) == "number" and
      type(args.second) == "number"
    then
      if
        is_integer(args.year) and
        args.year >= 1 and args.year <= 9999 and
        is_integer(args.month) and
        args.month >= 1 and args.month <= 12 and
        is_integer(args.day) and
        args.day >= 1 and args.day <= 31 and
        is_integer(args.hour) and
        args.hour >= 0 and args.hour <= 23 and
        is_integer(args.minute) and
        args.minute >= 0 and args.minute <= 59 and
        is_integer(args.second) and
        args.second >= 0 and args.second <= 59
      then
        return timestamp:_create{
          tsec = timestamp.ymdhms_to_tsec(
            args.year, args.month, args.day,
            args.hour, args.minute, args.second
          ),
          year   = args.year,
          month  = args.month,
          day    = args.day,
          hour   = args.hour,
          minute = args.minute,
          second = args.second
        }
      else
        return timestamp.invalid
      end
    elseif type(args.tsec) == "number" then
      if
        is_integer(args.tsec) and
        args.tsec >= -62135596800 and args.tsec <= 253402300799
      then
        local year, month, day, hour, minute, second =
          timestamp.tsec_to_ymdhms(args.tsec)
        return timestamp:_create{
          tsec = args.tsec,
          year = year, month = month, day = day,
          hour = hour, minute = minute, second = second
        }
      else
        return timestamp.invalid
      end
    end
  end
  error("Invalid arguments passed to timestamp constructor.")
end
--//--

--[[--
ts =                          -- current date/time as timestamp
atom.timestamp:get_current()

This function returns the current date and time as timestamp.

--]]--
function timestamp:get_current()
  local now = os.date("*t")
  return timestamp{
    year = now.year, month = now.month, day = now.day,
    hour = now.hour, minute = now.min, second = now.sec
  }
end
--//--

--[[--
ts =             -- timestamp represented by the string
atom.timestamp:load(
  string         -- string representing a timestamp
)

This method returns a timestamp represented by the given string.

--]]--
function timestamp:load(str)
  if str == nil or str == "" then
    return nil
  elseif type(str) ~= "string" then
    error("String expected")
  else
    local year, month, day, hour, minute, second = string.match(
      str,
      "^([0-9][0-9][0-9][0-9])%-([0-9][0-9])%-([0-9][0-9]) ([0-9][0-9]):([0-9][0-9]):([0-9][0-9])$"
    )
    if year then
      return timestamp{
        year   = tonumber(year),
        month  = tonumber(month),
        day    = tonumber(day),
        hour   = tonumber(hour),
        minute = tonumber(minute),
        second = tonumber(second)
      }
    else
      return timestamp.invalid
    end
  end
end

function timestamp:__tostring()
  if self.invalid then
    return "invalid_timestamp"
  else
    return string.format(
      "%04i-%02i-%02i %02i:%02i:%02i",
      self.year, self.month, self.day, self.hour, self.minute, self.second
    )
  end
end

function timestamp.getters:date()
  return date{ year = self.year, month = self.month, day = self.day }
end

function timestamp.getters:time()
  return time{
    hour = self.hour,
    minute = self.minute,
    second = self.second
  }
end

function timestamp.__eq(value1, value2)
  if value1.invalid or value2.invalid then
    return false
  else
    return value1.tsec == value2.tsec
  end
end

function timestamp.__lt(value1, value2)
  if value1.invalid or value2.invalid then
    return false
  else
    return value1.tsec < value2.tsec
  end
end

function timestamp.__le(value1, value2)
  if value1.invalid or value2.invalid then
    return false
  else
    return value1.tsec <= value2.tsec
  end
end

function timestamp.__add(value1, value2)
  if getmetatable(value1) == timestamp then
    if getmetatable(value2) == timestamp then
      error("Can not add two timestamps.")
    elseif type(value2) == "number" then
      return timestamp(value1.tsec + value2)
    else
      error("Right operand of '+' operator has wrong type.")
    end
  elseif type(value1) == "number" then
    if getmetatable(value2) == timestamp then
      return timestamp(value1 + value2.tsec)
    else
      error("Assertion failed")
    end
  else
    error("Left operand of '+' operator has wrong type.")
  end
end

function timestamp.__sub(value1, value2)
  if not getmetatable(value1) == timestamp then
    error("Left operand of '-' operator has wrong type.")
  end
  if getmetatable(value2) == timestamp then
    return value1.tsec - value2.tsec  -- TODO: transform to interval
  elseif type(value2) == "number" then
    return timestamp(value1.tsec - value2)
  else
    error("Right operand of '-' operator has wrong type.")
  end
end



----------
-- time --
----------

time = create_new_type("time")

function time.hms_to_dsec(hour, minute, second)
  return 3600 * hour + 60 * minute + second
end

function time.dsec_to_hms(dsec)
  local hour   = math.floor(dsec / 3600)
  local minute = math.floor((dsec % 3600) / 60)
  local second = dsec % 60
  return hour, minute, second
end

--[[--
atom.time.invalid

Value representing an invalid time of day.

--]]--
time.invalid = time:_create{
  dsec = not_a_number,
  hour = not_a_number, minute = not_a_number, second = not_a_number,
  invalid = true
}
--//--

--[[--
t =                 -- time based on given data
atom.time:new{
  dsec = dsec,      -- seconds since 00:00:00
  hour = hour,      -- hour from 0 to 23
  minute = minute,  -- minute from 0 to 59
  second = second   -- second from 0 to 59
}

This method returns a new time value, based on given data.

--]]--
function time:new(args)
  local args = args
  if type(args) == "number" then args = { dsec = args } end
  if type(args) == "table" then
    if not args.second then
      args.second = 0
      if not args.minute then
        args.minute = 0
      end
    end
    if
      type(args.hour)   == "number" and
      type(args.minute) == "number" and
      type(args.second) == "number"
    then
      if
        is_integer(args.hour) and
        args.hour >= 0 and args.hour <= 23 and
        is_integer(args.minute) and
        args.minute >= 0 and args.minute <= 59 and
        is_integer(args.second) and
        args.second >= 0 and args.second <= 59
      then
        return time:_create{
          dsec = time.hms_to_dsec(args.hour, args.minute, args.second),
          hour   = args.hour,
          minute = args.minute,
          second = args.second
        }
      else
        return time.invalid
      end
    elseif type(args.dsec) == "number" then
      if
        is_integer(args.dsec) and
        args.dsec >= 0 and args.dsec <= 86399
      then
        local hour, minute, second =
          time.dsec_to_hms(args.dsec)
        return time:_create{
          dsec = args.dsec,
          hour = hour, minute = minute, second = second
        }
      else
        return time.invalid
      end
    end
  end
  error("Invalid arguments passed to time constructor.")
end
--//--

--[[--
t =                      -- current time of day
atom.time:get_current()

This method returns the current time of the day.

--]]--
function time:get_current()
  local now = os.date("*t")
  return time{ hour = now.hour, minute = now.min, second = now.sec }
end
--//--

--[[--
t =              -- time represented by the string
atom.time:load(
  string         -- string representing a time of day
)

This method returns a time represented by the given string.

--]]--
function time:load(str)
  if str == nil or str == "" then
    return nil
  elseif type(str) ~= "string" then
    error("String expected")
  else
    local hour, minute, second = string.match(
      str,
      "^([0-9][0-9]):([0-9][0-9]):([0-9][0-9])$"
    )
    if hour then
      return time{
        hour   = tonumber(hour),
        minute = tonumber(minute),
        second = tonumber(second)
      }
    else
      return time.invalid
    end
  end
end
--//--

function time:__tostring()
  if self.invalid then
    return "invalid_time"
  else
    return string.format(
      "%02i:%02i:%02i",
      self.hour, self.minute, self.second
    )
  end
end

function time.__eq(value1, value2)
  if value1.invalid or value2.invalid then
    return false
  else
    return value1.dsec == value2.dsec
  end
end

function time.__lt(value1, value2)
  if value1.invalid or value2.invalid then
    return false
  else
    return value1.dsec < value2.dsec
  end
end

function time.__le(value1, value2)
  if value1.invalid or value2.invalid then
    return false
  else
    return value1.dsec <= value2.dsec
  end
end

function time.__add(value1, value2)
  if getmetatable(value1) == time then
    if getmetatable(value2) == time then
      error("Can not add two times.")
    elseif type(value2) == "number" then
      return time((value1.dsec + value2) % 86400)
    else
      error("Right operand of '+' operator has wrong type.")
    end
  elseif type(value1) == "number" then
    if getmetatable(value2) == time then
      return time((value1 + value2.dsec) % 86400)
    else
      error("Assertion failed")
    end
  else
    error("Left operand of '+' operator has wrong type.")
  end
end

function time.__sub(value1, value2)
  if not getmetatable(value1) == time then
    error("Left operand of '-' operator has wrong type.")
  end
  if getmetatable(value2) == time then
    return value1.dsec - value2.dsec  -- TODO: transform to interval
  elseif type(value2) == "number" then
    return time((value1.dsec - value2) % 86400)
  else
    error("Right operand of '-' operator has wrong type.")
  end
end

function time.__concat(value1, value2)
  local mt1, mt2 = getmetatable(value1), getmetatable(value2)
  if mt1 == date and mt2 == time then
    return timestamp{
      year = value1.year, month = value1.month, day = value1.day,
      hour = value2.hour, minute = value2.minute, second = value2.second
    }
  elseif mt1 == time and mt2 == date then
    return timestamp{
      year = value2.year, month = value2.month, day = value2.day,
      hour = value1.hour, minute = value1.minute, second = value1.second
    }
  elseif mt1 == time then
    error("Right operand of '..' operator has wrong type.")
  elseif mt2 == time then
    error("Left operand of '..' operator has wrong type.")
  else
    error("Assertion failed")
  end
end



return _M
