local member = param.get("member", "table")
local events = param.get_all_cgi()["events"] or "personal"

ui.container{ attr = { class = "ui_filter" }, content = function()
  ui.container{ attr = { class = "ui_filter_head" }, content = function()

    ui.link{
      attr = { class = events == "personal" and "ui_tabs_link active" or nil },
      text = _"My areas and issues",
      module = "index", view = "index", params = { tab = "timeline", events = "personal" }
    }
    
    slot.put(" ")

    ui.link{
      attr = { class = events == "global" and "active" or nil },
      text = _"Everything",
      module = "index", view = "index", params = { tab = "timeline", events = "global" }
    }
  end }
end }

if events == "personal" then
  execute.view{
    module = "event", view = "_list"
  }
elseif events == "global" then
  execute.view{
    module = "event", view = "_list", params = { global = true } 
  }
end
