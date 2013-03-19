function ui.partial_set_param_names(args)
  if not ui._partial then
    ui._partial = {}
  end
  ui._partial.params = args
end
