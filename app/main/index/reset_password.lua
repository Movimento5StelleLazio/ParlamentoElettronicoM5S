execute.view{ module = "index", view = "_lang_chooser" }

slot.put_into("title", _"Reset password")

slot.select("actions", function()
  ui.link{
    content = function()
        ui.image{ static = "icons/16/cancel.png" }
        slot.put(_"Cancel password reset")
    end,
    module = "index",
    view = "index"
  }
end)


local secret = param.get("secret")

if not secret then
  ui.tag{
    tag = 'p',
    content = _'Please enter your login name. You will receive an email with a link to reset your password.'
  }
  ui.form{
    attr = { class = "vertical" },
    module = "index",
    action = "reset_password",
    routing = {
      ok = {
        mode = "redirect",
        module = "index",
        view = "index"
      }
    },
    content = function()
      ui.field.text{ 
        label = "Login",
        name = "login"
      }
      ui.submit{ text = _"Request password reset link" }
    end
  }

else

  ui.form{
    attr = { class = "vertical" },
    module = "index",
    action = "reset_password",
    routing = {
      ok = {
        mode = "redirect",
        module = "index",
        view = "index"
      }
    },
    content = function()
      ui.tag{
        tag = 'p',
        content = _'Please enter the email reset code you have received:'
      }
      ui.field.text{
        label = _"Reset code",
        name = "secret",
        value = secret
      }
      ui.tag{
        tag = 'p',
        content = _'Please enter your new password twice.'
      }
      ui.field.password{
        label = "New password",
        name = "password1"
      }
      ui.field.password{
        label = "New password (repeat)",
        name = "password2"
      }
      ui.submit{ text = _"Set new password" }
    end
  }

end