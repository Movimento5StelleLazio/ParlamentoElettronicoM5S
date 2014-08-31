if not config.db_dump_dir then
    error("feature not enabled")
end

slot.put_into("title", _ "Download database dumps")

slot.select("actions", function()
    ui.link {
        content = function()
            ui.image { static = "icons/16/cancel.png" }
            slot.put(_ "Cancel")
        end,
        module = "admin",
        view = "index"
    }
end)


local file_list = extos.listdir(config.db_dump_dir)

local tmp = {}
for i, filename in ipairs(file_list) do
    if not filename:find("^%.") then
        tmp[#tmp + 1] = filename
    end
end

local file_list = tmp

table.sort(file_list, function(a, b) return a > b end)

ui.list {
    records = file_list,
    columns = {
        {
            content = function(filename)
                slot.put(encode.html(filename))
            end
        },
        {
            content = function(filename)
                ui.link {
                    content = _ "Download",
                    module = "admin",
                    view = "download_file",
                    params = { filename = filename }
                }
            end
        }
    }
}
