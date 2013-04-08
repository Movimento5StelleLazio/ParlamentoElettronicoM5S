function util.gregor(el_id, relaxed)
  ui.script{ script =
       'gregor_addGui({' ..
          'element_id: "' .. el_id .. '",' ..
          'month_names: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],' ..
          'weekday_names: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"],' ..
          'week_mode: "iso",' ..
          'week_numbers: "left",' ..
          (relaxed and 'relaxed: true,' or '') ..
        '});'
  }
end
