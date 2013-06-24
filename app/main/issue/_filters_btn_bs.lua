local id = param.get_id() or nil
local state = param.get("state")
local orderby = param.get("orderby")
local desc = param.get("desc",atom.boolean)
local interest = param.get("interest") 
local scope = param.get("scope") 
local btns = param.get("btns","table")
local ftl_btns = param.get("ftl_btns",atom.boolean)

local module = request.get_module()
local view = request.get_view()

local color

-- Default state and interest, used when filters are closed with REMOVE FILTERS btn
local default_state =  btns.default_state or 'any'
local default_interest =  btns.default_interest or 'any'
local default_scope =  btns.default_scope or 'all_units'

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
    open = _"Open",
    closed = _"Closed",
    any = _"Any phase",
    development = _"Development",
    admission = _"New",
    discussion = _"Discussion",
    verification = _"Frozen",
    voting = _"Voting",
    committee = _"Committee",
    canceled = _"Canceled",
    finished = _"Finished",
    finished_with_winner = _"Finished (with winner)",
    finished_without_winner = _"Finished (without winner)"
  },
  interest = {
    any = _"Any category",
    interested = _"Interested",
    initiated = _"Initiated",
    not_interested = _"Not interested",
    supported = _"Supported",
    potentially_supported = _"Potentially supported",
    voted = _"Voted",
    not_voted = _"Not voted"
  },
  scope = {
    all_units = _"All units",
    my_units = _"My units",
    my_areas = _"My areas",
    citizens = _"Citizens units",
    electeds = _"Elected units",
    others = _"Other political groups units"
  }
}

local display_flt="none"
local display_btn="block"
if ftl_btns then
  display_flt="block"
  display_btn="none"
end

trace.debug("id:"..(id or "none")..", state:"..(state or "none")..", interest:"..(interest or "none")..", scope:"..(scope or "none")..", orderby:"..(orderby or "none") )  

ui.container{ attr = { class = "row-fluid btn_box_bottom"}, content = function()
  ui.container{ attr = { class = "span12 text-center"}, content = function()

      ui.container{ attr = { id = "btn_apply_row", class = "row-fluid", style="display:"..display_btn}, content = function()
        ui.container{ attr = { class = "span12 text-center"}, content = function()
          ui.tag { 
            tag = "a",
            attr = { 
              id = "btn_apply", 
              href = "#",
              class = "btn btn-primary btn-large",
              onclick="toggle_flt()"
            },
            content = function()
              ui.heading{ level=4, content = _"APPLY FILTERS"  }
            end
          }
        end }
      end }

      ui.container{ attr = { id = "btn_delete_row", class = "row-fluid", style="display:"..display_flt}, content = function()
        ui.container{ attr = { class = "span12 text-center"}, content = function()
          ui.link {
            attr = { id = "btn_delete", class = "btn btn-primary active btn-large"},
            module = module, view = view, id = id or nil,
            params = { 
              state = default_state, 
              orderby = orderby, 
              desc = desc, 
              interest = default_interest, 
              scope = default_scope, 
              ftl_btns = false 
            },
            content = function()
              ui.heading{ level=4, content = _"REMOVE FILTERS"  }
            end
          }
        end }
      end }

    if btns['state'] then
      ui.container{ attr = { id = "state_flt", class = "row-fluid", style="display:"..display_flt}, content = function()
        ui.container{ attr = { class = "span12 text-center"}, content = function()
          ui.container{ attr = { class = "row-fluid"}, content = function()
            ui.container{ attr = { class = "span12 text-center"}, content = function()
              ui.heading{ level=3, content = _"FILTER INITIATIVES SHOWING ONLY THOSE IN PHASE:"  }
            end } 
          end } 
          ui.container{ attr = { class = "row-fluid"}, content = function()
            ui.container{ attr = { class = "span12 text-center"}, content = function()
              trace.debug("btns.state:")
              for i=1, #btns.state do
                trace.debug(btns.state[i]..",")
                if state == btns.state[i] then color = " active" else color = "" end
                ui.link {
                  attr = { id = "flt_btn_"..btns.state[i], class = "filter_btn btn btn-primary btn-small"..color},
                  module = module, view = view, id = id or nil, 
                  params = { state = btns.state[i], orderby = orderby, desc = desc, interest = interest, scope=scope, ftl_btns = true },
                  content = function()
                    ui.heading{level=5,content= txt_map.state[btns.state[i]] }
                  end
                }
              end
            end } 
          end } 
        end } 
      end } 
    end
    if btns['interest'] then
      ui.container{ attr = { id = "interest_flt", class = "row-fluid", style="display:"..display_flt}, content = function()
        ui.container{ attr = { class = "span12 text-center"}, content = function()
          ui.container{ attr = { class = "row-fluid"}, content = function()
            ui.container{ attr = { class = "span12 text-center"}, content = function()
              ui.heading{ level=3, content = _"FILTER INITIATIVES SHOWING ONLY THOSE IN CATEGORY:"  }
            end } 
          end } 
          ui.container{ attr = { class = "row-fluid"}, content = function()
            ui.container{ attr = { class = "span12 text-center"}, content = function()
              trace.debug("btns.interest:")
              for i=1, #btns.interest do
                trace.debug(btns.interest[i]..",")
                if interest == btns.interest[i] then color = " active" else color = "" end
                ui.link {
                  attr = { id = "flt_btn_"..btns.interest[i], class = "filter_btn btn btn-primary btn-small"..color},
                  module = module, view = view, id = id,
                  params = { state = state, orderby = orderby, desc = desc, interest =  btns.interest[i], scope=scope, ftl_btns = true },
                  content = function()
                    ui.heading{level=5,content= txt_map.interest[btns.interest[i]] }
                  end
                }
              end
            end } 
          end } 
        end } 
      end } 
    end
    if btns['scope'] then
      ui.container{ attr = { id = "scope_flt", class = "row-fluid", style="display:"..display_flt}, content = function()
        ui.container{ attr = { class = "span12 text-center"}, content = function()
          ui.container{ attr = { class = "row-fluid"}, content = function()
            ui.container{ attr = { class = "span12 text-center"}, content = function()
              ui.heading{ level=3, content = _"SHOW ONLY THE FOLLOWING UNITS:"  }
            end } 
          end } 
          ui.container{ attr = { class = "row-fluid"}, content = function()
            ui.container{ attr = { class = "span12 text-center"}, content = function()
              trace.debug("btns.scope:")
              for i=1, #btns.scope do
                trace.debug(btns.scope[i]..",")
                if scope == btns.scope[i] then color = " active" else color = "" end
                ui.link {
                  attr = { id = "flt_btn_"..btns.scope[i], class = "filter_btn btn btn-primary btn-small"..color},
                  module = module, view = view, id = id,
                  params = { state = state, orderby = orderby, desc = desc, interest = interest, scope = btns.scope[i], ftl_btns = true },
                  content = function()
                    ui.heading{level=5,content= txt_map.scope[btns.scope[i]] }
                  end
                }
              end
            end }
          end }
        end } 
      end } 
    end
  end }
end }
ui.script{static="js/toggle_flt.js"}
