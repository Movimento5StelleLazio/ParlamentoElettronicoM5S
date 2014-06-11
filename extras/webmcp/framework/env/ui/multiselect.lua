--[[--
ui.multiselect{
  name               = name,                -- HTML name ('html_name' is NOT a valid argument for this function)
  container_attr     = container_attr,      -- extra HTML attributes for the container (div) enclosing field and label
  container2_attr    = container2_attr,     -- extra HTML attributes for the container (div) of the real element (in checkbox case only)
  attr               = attr,                -- extra HTML attributes for the field
  label              = label,               -- text to be used as label for the input field
  label_attr         = label_attr,          -- extra HTML attributes for the label
  readonly           = readonly_flag        -- set to true, to force read-only mode
  foreign_records    = foreign_records,     -- list of records to be chosen from, or function returning such a list
  foreign_id         = foreign_id,          -- name of id field in foreign records
  foreign_name       = foreign_name,        -- name of field to be used as name in foreign records
  selected_ids       = selected_ids,        -- list of ids of currently selected foreign records
  connecting_records = connecting_records,  -- list of connection entries, determining which foreign records are currently selected
  own_id             = own_id,              -- TODO documentation needed
  own_reference      = own_reference,       -- name of foreign key field in connecting records, which references the main record
  foreign_reference  = foreign_reference,   -- name of foreign key field in connecting records, which references foreign records
  format_options     = format_options       -- format options for format.string
}

This function inserts a select field with possibility of multiple selections in the active slot. This function does not reside within ui.field.*, because multiple selections are not stored within a field of a record, but within a different SQL table. Note that 'html_name' is NOT a valid argument to this function. For description of the generic field helper arguments, see help for ui.autofield{...}.

--]]--

function ui.multiselect(args)
  local style = args.style or "checkbox"
  local extra_args = { fetch_record = true }
  if not args.readonly and args.style == "checkbox" then
    extra_args.disable_label_for_id = true
  end
  ui.form_element(args, extra_args, function(args)
    local foreign_records = args.foreign_records
    if type(foreign_records) == "function" then
      foreign_records = foreign_records(args.record)
    end
    local connecting_records = args.connecting_records
    if type(connecting_records) == "function" then
      connecting_records = connecting_records(args.record)
    end
    local select_hash = {}
    if args.selected_ids then
      for idx, selected_id in ipairs(args.selected_ids) do
        select_hash[selected_id] = true
      end
    elseif args.own_reference then
      for idx, connecting_record in ipairs(args.connecting_records) do
        if connecting_record[args.own_reference] == args.record[args.own_id] then
          select_hash[connecting_record[args.foreign_reference]] = true
        end
      end
    else
      for idx, connecting_record in ipairs(args.connecting_records) do
        select_hash[connecting_record[args.foreign_reference]] = true
      end
    end
    local attr = table.new(args.attr)
    if not attr.class then
      attr.class = "ui_multi_selection"
    end
    if args.readonly then
      ui.tag{
        tag     = "ul",
        attr    = attr,
        content = function()
          for idx, record in ipairs(foreign_records) do
            if select_hash[record[args.foreign_id]] then
              ui.tag{
                tag     = "li",
                content = format.string(
                  record[args.foreign_name],
                  args.format_options
                )
              }
            end
          end
        end
      }
    elseif style == "select" then
      attr.name     = args.name
      attr.multiple = "multiple"
      ui.tag{
        tag     = "select",
        attr    = attr,
        content = function()
          if args.nil_as then
            ui.tag{
              tag     = "option",
              attr    = { value = "" },
              content = format.string(
                args.nil_as,
                args.format_options
              )
            }
          end
          for idx, record in ipairs(foreign_records) do
            local key = record[args.foreign_id]
            local selected = select_hash[key]
            ui.tag{
              tag     = "option",
              attr    = {
                value    = key,
                selected = (selected and "selected" or nil)
              },
              content = format.string(
                record[args.foreign_name],
                args.format_options
              )
            }
          end
        end
      }
    elseif style == "checkbox" then
      attr.type = "checkbox"
      attr.name = args.name
      for idx, record in ipairs(foreign_records) do
        local key = record[args.foreign_id]
        local selected = select_hash[key]
        attr.id   = ui.create_unique_id()
        attr.value = key
        attr.checked = selected and "checked" or nil
        ui.container{
          label = format.string(
            record[args.foreign_name],
            args.format_options
          ),
          attr          = args.container2_attr or { class = "ui_checkbox_div" },
          label_for     = attr.id,
          label_attr    = args.label_attr or { class = "ui_checkbox_label" },
          content_first = true,
          content       = function()
            ui.tag{ tag  = "input", attr = attr }
          end
        }
      end
    else
      error("'style' attribute for ui.multiselect{...} must be set to \"select\", \"checkbox\" or nil.")
    end
  end)
end
