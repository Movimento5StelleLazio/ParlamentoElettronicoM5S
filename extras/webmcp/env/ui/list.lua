--[[--
ui.list{
  label   = list_label,  -- optional label for the whole list
  style   = style,       -- "table", "ulli" or "div"
  prefix  = prefix,      -- prefix for HTML field names
  records = records,     -- array of records to be displayed as rows in the list
  columns = {
    {
      label          = column_label,    -- label for the column
      label_attr     = label_attr,      -- table with HTML attributes for the heading cell or div
      field_attr     = field_attr,      -- table with HTML attributes for the data cell or div
      name           = name,            -- name of the field in each record
      html_name      = html_name,       -- optional html-name for writable fields (defaults to name)
      ui_field_type  = ui_field_type,   -- name of the ui.field.* function to use
      ....,                             -- other options for the given ui.field.* functions
      format         = format,          -- name of the format function to be used (if not using ui_field_type)
      format_options = format_options,  -- options to be passed to the format function
      content        = content          -- function to output field data per record (ignoring name, format, ...)
    },
    { ... },
    ...
  }
}

This function takes an array of records to be displayed in a list. The whole list may have a label. The style's "table" (for <table>), "ulli" (for <ul><li>) and "div" (just using <div> tags) are supported. For each column several options must be specified.

--]]--

-- TODO: documentation of the prefix option
-- TODO: check short descriptions of fields in documentation
-- TODO: field_attr is used for the OUTER html tag's attributes, while attr is used for the INNER html tag's attributes (produced by ui.field.*), is that okay?
-- TODO: use field information of record class, if no columns are given
-- TODO: callback to set row attr's for a specific row

function ui.list(args)
  local args = args or {}
  local label     = args.label
  local list_type = args.style or "table"
  local prefix    = args.prefix
  local records   = assert(args.records, "ui.list{...} needs records.")
  local columns   = assert(args.columns, "ui.list{...} needs column definitions.")
  local outer_attr = table.new(args.attr)
  local header_existent = false
  for idx, column in ipairs(columns) do
    if column.label then
      header_existent = true
      break
    end
  end
  local slot_state = slot.get_state_table()
  local outer_tag, head_tag, head_tag2, label_tag, body_tag, row_tag
  if list_type == "table" then
    outer_tag = "table"
    head_tag  = "thead"
    head_tag2 = "tr"
    label_tag = "th"
    body_tag  = "tbody"
    row_tag   = "tr"
    field_tag = "td"
  elseif list_type == "ulli" then
    outer_tag = "div"
    head_tag  = "div"
    label_tag = "div"
    body_tag  = "ul"
    row_tag   = "li"
    field_tag = "td"
  elseif list_type == "div" then
    outer_tag = "div"
    head_tag  = "div"
    label_tag = "div"
    body_tag  = "div"
    row_tag   = "div"
    field_tag = "div"
  else
    error("Unknown list type specified for ui.list{...}.")
  end
  outer_attr.class = outer_attr.class or "ui_list"
  ui.container{
    auto_args = args,
    content   = function()
      ui.tag{
        tag     = outer_tag,
        attr    = outer_attr,
        content = function()
          if header_existent then
            ui.tag{
              tag     = head_tag,
              attr    = { class = "ui_list_head" },
              content = function()
                local function header_content()
                  for idx, column in ipairs(columns) do
                    if column.ui_field_type ~= "hidden" then
                      local label_attr = table.new(column.label_attr)
                      label_attr.class =
                        label_attr.class or { class = "ui_list_label" }
                      ui.tag{
                        tag     = label_tag,
                        attr    = label_attr,
                        content = column.label or ""
                      }
                    end
                  end
                end
                if head_tag2 then
                  ui.tag{ tag = head_tag2, content = header_content }
                else
                  header_content()
                end
              end
            }
          end
          ui.tag{
            tag     = body_tag,
            attr    = { class = "ui_list_body" },
            content = function()
              for record_idx, record in ipairs(records) do
                local row_class
                if record_idx % 2 == 0 then
                  row_class = "ui_list_row ui_list_even"
                else
                  row_class = "ui_list_row ui_list_odd"
                end
                ui.tag{
                  tag     = row_tag,
                  attr    = { class = row_class },
                  content = function()
                    local old_html_name_prefix, old_form_record
                    if prefix then
                      old_html_name_prefix        = slot_state.html_name_prefix
                      old_form_record             = slot_state.form_record
                      slot_state.html_name_prefix = prefix .. "[" .. record_idx .. "]"
                      slot_state.form_record      = record
                    end
                    local first_column = true
                    for column_idx, column in ipairs(columns) do
                      if column.ui_field_type ~= "hidden" then
                        local field_attr = table.new(column.field_attr)
                        field_attr.class =
                          field_attr.class or { class = "ui_list_field" }
                        local field_content
                        if column.content then
                          field_content = function()
                            return column.content(record)
                          end
                        elseif column.name then
                          if column.ui_field_type then
                            local ui_field_func = ui.field[column.ui_field_type]
                            if not ui_field_func then
                              error('Unknown ui_field_type "' .. column.ui_field_type .. '".')
                            end
                            local ui_field_options = table.new(column)
                            ui_field_options.record = record
                            ui_field_options.label  = nil
                            if not prefix and ui_field_options.readonly == nil then
                              ui_field_options.readonly = true
                            end
                            field_content = function()
                              return ui.field[column.ui_field_type](ui_field_options)
                            end
                          elseif column.format then
                            local formatter = format[column.format]
                            if not formatter then
                              error('Unknown format "' .. column.format .. '".')
                            end
                            field_content = formatter(
                              record[column.name], column.format_options
                            )
                          else
                            field_content = function()
                              return ui.autofield{
                                record    = record,
                                name      = column.name,
                                html_name = column.html_name
                              }
                            end
                          end
                        else
                          error("Each column needs either a 'content' or a 'name'.")
                        end
                        local extended_field_content
                        if first_column then
                          first_column = false
                          extended_field_content = function()
                            for column_idx, column in ipairs(columns) do
                              if column.ui_field_type == "hidden" then
                                local ui_field_options = table.new(column)
                                ui_field_options.record = record
                                ui_field_options.label  = nil
                                if not prefix and ui_field_options.readonly == nil then
                                  ui_field_options.readonly = true
                                end
                                ui.field.hidden(ui_field_options)
                              end
                            end
                            field_content()
                          end
                        else
                          extended_field_content = field_content
                        end
                        ui.tag{
                          tag     = field_tag,
                          attr    = field_attr,
                          content = extended_field_content
                        }
                      end
                    end
                    if prefix then
                      slot_state.html_name_prefix = old_html_name_prefix
                      slot_state.form_record      = old_form_record
                    end
                  end
                }
              end
            end
          }
        end
      }
    end
  }
  if prefix then
    -- ui.field.hidden is used instead of ui.hidden_field to suppress output in case of read-only mode.
    ui.field.hidden{
      html_name = prefix .. "[len]",
      value     = #records
    }
  end
end
