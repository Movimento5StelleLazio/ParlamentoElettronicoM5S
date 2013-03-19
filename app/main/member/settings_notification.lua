ui.title(_"Notification settings")

util.help("member.settings.notification", _"Notification settings")

ui.form{
  attr = { class = "vertical" },
  module = "member",
  action = "update_notify_level",
  routing = {
    ok = {
      mode = "redirect",
      module = "index",
      view = "index"
    }
  },
  content = function()
    ui.tag{ tag = "p", content = _"I like to receive notifications by email about events in my areas and issues:" }
  
    ui.container{ content = function()
      ui.tag{
        tag = "input", 
        attr = {
          id = "notify_level_none",
          type = "radio", name = "notify_level", value = "none",
          checked = app.session.member.notify_level == 'none' and "checked" or nil
        }
      }
      ui.tag{
        tag = "label", attr = { ['for'] = "notify_level_none" },
        content = _"No notifications at all"
      }
    end }
     
    slot.put("<br />")
  
    ui.container{ content = function()
      ui.tag{
        tag = "input", 
        attr = {
          id = "notify_level_all",
          type = "radio", name = "notify_level", value = "all",
          checked = app.session.member.notify_level == 'all' and "checked" or nil
        }
      }
      ui.tag{
        tag = "label", attr = { ['for'] = "notify_level_all" },
        content = _"All of them"
      }
    end }
    
    slot.put("<br />")

    ui.container{ content = function()
      ui.tag{
        tag = "input", 
        attr = {
          id = "notify_level_discussion",
          type = "radio", name = "notify_level", value = "discussion",
          checked = app.session.member.notify_level == 'discussion' and "checked" or nil
        }
      }
      ui.tag{
        tag = "label", attr = { ['for'] = "notify_level_discussion" },
        content = _"Only for issues reaching the discussion phase"
      }
    end }

    slot.put("<br />")

    ui.container{ content = function()
      ui.tag{
        tag = "input", 
        attr = {
          id = "notify_level_verification",
          type = "radio", name = "notify_level", value = "verification",
          checked = app.session.member.notify_level == 'verification' and "checked" or nil
        }
      }
      ui.tag{
        tag = "label", attr = { ['for'] = "notify_level_verification" },
        content = _"Only for issues reaching the frozen phase"
      }
    end }
    
    slot.put("<br />")

    ui.container{ content = function()
      ui.tag{
        tag = "input", 
        attr = {
          id = "notify_level_voting",
          type = "radio", name = "notify_level", value = "voting",
          checked = app.session.member.notify_level == 'voting' and "checked" or nil
        }
      }
      ui.tag{
        tag = "label", attr = { ['for'] = "notify_level_voting" },
        content = _"Only for issues reaching the voting phase"
      }
    end }

    slot.put("<br />")

    ui.submit{ value = _"Change notification settings" }
  end
}
 
