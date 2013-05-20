--[[--
locale.set(
  locale_options  -- table with locale categories as keys and their settings as values
)

This function is used to set locale settings. The table given as first and only argument contains locale categories (e.g. "lang" or "time") as keys, and their settings as values. If there is a key 'reset' with a true value, then all non mentioned categories will be reset to nil.

--]]--

function locale.set(locale_options)
  if locale_options.reset then
    locale._current_data = {}
  end
  for key, value in pairs(locale_options) do
    if key ~= "reset" then
      locale._current_data[key] = value
    end
  end
end
