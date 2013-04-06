ui.form{
  method = "get",
  module = "draft",
  view = "diff",
  content = function()
    ui.list{
      records = param.get("drafts", "table"),
      columns = {
        {
          label = _"Created at",
          content = function(record)
            ui.field.text{ readonly = true, value = format.timestamp(record.created) }
          end
        },
        {
          label = _"Author",
          content = function(record)
            if record.author then
              return record.author:ui_field_text()
            end
          end
        },
        {
          content = function(record)
            ui.link{
              attr = { class = "action" },
              text = _"Show",
              module = "draft",
              view = "show",
              id = record.id
            }
          end
        },
        {
          label = _"Compare",
          content = function(record)
            slot.put('<input type="radio" name="old_draft_id" value="' .. tostring(record.id) .. '">')
            slot.put('<input type="radio" name="new_draft_id" value="' .. tostring(record.id) .. '">')
          end
        }
      }
    }
    ui.submit{ text = _"Compare" }
  end
}
