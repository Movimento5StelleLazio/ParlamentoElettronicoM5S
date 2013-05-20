--[[--
unique_id =            -- unique string to be used as an id in the DOM tree
ui.create_unique_id()

This function returns a unique string to be used as an id in the DOM tree for elements.

--]]--

function ui.create_unique_id()
  return "unique_" .. multirand.string(32, "bcdfghjklmnpqrstvwxyz")
end
