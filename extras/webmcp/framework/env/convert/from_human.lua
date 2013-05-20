function convert.from_human(str, typ)
  if not typ then
    error("Using convert.from_human(...) to convert a human readable string to an internal data type needs a type to be specified as second parameter.")
  end
  if not str then return nil end  -- TODO: decide, if an error should be raised instead
  local type_symbol = convert._type_symbol_mappings[typ]
  if not type_symbol then
    error("Unrecognized type reference passed to convert.from_human(...).")
  end
  local converter = convert["_from_human_to_" .. type_symbol]
  if not converter then
    error("Type reference passed to convert.from_human(...) was recognized, but the converter function is not existent.")
  end
  return converter(str)
end