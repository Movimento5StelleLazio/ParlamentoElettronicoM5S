local timeline_filter = app.session.member:get_setting_map_by_key_and_subkey("timeline_filters", param.get("name"))

timeline_filter:destroy()