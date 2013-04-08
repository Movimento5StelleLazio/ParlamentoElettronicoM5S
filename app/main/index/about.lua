ui.title(_"About site")

if app.session.member_id and config.use_terms then
  ui.actions(function()
    ui.link{
      module = "index",
      view = "usage_terms",
      text = _"Terms of use"
    }
  end)
end


slot.put("<br />")
ui.field.text{ attr = { style = "font-weight: bold;" }, value = _"This service is provided by:" }
slot.put("<br />")

slot.put(config.app_service_provider)

slot.put("<br />")
slot.put("<br />")
slot.put("<br />")


ui.field.text{ attr = { style = "font-weight: bold;" }, value = _"This service is provided using the following software components:" }
slot.put("<br />")

local tmp = {
  {
    name = "LiquidFeedback Frontend",
    url = "http://www.public-software-group.org/liquid_feedback",
    version = config.app_version,
    license = "MIT/X11",
    license_url = "http://www.public-software-group.org/licenses"
  },
  {
    name = "LiquidFeedback Core",
    url = "http://www.public-software-group.org/liquid_feedback",
    version = db:query("SELECT * from liquid_feedback_version;")[1].string,
    license = "MIT/X11",
    license_url = "http://www.public-software-group.org/licenses"
  },
  {
    name = "WebMCP",
    url = "http://www.public-software-group.org/webmcp",
    version = _WEBMCP_VERSION,
    license = "MIT/X11",
    license_url = "http://www.public-software-group.org/licenses"
  },
  {
    name = "Lua",
    url = "http://www.lua.org",
    version = _VERSION:gsub("Lua ", ""),
    license = "MIT/X11",
    license_url = "http://www.lua.org/license.html"
  },
  {
    name = "PostgreSQL",
    url = "http://www.postgresql.org/",
    version = db:query("SELECT version();")[1].version:gsub("PostgreSQL ", ""):gsub("on.*", ""),
    license = "BSD",
    license_url = "http://www.postgresql.org/about/licence"
  },
}

ui.list{
  records = tmp,
  columns = {
    {
      label = _"Software",
      content = function(record) 
        ui.link{
          content = record.name,
          external = record.url
        }
      end
    },
    {
      label = _"Version",
      content = function(record) ui.field.text{ value = record.version } end
    },
    {
      label = _"License",
      content = function(record) 
        ui.link{
          content = record.license,
          external = record.license_url
        }
      end

    }
  }
}

slot.put("<br />")
slot.put("<br />")
slot.put("<br />")

ui.field.text{ attr = { style = "font-weight: bold;" }, value = "3rd party license information:" }
slot.put("<br />")
slot.put('The icons used in Liquid Feedback (except national flags) are from <a href="http://www.famfamfam.com/lab/icons/silk/">Silk icon set 1.3</a> by Mark James. His work is licensed under a <a href="http://creativecommons.org/licenses/by/2.5/">Creative Commons Attribution 2.5 License.</a>')

