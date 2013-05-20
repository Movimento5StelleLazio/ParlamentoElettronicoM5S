--[[--
ui.heading{
  level   = level,   -- level from 1 to 6, defaults to 1
  attr    = attr,    -- extra HTML attributes
  content = content  -- string or function for content
}

This function inserts a heading into the active slot.

--]]--

function ui.heading(args)
  return ui.tag{
    tag     = "h" .. (args.level or 1),
    attr    = args.attr,
    content = args.content
  }
end
