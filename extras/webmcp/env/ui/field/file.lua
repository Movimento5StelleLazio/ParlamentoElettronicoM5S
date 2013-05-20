--[[--
ui.field.file{
  ...                        -- generic ui.field.* arguments, as described for ui.autofield{...}
}

This function inserts a field for uploading a file in the active slot. For read-only forms this function does nothing. For description of the generic field helper arguments, see help for ui.autofield{...}.

--]]--

function ui.field.file(args)
  ui.form_element(args, nil, function(args)
    if args.readonly then
      -- nothing
    else
      if not slot.get_state_table().form_file_upload then
        error('Parameter "file_upload" of ui.form{...} must be set to true to allow file uploads.')
      end
      local attr = table.new(args.attr)
      attr.type  = "file"
      attr.name  = args.html_name
      ui.tag{ tag  = "input", attr = attr }
    end
  end)
end
