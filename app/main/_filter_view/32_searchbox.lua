if app.session.member == nil then
  execute.inner()
  return
end
--[[
slot.select('searchbox', function()

  ui.form{
    module = "index",
    view   = "search",
    method = "get",
    content = function()

      ui.field.select{
        name = "search_for",
        foreign_records = {
          { key = "global", name = _"Search" },
          { key = "member", name = _"Search members" },
          { key = "initiative", name = _"Search initiatives" },
          { key = "issue", name = _"Search issues" },
        },
        foreign_id = "key",
        foreign_name = "name"
      }

      ui.field.text{ name = "search", value = "" }
      ui.submit{ text = _"OK" }

    end
  }

end)
--]]
execute.inner();