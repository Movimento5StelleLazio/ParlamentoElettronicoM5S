slot.set_layout("custom")

local inactive = param.get("inactive", atom.boolean)

local units = Unit:get_flattened_tree { include_inactive = inactive }

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
                        view = "index",
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            ui.tag {
                tag = "strong",
                attr = { class = "span9 text-center" },
                content = _ "Unit list"
            }
        end
    }
end)

ui.actions(function()
    ui.container {
        attr = { class = "row-fluid spaceline2" },
        content = function()
            ui.link {
                text = _ "Create new unit",
                module = "admin",
                view = "unit_edit",
                attr = { class = "offset4 span2 btn btn-primary text-center" }
            }
            if inactive then
                ui.link {
                    text = _ "Hide active units",
                    module = "admin",
                    view = "unit_list",
                    attr = { class = "offset1 span2 btn btn-primary text-center" }
                }
            else
                ui.link {
                    text = _ "Show inactive units",
                    module = "admin",
                    view = "unit_list",
                    params = { inactive = true },
                    attr = { class = "offset1 span2 btn btn-primary text-center" }
                }
            end
        end
    }
end)

ui.list {
    records = units,
    columns = {
        {
            content = function(unit)
                for i = 1, unit.depth - 1 do
                    slot.put("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
                end
                local style = ""
                if not unit.active then
                    style = "text-decoration: line-through;"
                end
                ui.link {
                    attr = { style = "font-weight: bold;" .. style },
                    text = unit.name,
                    module = "admin",
                    view = "unit_edit",
                    id = unit.id
                }
                slot.put(" &middot; ")
                ui.link {
                    text = _ "Edit areas",
                    module = "admin",
                    view = "area_list",
                    params = { unit_id = unit.id }
                }
            end
        }
    }
}
