slot.set_layout("custom")

if not config.db_dump_dir then
    error("feature not enabled")
end

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
                content = _ "Download database dumps"
            }
        end
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
