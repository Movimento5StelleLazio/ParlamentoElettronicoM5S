ui.title(_"Settings")

local pages = {}

if not config.locked_profile_fields.name then
  pages[#pages+1] = { view = "settings_name",           text = _"Change your screen name" }
end
if not config.locked_profile_fields.login then
  pages[#pages+1] = { view = "settings_login",          text = _"Change your login" }
end
pages[#pages+1] = { view = "settings_password",       text = _"Change your password" }
if not config.locked_profile_fields.notify_email then
  pages[#pages+1] = { view = "settings_email",          text = _"Change your notification email address" }
end
pages[#pages+1] = { view = "settings_notification", text = _"Notification settings" }
pages[#pages+1] = { view = "developer_settings",      text = _"Developer settings" }

if config.download_dir then
  pages[#pages+1] = { module = "index", view = "download",      text = _"Database download" }
end

ui.list{
  attr = { class = "menu_list" },
  style = "ulli",
  records = pages,
  columns = {
    {
      content = function(page)
        ui.link{
          module = page.module or "member",
          view = page.view,
          text = page.text
        }
      end
    }
  }
}

