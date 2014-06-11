function convert.to_human(value, typ)
  if value == nil then return "" end  -- TODO: is this correct?
  if typ and not atom.has_type(value, typ) then
    error("The value passed to convert.to_human(...) has not the specified type.")
  end
  local type_symbol
  local value_type = type(value)
  if value_type ~= "table" and value_type ~= "userdata" then
    type_symbol = value_type
  else
    type_symbol = convert._type_symbol_mappings[getmetatable(value)]
  end
  if not type_symbol then
    error("Unrecognized type reference occurred in convert.to_human(...).")
  end
  local converter = convert["_from_" .. type_symbol .. "_to_human"]
  if not converter then
    error("Type reference in convert.from_human(...) could be recognized, but the converter function is not existent.")
  end
  return converter(value)
end
