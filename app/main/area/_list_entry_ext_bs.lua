local area = param.get("area", "table")
local member = param.get("member", "table")

ui.container{ attr = { class = "row-fluid" }, content = function()
  
  ui.link{  
      module = "area", view = "filters_bs", id = area.id,
      attr = { class = "btn btn-primary btn-large span2" }, content = function()
        ui.tag{ tag ="i" , attr = { class = "iconic black magnifying-glass pull-left" }, content=""}       
        slot.put("&nbsp;".._"AREA "..area.id)
      end
    }

  ui.container{ attr = { class = "span10 alert alert-simple" }, content = function()
    execute.view{ module = "area", view = "_head_ext_bs", params = { area = area, hide_unit = true, show_content = true, member = member } }
    ui.tag{ content = _"Issues:" }
    slot.put(" ")
    ui.link{ 
      module = "area", view = "show_ext_bs", id = area.id, params = { state = "admission" },
      text = _("#{count} new", { count = area.issues_new_count }) 
    }
    slot.put(" &middot; ")
    ui.link{ 
      module = "area", view = "show_ext_bs", id = area.id, params = { state = "discussion" },
      text = _("#{count} in discussion", { count = area.issues_discussion_count }) 
    }
    slot.put(" &middot; ")
    ui.link{ 
      module = "area", view = "show_ext_bs", id = area.id, params = { state = "verification" },
      text = _("#{count} in verification", { count = area.issues_frozen_count }) 
    }
    slot.put(" &middot; ")
    ui.link{ 
      module = "area", view = "show_ext_bs", id = area.id, params = { state = "voting" },
      text = _("#{count} in voting", { count = area.issues_voting_count }) 
    }
    slot.put(" &middot; ")
    ui.link{ 
      module = "area", view = "show_ext_bs", id = area.id, params = { state = "finished" },
      text = _("#{count} finished", { count = area.issues_finished_count }) 
    }
    slot.put(" &middot; ")
    ui.link{ 
      module = "area", view = "show_ext_bs", id = area.id, params = { state = "canceled" },
      text = _("#{count} canceled", { count = area.issues_canceled_count }) 
    }
  end }

end }
