function ui_deprecated.calendar(args)
  local record = assert(slot.get_state_table(), "ui_deprecated.calender was not called within a form.").form_record
  local value = param.get(args.field, atom.date) or record[args.field]
  local year = param.get('_ui_calendar_year', atom.integer) or args.year or 2008
  local month = param.get('_ui_calendar_month', atom.integer) or args.month or 10
  local empty_days = atom.date{ year = year, month = month, day = 1 }.iso_weekday -1
  local enabled = not args.disabled
  
  local prev_year = year
  local prev_month = month - 1
  if prev_month == 0 then
    prev_month = 12
    prev_year = prev_year - 1
  end

  local next_year = year
  local next_month = month + 1
  if next_month == 13 then
    next_month = 1
    next_year = next_year + 1
  end
  
  ui_deprecated.tag('div', {
    html_options = {
      class="ui_field ui_calendar"
    },
    content = function()
      ui_deprecated.tag('input', {
        html_options = {
          type = 'hidden',
          value = year,
          name = '_ui_calendar_year',
          id = '_ui_calendar_year',
          onchange = 'this.form.submit();'
        }
      })
      ui_deprecated.tag('input', {
        html_options = {
          type = 'hidden',
          value = month,
          name = '_ui_calendar_month',
          id = '_ui_calendar_month',
          onchange = 'this.form.submit();'
        }
      })
      ui_deprecated.tag('input', {
        html_options = {
          type = 'hidden',
          value = value and tostring(value) or '',
          name = args.field,
          id = '_ui_calendar_input',
          onchange = 'this.form.submit();'
        }
      })
      if args.label then
        ui_deprecated.tag('div', {
          html_options = {
            class="label"
          },
          content = function()
            ui_deprecated.text(args.label)
          end
        })
      end
      ui_deprecated.tag('div', {
        html_options = {
          class="value"
        },
        content = function()
          ui_deprecated.tag('div', {
            html_options = {
              class = 'next',
              href = '#',
              onclick = enabled and "document.getElementById('_ui_calendar_year').value = '" .. tostring(next_year) .. "'; document.getElementById('_ui_calendar_month').value = '" .. tostring(next_month) .. "'; document.getElementById('_ui_calendar_year').form.submit();" or '', 
            },
            content = '>>>';
          })
          ui_deprecated.tag('div', {
            html_options = {
              class = 'prev',
              href = '#',
              onclick = enabled and "document.getElementById('_ui_calendar_year').value = '" .. tostring(prev_year) .. "'; document.getElementById('_ui_calendar_month').value = '" .. tostring(prev_month) .. "'; document.getElementById('_ui_calendar_year').form.submit();" or '', 
            },
            content = '<<<';
          })
          ui_deprecated.tag('div', {
            html_options = {
              class="title"
            },
            content = function()
              local months = {_'January', _'February', _'March', _'April', _'May', _'June', _'July', _'August', _'September', _'October', _'November', _'December' }
              ui_deprecated.text(months[month])
              ui_deprecated.text(' ')
              ui_deprecated.text(tostring(year))
            end
          })
          ui_deprecated.tag('table', { 
            content = function()
              ui_deprecated.tag('thead', { 
                content = function()
                  ui_deprecated.tag('tr', {
                    content = function()
                      local dows = { _'Mon', _'Tue', _'Wed', _'Thu', _'Fri', _'Sat', _'Sun' }
                      for col = 1,7 do
                        ui_deprecated.tag('th', { content = dows[col] })
                      end
                    end
                  })
                end
              })
              ui_deprecated.tag('tbody', { 
                content = function()
                  for row = 1,6 do
                    ui_deprecated.tag('tr', {
                      content = function()
                        for col = 1,7 do
                          local day = (row -1) * 7 + col - empty_days
                          local date = atom.date.invalid
                          if day > 0 then
                            date = atom.date{ year = year, month = month, day = day }
                          end
                          ui_deprecated.tag('td', {
                            html_options = {
                              onclick = enabled and 'document.getElementById(\'_ui_calendar_input\').value = \'' .. tostring(date) .. '\'; document.getElementById(\'_ui_calendar_input\').onchange(); ' or ''
                            },
                            content = function()
                              if date.invalid then
                                slot.put('&nbsp;')
                              else
                                local selected = date == value
                                args.day_func(date, selected)
                              end
                            end
                          })
                        end
                      end
                    })
                  end
                end
              })
            end
          })
        end
      })
    end
  })
end
