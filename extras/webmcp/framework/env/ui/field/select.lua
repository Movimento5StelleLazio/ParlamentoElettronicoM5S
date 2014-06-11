--[[--
ui.field.select{
  ...                                  -- generic ui.field.* arguments, as described for ui.autofield{...}
  foreign_records  = foreign_records,  -- list of records to be chosen from, or function returning such a list
  foreign_id       = foreign_id,       -- name of id field in foreign records
  foreign_name     = foreign_name,     -- name of field to be used as name in foreign records
  format_options   = format_options    -- format options for format.string
  selected_record  = selected_record   -- id of (or reference to) record which is selected (optional, overrides "value" argument when not nil)
  disabled_records = disabled_records  -- table with ids of (or references to) records that should be disabled (stored as table keys mapped to true)
}

This function inserts a select field in the active slot. For description of the generic field helper arguments, see help for ui.autofield{...}.

--]]--

function ui.field.select(args)
  ui.form_element(args, {fetch_value = true}, function(args)
    local foreign_records = args.foreign_records
    if type(foreign_records) == "function" then
      foreign_records = foreign_records(args.record)
    end
    if args.readonly then
      local name
      for idx, record in ipairs(foreign_records) do
        if record[args.foreign_id] == args.value then
          name = record[args.foreign_name]
          break
        end
      end
      ui.tag{
        tag     = args.tag,
        attr    = args.attr, 
        content = format.string(name, args.format_options)
      }
    else
      local attr = table.new(args.attr)
      attr.name  = args.html_name
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
          local one_selected = false
          for idx, record in ipairs(foreign_records) do
            local key = record[args.foreign_id]
            local selected = false
            if not one_selected then
              if args.selected_record == nil then
                if args.value == key then
                  selected = true
                end
              else
                if args.selected_record == record or args.selected_record == key then
                  selected = true
                end
              end
              one_selected = selected
            end
            local disabled = false
            if args.disabled_records then
              if args.disabled_records[record] or args.disabled_records[key] then
                disabled = true
              end
            end
            ui.tag{
              tag     = "option",
              attr    = {
                value    = key,
                disabled = disabled and "disabled" or nil,
                selected = selected and "selected" or nil
              },
              content = format.string(
                record[args.foreign_name],
                args.format_options
              )
            }
          end
        end
      }
    end
  end)
end
