--[[--
ui.tag{
  tag     = tag,     -- HTML tag, e.g. "a" for <a>...</a>
  attr    = attr,    -- table of HTML attributes, e.g. { class = "hide" }
  content = content  -- string to be HTML encoded, or function to be executed
}

This function writes a HTML tag into the active slot.

NOTE: ACCELERATED FUNCTION
Do not change unless also you also update webmcp_accelerator.c

--]]--

function ui.tag(args)
  local tag, attr, content
  tag     = args.tag
  attr    = args.attr or {}
  content = args.content
  if type(attr.class) == "table" then
    attr = table.new(attr)
    attr.class = table.concat(attr.class, " ")
  end
  if not tag and next(attr) then
    tag = "span"
  end
  if tag then
    slot.put('<', tag)
    for key, value in pairs(attr) do
      slot.put(' ', key, '="', encode.html(value), '"')
    end
  end
  if content then
    if tag then
      slot.put('>')
    end
    if type(content) == "function" then
      content()
    else
      slot.put(encode.html(content))
    end
    if tag then
      slot.put('</', tag, '>')
    end
  else
    if tag then
      slot.put(' />')
    end
  end
end
