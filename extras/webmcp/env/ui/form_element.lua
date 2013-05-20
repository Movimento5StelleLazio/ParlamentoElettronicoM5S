--[[--
ui.form_element(
  args,                                                -- external arguments
  {                                                    -- options for this function call
    fetch_value          = fetch_value_flag,           -- true causes automatic determination of args.value, if nil
    fetch_record         = fetch_record_flag,          -- true causes automatic determination of args.record, if nil
    disable_label_for_id = disable_label_for_id_flag,  -- true suppresses automatic setting of args.attr.id for a HTML label_for reference
  },
  function(args)
    ...                                                -- program code
  end
)

This function helps other form helpers by preprocessing arguments passed to the helper, e.g. fetching a value from a record stored in a state-table of the currently active slot.

--]]--

-- TODO: better documentation

function ui.form_element(args, extra_args, func)
  local args = table.new(args)
  if extra_args then
    for key, value in pairs(extra_args) do
      args[key] = value
    end
  end
  local slot_state = slot.get_state_table()
  args.html_name = args.html_name or args.name
  if args.fetch_value then
    if args.value == nil then
      if not args.record and slot_state then
        args.record = slot_state.form_record
      end
      if args.record then
        args.value = args.record[args.name]
      end
    else
      args.value = nihil.lower(args.value)
    end
  elseif args.fetch_record then
    if not args.record and slot_state then
      args.record = slot_state.form_record
    end
  end
  if
    args.html_name and
    not args.readonly and
    slot_state.form_readonly == false
  then
    args.readonly = false
    local prefix
    if args.html_name_prefix == nil then
      prefix = slot_state.html_name_prefix
    else
      prefix = args.html_name_prefix
    end
    if prefix then
      args.html_name = prefix .. args.html_name
    end
  else
    args.readonly = true
  end
  if args.label then
    if not args.disable_label_for_id then
      if not args.attr then
        args.attr = { id = ui.create_unique_id() }
      elseif not args.attr.id then
        args.attr.id = ui.create_unique_id()
      end
    end
    if not args.label_attr then
      args.label_attr = { class = "ui_field_label" }
    elseif not args.label_attr.class then
      args.label_attr.class = "ui_field_label"
    end
  end
  ui.container{
    auto_args = args,
    content = function() return func(args) end
  }
end
