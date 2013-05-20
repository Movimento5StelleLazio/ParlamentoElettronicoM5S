--[[doc: ui_deprecated.box

Starts a box

label (string) Label, optional
class (string) Style class, optional
content (function) or (string) The content of the box


Example:

ui_deprecated.box{
  label   = 'My box label',
  class   = 'my_css_class',
  content = function() 
    ui_deprecated.text('My text')
  end
}

--]]

function ui_deprecated.box(args)
  if args.class then
    args.html_options = args.html_options or {}
    args.html_options.class = args.class
  end
  ui_deprecated.tag('div', args)
end

