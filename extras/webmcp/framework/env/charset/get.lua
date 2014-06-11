--[[--
current_charset =  -- currently selected character set to be used
charset.get()

Returns the currently selected character set, which is used by the application. Defaults to "UTF-8" unless being changed.

--]]--

function charset.get()
  return charset._current
end
