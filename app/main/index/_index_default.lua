if app.session.member_id then
  util.help("index.index", _"Home")

  execute.view{
    module = "index", view = "_index_member"
  }

elseif app.session:has_access("anonymous") then
  if config.motd_public then
    local help_text = config.motd_public
    ui.container{
      attr = { class = "wiki motd" },
      content = function()
        slot.put(format.wiki_text(help_text))
      end
    }
  end
  
  local open_issues_selector = Issue:new_selector()
    :add_where("issue.closed ISNULL")
    :add_order_by("coalesce(issue.fully_frozen + issue.voting_time, issue.half_frozen + issue.verification_time, issue.accepted + issue.discussion_time, issue.created + issue.admission_time) - now()")

  local closed_issues_selector = Issue:new_selector()
    :add_where("issue.closed NOTNULL")
    :add_order_by("issue.closed DESC")

  
  local tabs = {
    module = "index",
    view = "index"
  }

  tabs[#tabs+1] = {
    name = "units",
    label = _"Units",
    module = "unit",
    view = "_list"
  }

  tabs[#tabs+1] = {
    name = "timeline",
    label = _"Latest events",
    module = "event",
    view = "_list",
    params = { global = true }
  }

  tabs[#tabs+1] = {
    name = "open",
    label = _"Open issues",
    module = "issue",
    view = "_list",
    params = {
      for_state = "open",
      issues_selector = open_issues_selector
    }
  }
  tabs[#tabs+1] = {
    name = "closed",
    label = _"Closed issues",
    module = "issue",
    view = "_list",
    params = {
      for_state = "closed",
      issues_selector = closed_issues_selector
    }
  }

  if app.session:has_access('all_pseudonymous') then
    tabs[#tabs+1] = {
      name = "members",
      label = _"Members",
      module = 'member',
      view   = '_list',
      params = { members_selector = Member:new_selector():add_where("active") }
    }
  end

  ui.tabs(tabs)
  
else

  if config.motd_public then
    local help_text = config.motd_public
    ui.container{
      attr = { class = "wiki motd" },
      content = function()
        slot.put(format.wiki_text(help_text))
      end
    }
  end

  ui.tag{ tag = "p", content = _"Closed user group, please login to participate." }

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

end

