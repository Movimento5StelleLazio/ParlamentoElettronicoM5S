function parse.boolean(str, dest_type, options)
  if dest_type ~= atom.boolean then
    error("parse.boolean(...) can only return booleans, but a different destination type than atom.boolean was given.")
  end
  local options = options or {}
  local trimmed_str = string.match(str or "", "^%s*(.-)%s*$")
  if options.true_as or options.false_as or options.nil_as then
    if trimmed_str == options.true_as then
      return true
    elseif trimmed_str == options.false_as then
      return false
    elseif trimmed_str == options.nil_as or trimmed_str == "" then
      return nil
    else
      error("Boolean value not recognized.")
    end
  else
    local char = string.upper(string.sub(trimmed_str, 1, 1))
    if char == "1" or char == "T" or char == "Y" then
      return true
    elseif char == "0" or char == "F" or char == "N" then
      return false
    elseif char == "" then
      return nil
    else
      error("Boolean value not recognized.")
    end
  end
end
