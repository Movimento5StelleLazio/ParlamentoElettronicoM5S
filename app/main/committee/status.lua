slot.set_layout("custom")

local committee_id = param.get("committee_id", atom.integer)
local report_id = param.get("report_id", atom.integer)

ui.form {
    method = "post",
    module = "committee",
    action = "request_committee",
    attr = { id = "page_status" },
    routing = {
        ok = {
            mode = "redirect",
            module = "committee",
            view = "status",
            params = { initiative_id = initiative_id, field_keywords = field_keywords }
        },
        error = {
            mode = "redirect",
            module = "committee",
            view = "status",
            params = { initiative_id = initiative_id, field_keywords = field_keywords }
        }
    },
    content = function()

        ui.container {
            attr = { class = "row paper" },
            content = function()
                ui.container {
                    attr = { class = "col-md-12" },
                    content = function()
                        ui.container {
                            content = function()
                                ui.container {
                                    attr = { class = "row" },
                                    content = function()
                                        ui.image { attr = { class = "col-md-offset-3 col-md-1" }, static = "png/committee.png" } --LOGO COMMISSIONI TECNICHE
                                        ui.container {
                                            attr = { class = "col-md-6 text-center" },
                                            content = function()
                                                ui.heading { level = 1, content = function() slot.put(_ "<strong>TECHNICAL COMMITTEE REPORT</strong>") end }
                                                if not committee_id then
                                                    ui.heading { level = 2, content = slot.put(_ "- No technical committee summoned yet for this initiative -") }
                                                else
                                                    ui.heading { level = 2, content = function() slot.put(_("Committee: <strong>C#{committee_code}</strong>", { committee_code = committee_id })) end }
                                                end
                                            end
                                        }
                                        if not committee_id then
                                            ui.container {
                                                attr = { class = "row" },
                                                content = function()
                                                    ui.image { attr = { class = "col-md-12", }, static = "svg/png/commission_step_4.png" }
                                                end
                                            }
                                        else
                                            if not report_id then
                                                ui.container {
                                                    attr = { class = "row" },
                                                    content = function()
                                                        ui.image { attr = { class = "col-md-12", }, static = "png/commission_step_5.png" }
                                                    end
                                                }
                                            else
                                                ui.container {
                                                    attr = { class = "row" },
                                                    content = function()
                                                        ui.image { attr = { class = "col-md-12", }, static = "png/commission_step_6.png" }
                                                    end
                                                }
                                            end
                                        end
                                    end
                                }
                            end
                        }
                    end
                }

                if not committee_id then
                    ui.container {
                        attr = { class = "row" },
                        content = function()
                            ui.image { attr = { class = "col-md-offset-4 col-md-1" }, static = "png/committee.png" }
                            ui.heading { level = 1, attr = { class = "col-md-5" }, content = function() slot.put(_ "Committee summoned") end }
                        end
                    }
                    ui.container {
                        attr = { class = "row" },
                        content = function()
                            ui.heading { level = 4, attr = { class = "col-md-12 text-center" }, content = function() slot.put(_("<strong>#{accepted}</strong> members over <strong>12</strong> accepted the request to be part of the committee.", { accepted = 0 })) end }
                            ui.heading { level = 6, attr = { class = "col-md-12 text-center" }, content = function() slot.put(_ "(if not enough specialists will accept the call within seven days, the committee will be formed by the permanent technical committee.)") end }
                            ui.heading { level = 3, attr = { class = "col-md-12 text-center" }, content = function() slot.put(_("REPORT DEADLINE: #{deadline}", { deadline = "99/99/2999" })) end }
                            ui.heading { level = 3, attr = { class = "col-md-12 text-left" }, content = function() slot.put(_("Technical fields:")) end }
                            ui.tag {
                                tag = "textarea",
                                id = "areas",
                                attr = { class = "col-md-12" },
                                content = "This will summarize the composition of the committee"
                            }
                            ui.heading { level = 3, attr = { class = "col-md-12 text-left" }, content = function() slot.put(_("Experts that accepted the call:")) end }
                            ui.tag {
                                tag = "textarea",
                                id = "member_list",
                                attr = { class = "col-md-12" },
                                content = "This will contain the list of members of the committee"
                            }
                        end
                    }
                else
                    if not report_id then
                        --local committee = Committee:by_id(committee_id)
                        ui.container {
                            attr = { class = "row" },
                            content = function()
                                ui.heading { attr = { class = "col-md-12" }, level = 2, content = function() slot.put(_("Committee id: <strong>C#{committee_code}</strong>", { committee_code = committee_id })) end }
                                ui.heading { attr = { class = "col-md-12" }, level = 2, content = function() slot.put(_("Summoned on: <strong>#{committee_summoned}</strong>", { committee_summoned = "00/00/0000" --[[committee.summoned]] })) end }
                                ui.heading { attr = { class = "col-md-12" }, level = 2, content = function() slot.put(_("Report deadline: <strong>#{deadline}</strong>", { deadline = "99/99/2999" --[[committee.deadline]] })) end }
                            end
                        }
                        ui.container {
                            attr = { class = "row spaceline" },
                            content = function()
                                ui.container {
                                    attr = { class = "col-md-6 col-md-offset-3 commission-in-progress text-center" },
                                    content = function()
                                        ui.heading { level = 1, content = "Committee is examining the initiative" }
                                    end
                                }
                                slot.put("<br>")
                                ui.tag {
                                    tag = "a",
                                    attr = { class = "col-md-offset-3 btn btn-primary spaceline" },
                                    content = _ "Enter the committee area (read-only)"
                                }
                            end
                        }

                        ui.container {
                            attr = { class = "row" },
                            content = function()
                                ui.heading { attr = { class = "col-md-6 col-md-offset-3 text-center" }, level = 3, content = _ "(The 12-members made committee will examin the initiative and it will publish a report within seven days. Initiative will be frozen in the meantime.)" }
                                ui.heading { level = 3, attr = { class = "col-md-12 text-left" }, content = function() slot.put(_("Technical fields:")) end }
                                ui.tag {
                                    tag = "textarea",
                                    id = "areas",
                                    attr = { class = "col-md-12" },
                                    content = "This will summarize the composition of the committee"
                                }
                                ui.heading { level = 3, attr = { class = "col-md-12 text-left" }, content = function() slot.put(_("Members of the panel:")) end }
                                ui.tag {
                                    tag = "textarea",
                                    id = "member_list",
                                    attr = { class = "col-md-12" },
                                    content = "This will contain the list of members of the committee"
                                }
                            end
                        }
                    else
                        --local committee = Committee:by_id(committee_id)
                        ui.container {
                            attr = { class = "row" },
                            content = function()
                                ui.heading { attr = { class = "col-md-12" }, level = 2, content = function() slot.put(_("Committee id: <strong>C#{committee_code}</strong>", { committee_code = committee_id })) end }
                                ui.heading { attr = { class = "col-md-12" }, level = 2, content = function() slot.put(_("Summoned on: <strong>#{committee_summoned}</strong>", { committee_summoned = "00/00/0000" --[[committee.summoned]] })) end }
                                ui.heading { attr = { class = "col-md-12" }, level = 2, content = function() slot.put(_("Report published on: <strong>#{deadline}</strong>", { deadline = "99/99/2999" --[[committee.deadline]] })) end }
                            end
                        }
                        ui.container {
                            attr = { class = "row spaceline" },
                            content = function()
                                ui.container {
                                    attr = { class = "col-md-6 col-md-offset-3 commission-in-progress text-center" },
                                    content = function()
                                    --						if committee.approve then
                                        ui.heading { attr = { class = "committee-box-approved" }, level = 1, content = "Committee APPROVED" }
                                    --						else
                                    --							ui.heading{attr={class="committee-box-disapproved"},level=1, content="Committee DISAPPROVED"}
                                    --						end
                                    end
                                }
                            end
                        }
                        ui.container {
                            attr = { class = "row spaceline" },
                            content = function()
                                ui.heading { level = 3, attr = { class = "col-md-12 text-left" }, content = function() slot.put(_("Technical fields:")) end }
                                ui.tag {
                                    tag = "textarea",
                                    id = "areas",
                                    attr = { class = "col-md-12" },
                                    content = "This will summarize the composition of the committee"
                                }
                                ui.heading { level = 3, attr = { class = "col-md-12 text-left" }, content = function() slot.put(_("Members of the panel <strong>C#{committee_code}</strong>:", { committee_code = committee_id })) end }
                                ui.tag {
                                    tag = "textarea",
                                    id = "member_list",
                                    attr = { class = "col-md-12" },
                                    content = "This will contain the list of members of the committee"
                                }
                                ui.heading { level = 3, attr = { class = "col-md-12 text-left" }, content = function() slot.put(_("Report code: <strong>R#{report_code}</strong>", { report_code = report_id })) end }
                                ui.tag {
                                    tag = "textarea",
                                    id = "report",
                                    attr = { class = "col-md-12" },
                                    content = "This will contain the report text"
                                }
                            end
                        }
                    end
                end
            end
        }
    end
}
