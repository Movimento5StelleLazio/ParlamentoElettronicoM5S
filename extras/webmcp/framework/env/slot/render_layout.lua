--[[--
output =              -- document/data to be sent to the web browser
slot.render_layout()

This function returns the selected layout after replacing all slot placeholders with the respective slot contents. If slot.set_layout(...) was called with nil as first argument, then no layout will be used, but only the contents of the slot named "data" are returned.

--]] --

function slot.render_layout()
    if slot._current_layout then
        local layout_file = assert(io.open(encode.file_path(request.get_app_basepath(),
            'app',
            request.get_app_name(),
            '_layout',
            slot._current_layout .. '.html'),
            'r'))
        local layout = layout_file:read("*a")
        io.close(layout_file)

        -- render layout
        layout = string.gsub(layout, "__BASEURL__/?", request.get_relative_baseurl()) -- TODO: find a better placeholder than __BASEURL__ ?
        layout = string.gsub(layout, '<!%-%- *WEBMCP +SLOT +([^ ]+) *%-%->',
            function(slot_ident)
                if #slot.get_content(slot_ident) > 0 then
                    local add_class = ''
                    if slot_ident == 'default' then add_class = ' container' end
                    if slot_ident == 'navbar' then add_class = ' container' end
                    if slot_ident == 'notice' then add_class = ' col-md-12 alert alert-info' end
                    if slot_ident == 'warning' then add_class = ' col-md-12 alert alert-warning' end
                    if slot_ident == 'error' then add_class = ' col-md-12 alert alert-error' end

                    return '<div class="well slot_' .. slot_ident .. add_class .. '" id="slot_' .. slot_ident .. '">' .. slot.get_content(slot_ident) .. '</div>'
                else
                    return ''
                end
            end)
        layout = string.gsub(layout, '<!%-%- *WEBMCP +SLOTNODIV +([^ ]+) *%-%->',
            function(slot_ident)
                if #slot.get_content(slot_ident) > 0 then
                    return slot.get_content(slot_ident)
                else
                    return ''
                end
            end)
        return layout
    else
        return slot.get_content("data")
    end
end
