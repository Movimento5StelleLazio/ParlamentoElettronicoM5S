function ui.tabs(tabs)
    local attr = tabs.attr or {}
    attr.class = (attr.class and attr.class .. " " or "") .. "row"
    ui.container {
        attr = attr,
        content = function()
            local params = param.get_all_cgi()
            local current_tab = params["tab"]
            ui.container {
                attr = { class = "row" },
                content = function()
                    ui.container {
                        attr = { class = "col-md-12 well text-center spaceline spaceline-bottom" },
                        content = function()
                            ui.container {
                                attr = { class = "row" },
                                content = function()
                                    ui.container {
                                        attr = { class = "col-md-11" },
                                        content = function()
                                            for i, tab in ipairs(tabs) do
                                                local params = param.get_all_cgi()
                                                if tab.link_params then
                                                    for key, value in pairs(tab.link_params) do
                                                        params[key] = value
                                                    end
                                                end
                                                params["tab"] = i > 1 and tab.name or nil
                                                ui.link {
                                                    attr = {
                                                        class = "btn btn-primary large_btn margin_line spaceline spaceline-bottom", (tab.name == current_tab and "selected" .. (tab.class and (" " .. tab.class) or "") or
                                                                not current_tab and i == 1 and "selected" .. (tab.class and (" " .. tab.class) or "") or
                                                                "" .. (tab.class and (" " .. tab.class) or ""))
                                                    },
                                                    module = request.get_module(),
                                                    view = request.get_view(),
                                                    id = param.get_id_cgi(),
                                                    content = tab.label,
                                                    params = params
                                                }
                                                slot.put(" ")
                                            end
                                        end
                                    }
                                end
                            }
                        end
                    }
                end
            }
            for i, tab in ipairs(tabs) do
                if tab.name == current_tab and i > 1 then
                    app.html_title.prefix = tab.label
                end
                if tab.name == current_tab or not current_tab and i == 1 then
                    ui.container {
                        attr = { class = "row" },
                        content = function()
			                    ui.container {
			                        attr = { class = "col-md-12 slot_head" },
			                        content = function() 
				                            if tab.content then
				                                tab.content()
				                            else
				                                execute.view {
				                                    module = tab.module,
				                                    view = tab.view,
				                                    id = tab.id,
				                                    params = tab.params,
				                                }
				                            end
			                        end
			                    }
	                    end
                    }
                end
            end
        end
    }
end
