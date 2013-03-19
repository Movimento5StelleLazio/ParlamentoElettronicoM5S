ui.title(_"Developer settings")


local setting_key = "liquidfeedback_frontend_developer_features"
local setting = Setting:by_pk(app.session.member.id, setting_key)

if setting then
  ui.form{
    attr = { class = "vertical" },
    module = "member",
    action = "update_stylesheet_url",
    routing = {
      ok = {
        mode = "redirect",
        module = "index",
        view = "index"
      }
    },
    content = function()
      local setting_key = "liquidfeedback_frontend_stylesheet_url"
      local setting = Setting:by_pk(app.session.member.id, setting_key)
      local value = setting and setting.value
      ui.field.text{ 
        label = _"Stylesheet URL",
        name = "stylesheet_url",
        value = value
      }
      ui.submit{ value = _"Set URL" }
    end
  }
end

ui.heading{ content = _"API keys" }

local member_applications = MemberApplication:new_selector()
  :add_where{ "member_id = ?", app.session.member.id }
  :add_order_by("name, id")
  :exec()
  
if #member_applications > 0 then

  ui.list{
    records = member_applications,
    columns = {
      {
        name = "name",
        label = _"Name"
      },
      {
        name = "access_level",
        label = _"Access level"
      },
      {
        name = "key",
        label = _"API Key"
      },
      {
        name = "last_usage",
        label = "Last usage"
      },
      {
        content = function(member_application)
          ui.link{
            text = _"Delete",
            module = "member", action = "update_api_key", id = member_application.id,
            params = { delete = true },
            routing = {
              default = {
                mode = "redirect",
                module = "member",
                view = "developer_settings"
              }
            }
          }
        end
      },
    }
  }

else
  
  slot.put(_"Currently no API key is set.")
  slot.put(" ")
  ui.link{
    text = _"Generate API key",
    module = "member",
    action = "update_api_key",
    routing = {
      default = {
        mode = "redirect",
        module = "member",
        view = "developer_settings"
      }
    }
  }
end
