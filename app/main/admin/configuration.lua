ui.title(_ "Configuration")

local gui_preset = db:query('SELECT gui_preset FROM system_setting')[1][1]

local guis = {
    { id = 0, name = "<select gui_preset>" }
}

local selected_gui_preset

for i, v in pairs(config.gui_preset) do
    guis[#guis + 1] = { id = i, name = v.name }
    if v.name == gui_preset then
        selected_gui_preset = i
    end
end

ui.form {
    attr = { class = "vertical" },
    module = "admin",
    action = "configuration_update",
    routing = {
        default = {
            mode = "redirect",
            modules = "admin",
            view = "index"
        },
        ok = {
            mode = "redirect",
            modules = "admin",
            view = "index"
        },
        error = {
            mode = "redirect",
            modules = "admin",
            view = "configuration"
        }
    },
    content = function()
        ui.field.select {
            label = _ "GUI Preset",
            name = "gui_preset",
            selected_record = selected_gui_preset,
            foreign_records = guis,
            foreign_id = "id",
            foreign_name = "name"
        }

        slot.put("<br />")
        ui.submit { text = _ "Save" }
    end
}

