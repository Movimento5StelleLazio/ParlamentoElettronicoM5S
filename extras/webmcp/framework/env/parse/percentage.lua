function parse.percentage(str, dest_type, options)
  local str = parse._pre_fold(str)
  local dest_type = dest_type or atom.number
  local options = table.new(options)
  options.precision = options.precision or 0
  if options.decimal_shift == true then
    options.decimal_shift = options.precision + 2
  end
  local f = parse.decimal(string.match(str, "^ *([^%%]*) *%%? *$"), dest_type, options)
  if dest_type == atom.number then
    if f then
      return f / 100
    end
  elseif dest_type == atom.integer then
    if f then
      f = f / 100
      if atom.is_integer(f) then
        return f
      else
        return atom.integer.invalid
      end
    end
  elseif dest_type == atom.fraction then
    if f then
      return f / 100
    end
  else
    error("Missing or invalid destination type for parsing.")
  end
end
