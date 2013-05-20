function parse._pre_fold(str)
  local str = str
  local special_chars = charset.get_data().special_chars
  local function replace(name, dst)
    local src = special_chars[name]
    if src then
      local pattern = string.gsub(src, "[][()^$%%]", "%%%1")
      str = string.gsub(str, pattern, dst)
    end
  end
  replace("nobreak_space",  " ")
  replace("minus_sign",     "-")
  replace("hyphen_sign",    "-")
  replace("nobreak_hyphen", "-")
  replace("figure_dash",    "-")
  str = string.gsub(str, "\t+", " ")
  str = string.gsub(str, "^ +", "")
  str = string.gsub(str, " +$", "")
  str = string.gsub(str, " +", " ")
  return str
end
