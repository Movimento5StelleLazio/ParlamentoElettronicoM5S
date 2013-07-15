function ui_deprecated.link(args)
  if args.action then
    local params = {}
    if args.params then
      for key, value in pairs(args.params) do
        params[key] = value
      end
    end
    ui_deprecated._prepare_redirect_params(params, args.redirect_to)

    local attr_action = args.url or encode.url{
      module = args.module or request.get_module(),
      action = args.action,
      id     = args.id,
      params = params
    }
    local attr_class = table.concat({ 'ui_link', args.class }, ' ')
    local attr_target = args.target or ''
    local redirect_to = args.redirect_to
    local unique_id = "unique_" .. multirand.string(32, "abcdefghijklmnopqrstuvwxyz0123456789")
    slot.put(
      '<form',
      ' id="', unique_id , '"',
      ' action="', attr_action,  '"',
      ' class="', attr_class, '"',
      ' target="', attr_target, '"',
      ' method="post"',
      '>\n',
      '<input type="submit" value="', args.label or '', '" />',
      '</form>',
      '<script>document.getElementById(\'', unique_id, '\').style.display=\'none\';document.write(\'<a href="#" class="', attr_class , '" onclick="document.getElementById(\\\'', unique_id, '\\\').submit();">'
    )
    if args.icon then
      ui_deprecated.image{ image = 'ui/icon/' .. args.icon }
    end
    if args.image then
      ui_deprecated.image{ image = args.image }
    end
    if args.label then
      slot.put(args.label)
    end
    slot.put("</a>');</script>")
  else
    local attr_class = table.concat({ 'ui_link', args.class }, ' ')
    slot.put(
      '<a href="',
      args.url or encode.url{
        module    = args.module or request.get_module(),
        view      = args.view,
        id        = args.id,
        params    = args.params,
      },
      '" ',
      ui_deprecated._stringify_table({ class = attr_class }),
      ui_deprecated._stringify_table( args.html_options or {} ),
      '>'
    )
    if args.icon then
      ui_deprecated.image{ image = 'ui/icon/' .. args.icon }
    end
    if args.image then
      ui_deprecated.image{ image = args.image }
    end
    if args.label then
      slot.put(args.label)
    end
    slot.put('</a>')
  end
end
