--[[--
locale.do_with(
  locale_options,  -- table with locale information (as if passed to locale.set(...))
  function()
    ...            -- code to be executed with the given locale settings
  end
)

This function executes code with temporarily changed locale settings. See locale.set(...) for correct usage of 'locale_options'.

--]]--

function locale.do_with(locale_options, block)
  local old_data = {}
  for key, value in pairs(locale._current_data) do
    old_data[key] = value
  end
  locale.set(locale_options)
  block()
  old_data.reset = true
  locale.set(old_data)
end
