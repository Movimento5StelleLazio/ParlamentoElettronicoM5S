local area = param.get("area", "table")
local member = param.get("member", "table")

ui.container {
    attr = { class = "area row" },
    content = function()

        execute.view { module = "area", view = "_head", params = { area = area, hide_unit = true, show_content = true, member = member } }

        ui.container {
            attr = { class = "content text-center spaceline-bottom" },
            content = function()
                ui.tag { attr = { class = "Label label-warning" },content = _ "Issues:" }
                slot.put("<br />")
                ui.link {
                    attr = { class = "btn btn-primary large_btn margin_line text-center spaceline" },
                    module = "area",
                    view = "show",
                    id = area.id,
                    params = { tab = "open", filter = "new" },
                    text = _("#{count} new", { count = area.issues_new_count })
                }
                slot.put("")
                ui.link {
                    attr = { class = "btn btn-primary large_btn margin_line text-center spaceline spaceline-bottom" },
                    module = "area",
                    view = "show",
                    id = area.id,
                    params = { tab = "open", filter = "accepted" },
                    text = _("#{count} in discussion", { count = area.issues_discussion_count })
                }
                slot.put("")
                ui.link {
                    attr = { class = "btn btn-primary large_btn margin_line text-center spaceline spaceline-bottom" },
                    module = "area",
                    view = "show",
                    id = area.id,
                    params = { tab = "open", filter = "half_frozen" },
                    text = _("#{count} in verification", { count = area.issues_frozen_count })
                }
                slot.put("")
                ui.link {
                    attr = { class = "btn btn-primary large_btn margin_line text-center spaceline spaceline-bottom" },
                    module = "area",
                    view = "show",
                    id = area.id,
                    params = { tab = "open", filter = "frozen" },
                    text = _("#{count} in voting", { count = area.issues_voting_count })
                }
                slot.put("<br />")
                ui.link {
                    attr = { class = "btn btn-primary large_btn margin_line text-center spaceline spaceline-bottom" },
                    module = "area",
                    view = "show",
                    id = area.id,
                    params = { tab = "closed", filter = "finished" },
                    text = _("#{count} finished", { count = area.issues_finished_count })
                }
                slot.put("")
                ui.link {
                    attr = { class = "btn btn-primary large_btn margin_line text-center spaceline spaceline-bottom" },
                    module = "area",
                    view = "show",
                    id = area.id,
                    params = { tab = "closed", filter = "canceled" },
                    text = _("#{count} canceled", { count = area.issues_canceled_count })
                }
            end
        }
    end
}
