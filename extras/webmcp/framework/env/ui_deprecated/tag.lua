function ui_deprecated.tag(name, args)
  
  local html_options = args.html_options or {}
   
  slot.put('<', name, ui_deprecated._stringify_table(html_options), '>')

  if args.label then
    ui_deprecated.label(args.label)
  end

  if type(args.content) == 'function' then
    args.content()
  else
    ui_deprecated.text(args.content)
  end

  slot.put('</', name, '>')


end