local area = param.get("area", "table")
local member = param.get("member", "table")
trace.debug("view: _list_entry_ext_bs.lua")

ui.container {
    attr = { class = "row" },
    content = function()
        ui.container {
            attr = { class = "col-md-12 well-inside" },
            content = function()
                ui.container {
                    attr = { class = "row" },
                    content = function()
                        ui.container {
                            attr = { class = "col-md-2" },
                            content = function()
                                ui.link {
                                    module = "wizard_private",
                                    view = "page_bs1",
                                    params = { area_id = area.id, unit_id = area.unit_id, area_name = area.name, unit_name = Unit:by_id(area.unit_id).name },
                                    attr = { class = "btn btn-primary btn-large btn_margin" },
                                    content = function()
                                        ui.heading { level = 5, content = _ "AREA " .. area.id }
                                    end
                                }
                            end
                        }
                        ui.container {
                            attr = { class = "col-md-10" },
                            content = function()
                                execute.view { module = "wizard_private", view = "_head_ext_bs", params = { area = area, hide_unit = true, show_content = true, member = member } }
                                ui.tag { content = _ "Issues:" }
                                slot.put(" ")
                                ui.link {
                                    module = "area_private",
                                    view = "show_ext_bs",
                                    id = area.id,
                                    params = { state = "admission" },
                                    text = _("#{count} new", { count = area.issues_new_count })
                                }
                                slot.put(" &middot; ")
                                ui.link {
                                    module = "area_private",
                                    view = "show_ext_bs",
                                    id = area.id,
                                    params = { state = "discussion" },
                                    text = _("#{count} in discussion", { count = area.issues_discussion_count })
                                }
                                slot.put(" &middot; ")
                                ui.link {
                                    module = "area_private",
                                    view = "show_ext_bs",
                                    id = area.id,
                                    params = { state = "verification" },
                                    text = _("#{count} in verification", { count = area.issues_frozen_count })
                                }
                                slot.put(" &middot; ")
                                ui.link {
                                    module = "area_private",
                                    view = "show_ext_bs",
                                    id = area.id,
                                    params = { state = "voting" },
                                    text = _("#{count} in voting", { count = area.issues_voting_count })
                                }
                                slot.put(" &middot; ")
                                ui.link {
                                    module = "area_private",
                                    view = "show_ext_bs",
                                    id = area.id,
                                    params = { state = "finished" },
                                    text = _("#{count} finished", { count = area.issues_finished_count })
                                }
                                slot.put(" &middot; ")
                                ui.link {
                                    module = "area_private",
                                    view = "show_ext_bs",
                                    id = area.id,
                                    params = { state = "canceled" },
                                    text = _("#{count} canceled", { count = area.issues_canceled_count })
                                }
                            end
                        }
                    end
                }
            end
        }
    end
}
