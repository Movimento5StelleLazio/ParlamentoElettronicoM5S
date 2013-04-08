local member = Member:by_id(param.get_id())

slot.select("head", function()
  ui.container{
    attr = { class = "title" }, 
    content = _("Member name history for '#{name}'", { name = member.name })
  }
  ui.container{ attr = { class = "actions" }, content = function()
    ui.link{
      content = function()
          ui.image{ static = "icons/16/cancel.png" }
          slot.put(_"Back")
      end,
      module = "member",
      view = "show",
      id = member.id
    }
  end }
end)

ui.form{
  attr = { class = "vertical" },
  content = function()
    ui.field.text{ label = _"Current name", value = member.name }
    ui.field.text{ label = _"Current status", value = member.active and _'activated' or _'deactivated' }
  end
}


local entries = member:get_reference_selector("history_entries"):add_order_by("id DESC"):exec()

ui.tag{
  tag = "table",
  content = function()
    ui.tag{
      tag = "tr",
      content = function()
        ui.tag{
          tag = "th",
          content = _("Name")
        }
        ui.tag{
          tag = "th",
          content = _("Status")
        }
        ui.tag{
          tag = "th",
          content = _("until")
        }
      end
    }
    for i, entry in ipairs(entries) do
      ui.tag{
        tag = "tr",
        content = function()
          ui.tag{
            tag = "td",
            content = entry.name
          }
          ui.tag{
            tag = "td",
            content = entry.active and _'activated' or _'deactivated',
          }
          ui.tag{
            tag = "td",
            content = format.timestamp(entry["until"])
          }
        end
      }
    end
  end
}
slot.put("<br />")
ui.container{
  content = _("This member account has been created at #{created}", { created = format.timestamp(member.activated)})
}
