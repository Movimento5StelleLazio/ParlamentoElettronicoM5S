--[[--
charset_data =  -- table containing information about the current charset
charset.get_data()

Returns a table with information about the currently selected charset. See framework/env/charset/data/ for more information.

--]]--

function charset.get_data()
  return charset.data[
    string.gsub(string.lower(charset._current), "%-", "_")
  ]
end
