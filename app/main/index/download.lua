if not config.download_dir then
    error("feature not enabled")
end

slot.set_layout("custom")

ui.title(function()
    ui.container {
        attr = { class = "row-fluid" },
        content = function()
            ui.container {
                attr = { class = "span3 text-left" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-large large_btn fixclick btn-back" },
                        module = "member",
                        view = "settings",
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }

            ui.container {
                attr = { class = "span8 spaceline2 text-center label label-warning" },
                content = function()
                    ui.heading {
                        level = 1,
                        attr = { class = "fittext1 uppercase" },
                        content = _ "Download database export"
                    }
                end
            }
            ui.container {
                attr = { class = "span1 text-center spaceline" },
                content = function()
                    ui.field.popover {
                        attr = {
                            dataplacement = "left",
                            datahtml = "true";
                            datatitle = _ "Box di aiuto per la pagina",
                            datacontent = _ "In questa pagina puoi scaricare le repliche del nostro database. Installale sul tuo computer per consultare i dati salvati e verificare che non ci siano state manomissioni.",
                            datahtml = "true",
                            class = "text-center"
                        },
                        content = function()
                            ui.image { static = "png/tutor.png" }
                        end
                    }
                end
            }
        end
    }
end)

ui.container {
    attr = { class = "wiki use_terms" },
    content = function()
        slot.put(format.wiki_text(config.download_use_terms))
    end
}


local file_list = extos.listdir(config.download_dir)

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
                    module = "index",
                    view = "download_file",
                    params = { filename = filename }
                }
            end
        }
    }
}