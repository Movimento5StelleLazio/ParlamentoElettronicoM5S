--[[--
ui.anchor{
  name    = name,    -- name of anchor
  attr    = attr,    -- table of HTML attributes
  content = content  -- string to be HTML encoded, or function to be executed
}

This function writes an HTML anchor into the active slot.

--]]--

function ui.anchor(args)
  local attr = table.new(args.attr)
  attr.name = args.name
  return ui.tag{
    tag = "a",
    attr = attr,
    content = args.content
  }
end
