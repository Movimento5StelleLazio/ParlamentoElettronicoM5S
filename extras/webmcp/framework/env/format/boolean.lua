--[[--
text =                      -- human text representation of the boolean
format.boolean(
  value,                    -- true, false or nil
  {
    true_as  = true_text,   -- text representing true
    false_as = false_text,  -- text representing false
    nil_as   = nil_text     -- text representing nil
  }
)

Returns a human readable text representation of a boolean value. Additional parameters should be given, unless you like the defaults for false and true, which are "0" and "1".

--]]--

function format.boolean(value, options)
  local options = options or {}
  local true_text  = options.true_as or "Yes"  -- TODO: localization?
  local false_text = options.false_as or "No"  -- TODO: localization?
  local nil_text   = options.nil_as or ""
  if value == nil then
    return nil_text
  elseif value == false then
    return false_text
  elseif value == true then
    return true_text
  else
    error("Value passed to format.boolean(...) is neither a boolean nor nil.")
  end
end
