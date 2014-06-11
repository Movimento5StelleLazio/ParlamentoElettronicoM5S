function ui.image(args)
  local args = args or {}
  local attr = table.new(args.attr)
  attr.src = encode.url{
    external  = args.external,
    static    = args.static,
    module    = args.module or request.get_module(),
    view      = args.view,
    id        = args.id,
    params    = args.params,
  }
  return ui.tag{ tag = "img", attr = attr }
end
