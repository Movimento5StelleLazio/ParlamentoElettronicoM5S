local initiative_id = param.get("initiative_id")

slot.put_into("title", _"Add new suggestion")

ui.actions(function()
  ui.link{
    content = function()
        ui.image{ static = "icons/16/cancel.png" }
        slot.put(_"Cancel")
    end,
    module = "initiative",
    view = "show",
    id = initiative_id,
    params = { tab = "suggestions" }
  }
end)

ui.form{
  module = "suggestion",
  action = "add",
  params = { initiative_id = initiative_id },
  routing = {
    default = {
      mode = "redirect",
      module = "initiative",
      view = "show",
      id = initiative_id,
      params = { tab = "suggestions" }
    }
  },
  attr = { class = "vertical" },
  content = function()
    local supported = Supporter:by_pk(initiative_id, app.session.member.id) and true or false
    if not supported then
      ui.field.text{
        attr = { class = "warning" },
        value = _"You are currently not supporting this initiative directly. By adding suggestions to this initiative you will automatically become a potential supporter."
      }
    end
    ui.field.select{
      label = _"Degree",
      name = "degree",
      foreign_records = {
        { id =  1, name = _"should"},
        { id =  2, name = _"must"},
      },
      foreign_id = "id",
      foreign_name = "name"
    }
    ui.field.text{ label = _"Title (80 chars max)", name = "name" }
    ui.field.select{
      label = _"Wiki engine",
      name = "formatting_engine",
      foreign_records = {
        { id = "rocketwiki", name = "RocketWiki" },
        { id = "compat", name = _"Traditional wiki syntax" }
      },
      attr = {id = "formatting_engine"},
      foreign_id = "id",
      foreign_name = "name",
      value = param.get("formatting_engine")
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
      label = _"Description",
      name = "content",
      multiline = true, 
      attr = { style = "height: 50ex;" },
      value = param.get("content")
    }

    
    ui.submit{ text = _"Commit suggestion" }
  end
}
