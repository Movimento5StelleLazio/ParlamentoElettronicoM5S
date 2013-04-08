function util.trim(string)
  if string == nil then
    return string
  end
  return (string:gsub("^%s*", ""):gsub("%s*$", ""):gsub("%s+", " "))
end
