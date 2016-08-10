local id = param.get_id() or nil
local state = param.get("state")
local orderby = param.get("orderby")
local desc = param.get("desc", atom.boolean)
local interest = param.get("interest")
local scope = param.get("scope")
local btns = param.get("btns", "table") or {}
local ftl_btns = param.get("ftl_btns", atom.boolean)

local module = request.get_module()
local view = request.get_view()

local color

-- Default state and interest, used when filters are closed with REMOVE FILTERS btn
local default_state = btns.default_state or 'any'
local default_interest = btns.default_interest or 'any'
local default_scope = btns.default_scope or 'all_units'

-- You must pass the following table in order to enable buttons
--[[
local btns = {
  default_state = 'any',
  state = {
    "any",
    "open",
    "development",
    "admission",
    "discussion",
    "voting",
    "verification",
    "canceled",
    "committee",
    "finished",
    "finished_with_winner",
    "finished_without_winner",
    "closed"
  },
  default_interest = 'any',
  interest = {
    "any",
    "interested",
    "not_interested",
    "initiated",
    "supported",
    "potentially_supported",
    "voted",
    "not_voted"
  }
  scope = {
    "all_units",
    "my_units",
    "my_areas"
    "citizens",
    "electeds",
    "others"
  }
}
--]]


-- Filter buttons text mapping
local txt_map = {
    state = {
        open = _ "Open",
        closed = _ "Closed",
        any = _ "Any phase",
        development = _ "Development",
        admission = _ "New",
        discussion = _ "Discussion",
        verification = _ "Frozen",
        voting = _ "Voting",
        committee = _ "Committee",
        canceled = _ "Canceled",
        finished = _ "Finished",
        finished_with_winner = _ "Finished (with winner)",
        finished_without_winner = _ "Finished (without winner)"
    },
    interest = {
        any = _ "Any category",
        interested = _ "Interested",
        initiated = _ "Initiated",
        not_interested = _ "Not interested",
        supported = _ "Supported",
        potentially_supported = _ "Potentially supported",
        voted = _ "Voted",
        not_voted = _ "Not voted"
    },
    scope = {
        all_units = _ "All units",
        my_units = _ "My units",
        my_areas = _ "My areas",
        citizens = _ "Citizens units",
        electeds = _ "Elected units",
        others = _ "Other political groups units"
    }
}

local collapse = ""
if ftl_btns then
    collapse = " in"
end

trace.debug("id:" .. (id or "none") .. ", state:" .. (state or "none") .. ", interest:" .. (interest or "none") .. ", scope:" .. (scope or "none") .. ", orderby:" .. (orderby or "none"))
trace.debug("default interest:" .. (btns.default_interest or "none"))

ui.container {
    attr = { id = "contenitore", class = "panel-group" },
    content = function()
        ui.container {
            attr = { class = "panel panel-default" },
            content = function()
                ui.container {
                    attr = { class = "row" },
                    content = function()
                        ui.container {
                            attr = { class = "panel-heading col-md-12 text-center" },
                            content = function()
                                ui.tag {
                                    tag = "button",
                                    attr = { datatoggle = "collapse", dataparent = "#contenitore", href = "#filtri", class = "accordion-toggle btn btn-primary" },
                                    content = _ "APPLY FILTERS"
                                }
                            end
                        }
                    end
                }
                ui.container {
                    attr = { id = "filtri", class = "panel-collapse collapse" .. collapse },
                    content = function()
                        ui.container {
                            attr = { class = "row" },
                            content = function()
                                ui.container {
                                    attr = { class = "col-md-12 text-center" },
                                    content = function()
                                        if btns['state'] then
                                            ui.container {
                                                attr = { id = "state_flt", class = "row spaceline" },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "col-md-12 text-center" },
                                                        content = function()
                                                            ui.container {
                                                                attr = { class = "row" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { class = "col-md-12 text-center" },
                                                                        content = function()
                                                                            ui.heading { level = 3, content = _ "FILTER INITIATIVES SHOWING ONLY THOSE IN PHASE:" }
                                                                        end
                                                                    }
                                                                end
                                                            }
                                                            ui.container {
                                                                attr = { class = "row" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { class = "col-md-12 text-center" },
                                                                        content = function()
                                                                            for i = 1, #btns.state do
                                                                                ui.container {
                                                                                    attr = { class = "row" },
                                                                                    content = function()
                                                                                        ui.container {
                                                                                            attr = { class = "col-md-12 text-center" },
                                                                                            content = function()
                                                                                                ui.container {
                                                                                                    attr = { class = "btn-group" },
                                                                                                    content = function()
                                                                                                        for j = 1, #btns.state[i] do
                                                                                                            if state == btns.state[i][j] then
                                                                                                                color = " active"
                                                                                                            else
                                                                                                                color = ""
                                                                                                            end
                                                                                                            ui.link {
                                                                                                                attr = { id = "flt_btn_" .. btns.state[i][j], class = "filter_btn btn btn-primary btn-small fixclick" .. color },
                                                                                                                module = module,
                                                                                                                view = view,
                                                                                                                id = id or nil,
                                                                                                                params = { state = btns.state[i][j], orderby = orderby, desc = desc, interest = interest, scope = scope, ftl_btns = true },
                                                                                                                content = function()
                                                                                                                    ui.heading { level = 5, content = txt_map.state[btns.state[i][j]] }
                                                                                                                end
                                                                                                            }
                                                                                                        end
                                                                                                    end
                                                                                                }
                                                                                            end
                                                                                        }
                                                                                    end
                                                                                }
                                                                            end
                                                                        end
                                                                    }
                                                                end
                                                            }
                                                        end
                                                    }
                                                end
                                            }
                                        end

                                        if btns['interest'] then
                                            ui.container {
                                                attr = { id = "interest_flt", class = "row spaceline" },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "col-md-12 text-center" },
                                                        content = function()
                                                            ui.container {
                                                                attr = { class = "row" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { class = "col-md-12 text-center" },
                                                                        content = function()
                                                                            ui.heading { level = 3, content = _ "FILTER INITIATIVES SHOWING ONLY THOSE IN CATEGORY:" }
                                                                        end
                                                                    }
                                                                end
                                                            }
                                                            ui.container {
                                                                attr = { class = "row" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { class = "col-md-12 text-center" },
                                                                        content = function()
                                                                            for i = 1, #btns.interest do
                                                                                ui.container {
                                                                                    attr = { class = "row" },
                                                                                    content = function()
                                                                                        ui.container {
                                                                                            attr = { class = "col-md-12 text-center" },
                                                                                            content = function()
                                                                                                ui.container {
                                                                                                    attr = { class = "btn-group" },
                                                                                                    content = function()
                                                                                                        for j = 1, #btns.interest[i] do
                                                                                                            if interest == btns.interest[i][j] then color = " active" else color = "" end
                                                                                                            ui.link {
                                                                                                                attr = { id = "flt_btn_" .. btns.interest[i][j], class = "filter_btn btn btn-primary btn-small fixclick" .. color },
                                                                                                                module = module,
                                                                                                                view = view,
                                                                                                                id = id or nil,
                                                                                                                params = { state = state, orderby = orderby, desc = desc, interest = btns.interest[i][j], scope = scope, ftl_btns = true },
                                                                                                                content = function()
                                                                                                                    ui.heading { level = 5, content = txt_map.interest[btns.interest[i][j]] }
                                                                                                                end
                                                                                                            }
                                                                                                        end
                                                                                                    end
                                                                                                }
                                                                                            end
                                                                                        }
                                                                                    end
                                                                                }
                                                                            end
                                                                        end
                                                                    }
                                                                end
                                                            }
                                                        end
                                                    }
                                                end
                                            }
                                        end

                                        if btns['scope'] then
                                            ui.container {
                                                attr = { id = "scope_flt", class = "row spaceline" },
                                                content = function()
                                                    ui.container {
                                                        attr = { class = "col-md-12 text-center" },
                                                        content = function()
                                                            ui.container {
                                                                attr = { class = "row" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { class = "col-md-12 text-center" },
                                                                        content = function()
                                                                            ui.heading { level = 3, content = _ "SHOW ONLY THE FOLLOWING UNITS:" }
                                                                        end
                                                                    }
                                                                end
                                                            }
                                                            ui.container {
                                                                attr = { class = "row" },
                                                                content = function()
                                                                    ui.container {
                                                                        attr = { class = "col-md-12 text-center" },
                                                                        content = function()
                                                                            for i = 1, #btns.scope do
                                                                                ui.container {
                                                                                    attr = { class = "row" },
                                                                                    content = function()
                                                                                        ui.container {
                                                                                            attr = { class = "col-md-12 text-center" },
                                                                                            content = function()
                                                                                                ui.container {
                                                                                                    attr = { class = "btn-group" },
                                                                                                    content = function()
                                                                                                        for j = 1, #btns.scope[i] do
                                                                                                            if scope == btns.scope[i][j] then color = " active" else color = "" end
                                                                                                            ui.link {
                                                                                                                attr = { id = "flt_btn_" .. btns.scope[i][j], class = "filter_btn btn btn-primary btn-small fixclick" .. color },
                                                                                                                module = module,
                                                                                                                view = view,
                                                                                                                id = id or nil,
                                                                                                                params = { state = state, orderby = orderby, desc = desc, interest = interest, scope = btns.scope[i][j], ftl_btns = true },
                                                                                                                content = function()
                                                                                                                    ui.heading { level = 5, content = txt_map.scope[btns.scope[i][j]] }
                                                                                                                end
                                                                                                            }
                                                                                                        end
                                                                                                    end
                                                                                                }
                                                                                            end
                                                                                        }
                                                                                    end
                                                                                }
                                                                            end
                                                                        end
                                                                    }
                                                                end
                                                            }
                                                        end
                                                    }
                                                end
                                            }
                                        end
                                    end
                                }
                            end
                        }
                    end
                }
            end
        }
    end
}
