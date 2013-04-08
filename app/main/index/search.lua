local search_for = param.get("search_for", atom.string) or "global"
local search_string = param.get("search", atom.string)

if search_string then
  slot.put_into("title", encode.html(_("Search results for: '#{search}'", { search  = search_string })))
else
  slot.put_into("title", encode.html(_"Search"))
end

ui.form{
  method = "get", module = "index", view = "search",
  routing = { default = { mode = "redirect",
    module = "index", view = "search", search_for = search_for, search = search_string
  } },
  attr = { class = "vertical" },
  content = function()
    
    if app.session:has_access("everything") then
      ui.field.select{
        label = _"Search context",
        name = "search_for",
        value = search_for,
        foreign_records = {
          { id = "global", name = _"Global search" },
          { id = "member", name = _"Search for members" },
          { id = "issue", name = _"Search for issues" }
        },
        foreign_id = "id",
        foreign_name = "name",
      }
    end
    ui.field.text{ label = _"Search term (only complete words)", name = "search", value = search_string }
    ui.submit{ value = _"Start search" }
  end
}

slot.put("<br />")

if search_string then

  if app.session:has_access("everything") then
    if search_for == "global" or search_for == "member" then
      local members_selector = Member:get_search_selector(search_string)
      execute.view{
        module = "member",
        view = "_list",
        params = { members_selector = members_selector },
      }
    end
  end
    
  if search_for == "global" or search_for == "issue" then
    local issues_selector = Issue:get_search_selector(search_string)
    execute.view{
      module = "issue",
      view = "_list",
      params = {
        issues_selector = issues_selector,
        highlight_string = search_string,
        no_filter = true
      },
    }
  end
  
end
