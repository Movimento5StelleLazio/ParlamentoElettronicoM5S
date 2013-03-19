if not config.download_dir then
  error("feature not enabled")
end

slot.put_into("title", _"Download database export")

slot.select("actions", function()
  ui.link{
    content = function()
        ui.image{ static = "icons/16/cancel.png" }
        slot.put(_"Cancel")
    end,
    module = "index",
    view = "index"
  }
end)

util.help("index.download", _"Download")

ui.container{
  attr = { class = "wiki use_terms" },
  content = function()
    slot.put(format.wiki_text(config.download_use_terms))
  end
}


local file_list = extos.listdir(config.download_dir)

local tmp = {}
for i, filename in ipairs(file_list) do
  if not filename:find("^%.") then
    tmp[#tmp+1] = filename
  end
end

local file_list = tmp

table.sort(file_list, function(a, b) return a > b end)

ui.list{
  records = file_list,
  columns = {
    {
      content = function(filename)
        slot.put(encode.html(filename))
      end
    },
    {
      content = function(filename)
        ui.link{
          content = _"Download",
          module = "index",
          view = "download_file",
          params = { filename = filename }
        }
      end
    }
  }
}