--[[--
string =                -- part of string to be used as __format information
encode.format_options(
  params                -- arguments for format function
)

This function is used by encode.format_info(...).

--]]--

function encode.format_options(params)
  local params = params or {}
  local result_parts = {}
  for key, value in pairs(params) do
    if type(key) == "string" then
      if string.find(key, "^[A-Za-z][A-Za-z0-9_]*$") then
        table.insert(result_parts, "-")
        table.insert(result_parts, key)
        table.insert(result_parts, "-")
        local t = type(value)
        if t == "string" then
          value = string.gsub(value, "\\", "\\\\")
          value = string.gsub(value, "'", "\\'")
          table.insert(result_parts, "'")
          table.insert(result_parts, value)
          table.insert(result_parts, "'")
        elseif t == "number" then
          table.insert(result_parts, tostring(value))
        elseif t == "boolean" then
          table.insert(result_parts, value and "true" or "false")
        else
          error("Format parameter table contained value of unsupported type " .. t .. ".")
        end
      else
        error('Format parameter table contained invalid key "' .. key .. '".')
      end
    end
  end
  return table.concat(result_parts)
end
