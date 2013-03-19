ui.tag{
  tag = "noscript",
  content = function()
    slot.put(_"JavaScript is disabled or not available.")
  end
}

execute.view{ module = "index", view = "_lang_chooser" }

ui.title(_"Login")
app.html_title.title = _"Login"

if config.motd_public then
  local help_text = config.motd_public
  ui.container{
    attr = { class = "wiki motd" },
    content = function()
      slot.put(format.wiki_text(help_text))
    end
  }
end

if app.session:has_access("anonymous") then
  ui.tag{
    tag = 'p',
    content = _'You need to be logged in, to use all features of this system.'
  }
else
  ui.tag{ tag = "p", content = _"Closed user group, please login to participate." }
end

ui.form{
  attr = { class = "login" },
  module = 'index',
  action = 'login',
  routing = {
    ok = {
      mode   = 'redirect',
      module = param.get("redirect_module") or "index",
      view = param.get("redirect_view") or "index",
      id = param.get("redirect_id"),
    },
    error = {
      mode   = 'forward',
      module = 'index',
      view   = 'login',
    }
  },
  content = function()
    ui.field.text{
      attr = { id = "username_field" },
      label     = _'login name',
      html_name = 'login',
      value     = ''
    }
    ui.script{ script = 'document.getElementById("username_field").focus();' }
    ui.field.password{
      label     = _'Password',
      html_name = 'password',
      value     = ''
    }
    ui.submit{
      text = _'Login'
    }
  end
}
