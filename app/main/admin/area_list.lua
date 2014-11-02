slot.set_layout("custom")

local unit_id = param.get("unit_id", atom.integer)
local unit = Unit:by_id(unit_id)

local show_not_in_use = param.get("show_not_in_use", atom.boolean) or false

local areas = Area:build_selector { unit_id = unit_id, active = not show_not_in_use }:exec()

ui.title(function()
    ui.container {
        attr = { class = "row-fluid text-left" },
        content = function()
            ui.container {
                attr = { class = "span3" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-large large_btn fixclick btn-back" },
                        module = "admin",
                        view = "unit_list",
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            ui.tag {
                tag = "strong",
                attr = { class = "span9 text-center" },
                content = _("Area list of '#{unit_name}'", { unit_name = unit.name })
            }
        end
    }
end)

ui.actions(function()
    ui.container {
        attr = { class = "row-fluid spaceline2" },
        content = function()
            if show_not_in_use then
                ui.link {
                    text = _ "Show areas in use",
                    module = "admin",
                    view = "area_list",
                    params = { unit_id = unit_id },
                    attr = { class = "offset2 span2 btn btn-primary text-center" }
                }

            else
                ui.link {
                    text = _ "Create new area",
                    module = "admin",
                    view = "area_show",
                    params = { unit_id = unit_id },
                    attr = { class = "offset2 span2 btn btn-primary text-center" }
                }

                ui.link {
                    text = _ "Show areas not in use",
                    module = "admin",
                    view = "area_list",
                    params = { show_not_in_use = true, unit_id = unit_id },
                    attr = { class = "span2 btn btn-primary text-center" }
                }

                ui.link {
                    text = _ "Save areas as template",
                    module = "admin",
                    view = "save_areas_template",
                    params = { unit_name = unit.name, unit_id = unit_id, areas = areas },
                    attr = { class = "span2 btn btn-primary text-center" }
                }

                ui.link {
                    text = _ "Paste areas from template",
                    module = "admin",
                    view = "paste_areas_template",
                    params = { unit_name = unit.name, unit_id = unit_id, areas = areas },
                    attr = { class = "span2 btn btn-primary text-center" }
                }
            end
        end
    }
end)

ui.list {
    records = areas,
    columns = {
        { label = _ "Area", name = "name" },

        {
            content = function(record)
                if app.session.member.admin then
                    ui.link {
                        attr = { class = { "action admin_only" } },
                        text = _ "Edit",
                        module = "admin",
                        view = "area_show",
                        id = record.id
                    }
                end
            end
        }
    }
}
