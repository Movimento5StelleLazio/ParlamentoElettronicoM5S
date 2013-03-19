local area = param.get("area", "table")
local member = param.get("member", "table")

ui.container{ attr = { class = "area" }, content = function()

  execute.view{ module = "area", view = "_head", params = { area = area, hide_unit = true, show_content = true, member = member } }
  
  ui.container{ attr = { class = "content" }, content = function()
    ui.tag{ content = _"Issues:" }
    slot.put(" ")
    ui.link{ 
      module = "area", view = "show", id = area.id, params = { tab = "open", filter = "new" },
      text = _("#{count} new", { count = area.issues_new_count }) 
    }
    slot.put(" &middot; ")
    ui.link{ 
      module = "area", view = "show", id = area.id, params = { tab = "open", filter = "accepted" },
      text = _("#{count} in discussion", { count = area.issues_discussion_count }) 
    }
    slot.put(" &middot; ")
    ui.link{ 
      module = "area", view = "show", id = area.id, params = { tab = "open", filter = "half_frozen" },
      text = _("#{count} in verification", { count = area.issues_frozen_count }) 
    }
    slot.put(" &middot; ")
    ui.link{ 
      module = "area", view = "show", id = area.id, params = { tab = "open", filter = "frozen" },
      text = _("#{count} in voting", { count = area.issues_voting_count }) 
    }
    slot.put(" &middot; ")
    ui.link{ 
      module = "area", view = "show", id = area.id, params = { tab = "closed", filter = "finished" },
      text = _("#{count} finished", { count = area.issues_finished_count }) 
    }
    slot.put(" &middot; ")
    ui.link{ 
      module = "area", view = "show", id = area.id, params = { tab = "closed", filter = "canceled" },
      text = _("#{count} canceled", { count = area.issues_canceled_count }) 
    }
  end }

end }
