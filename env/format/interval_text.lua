function format.interval_text(value, options)
  
  local options = options or {}
  
  value = value:gsub("%..*", "")
    :gsub("days", "{DAYS}")
    :gsub("day", "{DAY}")
    :gsub("mons", "{MONS}")
    :gsub("mon", "{MON}")
    :gsub("yeas", "{YEARS}")
    :gsub("year", "{YEAR}")

  if (options.mode == "time_left") then
    
    local interval_text = value
      :gsub("{DAYS}", _"days [interval time left]")
      :gsub("{DAY}", _"day [interval time left]")
      :gsub("{MONS}", _"months [interval time left]")
      :gsub("{MON}", _"month [interval time left]")
      :gsub("{YEARS}", _"years [interval time left]")
      :gsub("{YEAR}", _"year [interval time left]")
    return _("#{interval_text} left", { interval_text = interval_text })
    
  elseif (options.mode == "ago") then
    local interval_text = value:gsub("years", _"years [interval ago]")
      :gsub("{DAYS}", _"days [interval ago]")
      :gsub("{DAY}", _"day [interval ago]")
      :gsub("{MONS}", _"months [interval ago]")
      :gsub("{MON}", _"month [interval ago]")
      :gsub("{YEARS}", _"years [interval ago]")
      :gsub("{YEAR}", _"year [interval ago]")
    return _("#{interval_text} ago", { interval_text = interval_text })

  else
    local interval_text = value:gsub("years", _"years [interval]")
      :gsub("{DAYS}", _"days [interval]")
      :gsub("{DAY}", _"day [interval]")
      :gsub("{MONS}", _"months [interval]")
      :gsub("{MON}", _"month [interval]")
      :gsub("{YEARS}", _"years [interval]")
      :gsub("{YEAR}", _"year [interval]")
    return _("#{interval_text} [interval]", { interval_text = interval_text })

  end
end