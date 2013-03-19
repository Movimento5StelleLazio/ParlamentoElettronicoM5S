local code = util.trim(param.get("code"))

local member = Member:new_selector()
  :add_where{ "invite_code = ?", code }
  :add_where{ "activated ISNULL" }
  :add_where{ "NOT locked" }
  :optional_object_mode()
  :for_update()
  :exec()
  
if not member then
  slot.put_into("error", _"The code you've entered is invalid")
  request.redirect{
    mode   = "forward",
    module = "index",
    view   = "register"
  }
  return false
end

local notify_email = param.get("notify_email")

if not config.locked_profile_fields.notify_email and notify_email then
  if #notify_email < 5 then
    slot.put_into("error", _"Email address too short!")
    request.redirect{
      mode   = "redirect",
      module = "index",
      view   = "register",
      params = { code = member.invite_code }
    }
    return false
  end
end

if member and not notify_email then
  request.redirect{
    mode   = "redirect",
    module = "index",
    view   = "register",
    params = { code = member.invite_code, step = 1 }
  }
  return false
end


local name = util.trim(param.get("name"))

if not config.locked_profile_fields.name and name then

  if #name < 3 then
    slot.put_into("error", _"This screen name is too short!")
    request.redirect{
      mode   = "redirect",
      module = "index",
      view   = "register",
      params = {
        code = member.invite_code,
        notify_email = notify_email,
        step = 1
      }
    }
    return false
  end

  local check_member = Member:by_name(name)
  if check_member and check_member.id ~= member.id then
    slot.put_into("error", _"This name is already taken, please choose another one!")
    request.redirect{
      mode   = "redirect",
      module = "index",
      view   = "register",
      params = {
        code = member.invite_code,
        notify_email = notify_email,
        step = 1
      }
    }
    return false
  end

  member.name = name

end

if notify_email and not member.name then
  request.redirect{
    mode   = "redirect",
    module = "index",
    view   = "register",
    params = {
      code = member.invite_code,
      notify_email = notify_email,
      step = 1
    }
  }
  return false
end


local login = util.trim(param.get("login"))

if not config.locked_profile_fields.login and login then
  if #login < 3 then 
    slot.put_into("error", _"This login is too short!")
    request.redirect{
      mode   = "redirect",
      module = "index",
      view   = "register",
      params = { 
        code = member.invite_code,
        notify_email = notify_email,
        name = member.name,
        step = 1
      }
    }
    return false
  end

  local check_member = Member:by_login(login)
  if check_member and check_member.id ~= member.id then 
    slot.put_into("error", _"This login is already taken, please choose another one!")
    request.redirect{
      mode   = "redirect",
      module = "index",
      view   = "register",
      params = { 
        code = member.invite_code,
        notify_email = notify_email,
        name = member.name,
        step = 1
      }
    }
    return false
  end
  member.login = login
end

if member.name and not member.login then
  request.redirect{
    mode   = "redirect",
    module = "index",
    view   = "register",
    params = { 
      code = member.invite_code,
      notify_email = notify_email,
      name = member.name,
      step = 1
    }
  }
  return false
end

local step = param.get("step", atom.integer)

if step > 2 then

  for i, checkbox in ipairs(config.use_terms_checkboxes) do
    local accepted = param.get("use_terms_checkbox_" .. checkbox.name, atom.boolean)
    if not accepted then
      slot.put_into("error", checkbox.not_accepted_error)
      return false
    end
  end  

  local password1 = param.get("password1")
  local password2 = param.get("password2")

  if login and not password1 then
    request.redirect{
      mode   = "redirect",
      module = "index",
      view   = "register",
      params = { 
        code = member.invite_code,
        notify_email = notify_email,
        name = member.name,
        login = member.login
      }
    }
  --]]
    return false
  end

  if password1 ~= password2 then
    slot.put_into("error", _"Passwords don't match!")
    return false
  end

  if #password1 < 8 then
    slot.put_into("error", _"Passwords must consist of at least 8 characters!")
    return false
  end

  if not config.locked_profile_fields.login then
    member.login = login
  end

  if not config.locked_profile_fields.name then
    member.name = name
  end

  if notify_email ~= member.notify_email then
    local success = member:set_notify_email(notify_email)
    if not success then
      slot.put_into("error", _"Can't send confirmation email")
      return
    end
  end
  
  member:set_password(password1)

  local now = db:query("SELECT now() AS now", "object").now

  for i, checkbox in ipairs(config.use_terms_checkboxes) do
    local accepted = param.get("use_terms_checkbox_" .. checkbox.name, atom.boolean)
    member:set_setting("use_terms_checkbox_" .. checkbox.name, "accepted at " .. tostring(now))
  end

  member.activated = 'now'
  member.active = true
  member.last_activity = 'now'
  member:save()

  slot.put_into("notice", _"You've successfully registered and you can login now with your login and password!")

  request.redirect{
    mode   = "redirect",
    module = "index",
    view   = "login",
  }
end
  
