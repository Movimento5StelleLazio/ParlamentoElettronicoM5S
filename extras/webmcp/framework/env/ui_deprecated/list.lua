--
-- Creates a list view of a collection
--
-- Example:
--
--   ui_deprecated.list({ 
--     label = 'Point table',
--     collection = mycollection,
--     type = 'table' -- 'table', 'ulli'
--     cols = {
--       { 
--         label = _'Id',
--         field = 'id',
--         width = 100,
--         link = { module = 'mymodule', view = 'show' },
--              sort = true,
--       },
--       {
--         label = _'Name',
--         field = 'name',
--         width = 200,
--         link = { module = 'mymodule', view = 'show' },
--              sort = true,
--       },
--      {
--        label = _'Points',
--        func = function(record)
--          return record.points_a + record.points_b + record.points_c
--        end,
--        width = 300
--      }
--     }
--   })
--

function ui_deprecated.list(args)
  local args = args
  args.type = args.type or 'table'
  if args.label then
    slot.put('<div class="ui_list_label">' .. encode.html(args.label) .. '</div>\n')
  end
  if not args or not args.collection or not args.cols then
    error('No args for ui_deprecated.list_end')
  end
  if args.type == 'table' then
    slot.put('<table class="ui_list">')
    slot.put('<tr class="ui_list_head">')
  elseif args.type == 'ulli' then
    slot.put('<ul class="ui_list">')
    slot.put('<li class="ui_list_head">')
  end
  if args.type == 'table' then
  elseif args.type == 'ulli' then
  end
  for j, col in ipairs(args.cols) do
    class_string = ''
    if col.align then
      class_string = ' class="' .. col.align .. '"'
    end
    if args.type == 'table' then
      slot.put('<th style="width: ' .. col.width .. ';"' .. class_string ..'>')
      slot.put(ui_deprecated.box({ name = 'ui_list_col_value', content = encode.html(col.label) }) )
      slot.put('</th>')
    elseif args.type == 'ulli' then
      slot.put('<div style="width: ' .. col.width .. ';"' .. class_string ..'>')
      slot.put(ui_deprecated.box({ name = 'ui_list_col_value', content = encode.html(col.label) }) )
      slot.put('</div>')
    end
  end
  if args.type == 'table' then
    slot.put('</tr>')
  elseif args.type == 'ulli' then
    slot.put('<br style="clear: left;" />')
    slot.put('</li>')
  end
  for i, obj in ipairs(args.collection) do
    if args.type == 'table' then
      slot.put('<tr>')
    elseif args.type == 'ulli' then
      slot.put('<li>')
    end
    for j, col in ipairs(args.cols) do
      class_string = ''
      if col.align then
        class_string = ' class="ui_list_col_align_' .. col.align .. '"'
      end
      if args.type == 'table' then
        slot.put('<td' .. class_string ..'>')
      elseif args.type == 'ulli' then
        slot.put('<div style="width: ' .. col.width .. ';"' .. class_string ..'>')
      end
      if col.link then
        local params = {}
        if col.link then
          params = col.link.params or {}
        end
        if col.link_values then
          for key, field in pairs(col.link_values) do
            params[key] = obj[field]
          end
        end
        local id
        if col.link_id_field then
          id = obj[col.link_id_field]
        end
        local value
        if col.value then
          value = col.value
        else
          value = obj[col.field]
        end
        ui_deprecated.link{
          label  = convert.to_human(value),
          module = col.link.module,
          view   = col.link.view,
          id     = id,
          params = params,
        }
      elseif col.link_func then
        local link = col.link_func(obj)
        if link then
	      ui_deprecated.link(link)
	    end
      else
        local text
        if col.func then
          text = col.func(obj)
        elseif col.value then
          text = convert.to_human(value)
        else
          text = convert.to_human(obj[col.field])
        end
        ui_deprecated.box{ name = 'ui_list_col_value', content = text }
      end
      if args.type == 'table' then
        slot.put('</td>')
      elseif args.type == 'ulli' then
        slot.put('</div>')
      end
    end
    if args.type == 'table' then
      slot.put('</tr>')
    elseif args.type == 'ulli' then
      slot.put('<br style="clear: left;" />')
      slot.put('</li>')
    end
  end
  if args.type == 'table' then
    slot.put('</table>')
  elseif args.type == 'ulli' then
    slot.put('</ul><div style="clear: left">&nbsp;</div>')
  end
end