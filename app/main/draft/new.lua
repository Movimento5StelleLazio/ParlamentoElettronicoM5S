slot.put_into("title", _"Edit draft")

local initiative = Initiative:by_id(param.get("initiative_id"))

ui.actions(function()
  ui.link{
    content = function()
        ui.image{ static = "icons/16/cancel.png" }
        slot.put(_"Cancel")
    end,
    module = "initiative",
    view = "show",
    id = initiative.id
  }
end)



ui.form{
  record = initiative.current_draft,
  attr = { class = "vertical" },
  module = "draft",
  action = "add",
  params = { initiative_id = initiative.id },
  routing = {
    ok = {
      mode = "redirect",
      module = "initiative",
      view = "show",
      id = initiative.id
    }
  },
  content = function()

    ui.field.text{ label = _"Unit", value = initiative.issue.area.unit.name, readonly = true }
    ui.field.text{ label = _"Area", value = initiative.issue.area.name, readonly = true }
    ui.field.text{ label = _"Policy", value = initiative.issue.policy.name, readonly = true }
    ui.field.text{ label = _"Issue", value = _("Issue ##{id}", { id = initiative.issue.id } ), readonly = true }
    slot.put("<br />")
    ui.field.text{ label = _"Initiative", value = initiative.name, readonly = true }

    if param.get("preview") then
      ui.container{
        attr = { class = "draft_content wiki" },
        content = function()
          slot.put(format.wiki_text(param.get("content"), param.get("formatting_engine")))
        end
      }
      slot.put("<br />")
      ui.submit{ text = _"Save" }
      slot.put("<br />")
      slot.put("<br />")
    end
    slot.put("<br />")


    ui.field.select{
      label = _"Wiki engine",
      name = "formatting_engine",
      foreign_records = {
        { id = "rocketwiki", name = "RocketWiki" },
        { id = "compat", name = _"Traditional wiki syntax" }
      },
      attr = {id = "formatting_engine"},
      foreign_id = "id",
      foreign_name = "name"
    }
    ui.tag{
      tag = "div",
      content = function()
        ui.tag{
          tag = "label",
          attr = { class = "ui_field_label" },
          content = function() slot.put("&nbsp;") end,
        }
        ui.tag{
          content = function()
            ui.link{
              text = _"Syntax help",
              module = "help",
              view = "show",
              id = "wikisyntax",
              attr = {onClick="this.href=this.href.replace(/wikisyntax[^.]*/g, 'wikisyntax_'+getElementById('formatting_engine').value)"}
            }
            slot.put(" ")
            ui.link{
              text = _"(new window)",
              module = "help",
              view = "show",
              id = "wikisyntax",
              attr = {target = "_blank", onClick="this.href=this.href.replace(/wikisyntax[^.]*/g, 'wikisyntax_'+getElementById('formatting_engine').value)"}
            }
          end
        }
      end
    }
    ui.field.text{
      label = _"Content",
      name = "content",
      multiline = true,
      attr = { style = "height: 50ex;" },
      value = param.get("content")
   }

    ui.submit{ name = "preview", text = _"Preview" }
    ui.submit{ text = _"Save" }
  end
}
