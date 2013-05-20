--[[--
locale_setting =  -- setting for the given localization category (could be of any type, depending on the category)
locale.get(
  category        -- string selecting a localization category, e.g. "lang" or "time", etc...
)

This function is used to read locale settings, which have been set with locale.set(...) or locale.do_with(...).

--]]--

function locale.get(category)
  return locale._current_data[category]
end
