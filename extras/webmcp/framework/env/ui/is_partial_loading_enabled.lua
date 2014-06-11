--[[--
result =
ui.is_partial_loading_enabled()

This function returns true, if partial loading has been enabled by calling
ui.enable_partial_loading().

--]]--

function ui.is_partial_loading_enabled()
  return ui._partial_loading_enabled
end
