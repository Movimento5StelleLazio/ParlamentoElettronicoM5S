slot.set_layout("custom")

local id = param.get_id()

local unit = Unit:by_id(id)

ui.title(function()
    ui.container {
        attr = { class = "row text-left" },
        content = function()
            ui.container {
                attr = { class = "col-md-3" },
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
            if unit then
                ui.tag {
                    tag = "strong",
                    attr = { class = "col-md-9 text-center" },
                    content = _("Unit: '#{name}'", { name = unit.name })
                }
            else
                ui.tag {
                    tag = "strong",
                    attr = { class = "col-md-9 text-center" },
                    content = _ "Add new unit"
                }
            end
        end
    }
end)


local units = {
    { id = nil, name = "" }
}

for i, unit in ipairs(Unit:get_flattened_tree()) do
    units[#units + 1] = { id = unit.id, name = unit.name }
end

ui.form {
    attr = { class = "vertical" },
    module = "admin",
    action = "unit_update",
    id = unit and unit.id,
    record = unit,
    routing = {
        default = {
            mode = "redirect",
            modules = "admin",
            view = "unit_list"
        }
    },
    content = function()
        ui.field.select {
            label = _ "Parent unit",
            name = "parent_id",
            foreign_records = units,
            foreign_id = "id",
            foreign_name = "name"
        }
        ui.field.text { label = _ "Name", name = "name" }
        ui.field.text { label = _ "Description", name = "description", multiline = true }
        ui.field.boolean { label = _ "Active?", name = "active" }
        ui.field.boolean { label = _ "Public?", name = "public" }

        slot.put("<br />")
        ui.submit { text = _ "Save" }
    end
}
