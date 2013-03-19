slot.put_into("title", _"Admin menu")


ui.tag{ tag = "ul", content = function()
  ui.tag{ tag= "li", content = function()
    ui.link{
      text = _"Policies",
      module = "admin",
      view = "policy_list",
    }
  end }
  ui.tag{ tag= "li", content = function()
    ui.link{
      text = _"Units",
      module = "admin",
      view = "unit_list",
    }
  end }
  ui.tag{ tag= "li", content = function()
    ui.link{
      text = _"Members",
      module = "admin",
      view = "member_list",
    }
  end }
end }