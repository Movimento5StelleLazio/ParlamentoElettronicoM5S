#!/usr/bin/env lua

local error          = error
local getmetatable   = getmetatable
local rawset         = rawset
local setmetatable   = setmetatable

local _M = {}
if _ENV then
  _ENV = _M
else
  _G[...] = _M
  setfenv(1, _M)
end

metatable = {
  __tostring = function(self)
    return "nil" .. self[1]
  end,
  __newindex = function()
    error("Objects representing nil are immutable.")
  end
}

nils = setmetatable({}, {
  __mode = "v",
  __index = function(self, level)
    if level > 0 then
      local result = setmetatable({ level }, metatable)
      rawset(self, level, result)
      return result
    end
  end,
  __newindex = function()
    error("Table is immutable.")
  end
})

function lift(value)
  if value == nil then
    return nils[1]
  elseif getmetatable(value) == metatable then
    return nils[value[1]+1]
  else
    return value
  end
end

function lower(value)
  if value == nil then
    error("Cannot lower nil.")
  elseif getmetatable(value) == metatable then
    return nils[value[1]-1]
  else
    return value
  end
end

return _M
