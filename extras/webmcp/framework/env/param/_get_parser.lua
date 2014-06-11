function param._get_parser(format_info, param_type)
  if format_info == nil or format_info == "" then
    return function(str)
      return param_type:load(str)
    end
  else
    local format_options = {}
    local format_type, rest = string.match(
      format_info,
      "^([A-Za-z][A-Za-z0-9_]*)(.*)$"
    )
    if format_type then
      rest = string.gsub(rest, "\\\\", "\\e")
      rest = string.gsub(rest, "\\'", "\\q")
      if
        string.find(rest, "\\$") or
        string.find(rest, "\\[^eq]")
      then
        format_type = nil
      else
        while rest ~= "" do
          local key, value, new_rest
          key, value, new_rest = string.match(
            rest,
            "^-([A-Za-z][A-Za-z0-9_]*)-'([^']*)'(.*)$"
          )
          if value then
            value = string.gsub(value, "\\q", "'")
            value = string.gsub(value, "\\e", "\\")
            format_options[key] = value
          else
            key, value, new_rest = string.match(
              rest,
              "^-([A-Za-z][A-Za-z0-9_]*)-([^-]*)(.*)$"
            )
            if value then
              if string.find(value, "^[0-9.Ee+-]+$") then
                local num = tonumber(value)
                if not num then
                  format_type = nil
                  break
                end
                format_options[key] = num
              elseif value == "t" then
                format_options[key] = true
              elseif value == "f" then
                format_options[key] = false
              else
                format_type = nil
                break
              end
            else
              format_type = nil
              break
            end
          end
          rest = new_rest
        end
      end
    end
    if not format_type then
      error("Illegal format string in GET/POST parameters found.")
    end
    local parse_func = parse[format_type]
    if not parse_func then
      error("Unknown format identifier in GET/POST parameters encountered.")
    end
    return function(str)
      return parse_func(str, param_type, format_options)
    end
  end
end
