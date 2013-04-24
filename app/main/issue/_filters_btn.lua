local id = param.get_id()
local state = param.get("state")
local orderby = param.get("orderby")
local desc = param.get("desc",atom.boolean)
local interest = param.get("interest")
local btns = param.get("btns","table")
local ftl_btns = param.get("ftl_btns",atom.boolean) or false

local module = request.get_module()
local view = request.get_view()

local color

-- Default state and interest, used when filters are closed with REMOVE FILTERS btn
local default_state =  btns.default_state
local default_interest =  btns.default_interest

-- Display filters button depending on flt_btns flag
if ftl_btns then
  d1 = "none"
  d2 = "block"
else
  d1 = "block"
  d2 = "none"
end

-- Filter buttons text mapping

local txt_map = {
  state = {
    open = _"Open",
    closed = _"Closed",
    any = _"Any phase",
    development = _"Development",
    admission = _"New",
    voting = _"Voting",
    verification = _"Frozen",
    canceled = _"Canceled",
    finished = _"Finished",
    finished_with_winner = _"Finished (with winner)",
    finished_without_winner = _"Finished (without winner)",
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
  }
}

ui.container{ attr = { id = "", class = ""}, content = function()
  
    ui.tag {
      tag = "a",
      attr = { 
        id = "flt_btn_apply", 
        class = "button orange",
        style = "display: "..d1..";",
        onclick = "document.getElementById('flt_box').style.display='block';"
          .."document.getElementById('flt_btn_apply').style.display='none';"
      },
      content = _"APPLY FILTERS"
    }

  ui.container{  attr = { id = "flt_box", class = "", style="display: "..d2..";"}, content = function()
    ui.link {
      attr = { id = "flt_btn_delete", class = "button orange"},
      module = module,
      view = view,
      id = id,
      params = {
        state = default_state,
        orderby = orderby,
        desc = desc,
        interest = default_interest,
        ftl_btns = false
      },
      content = _"REMOVE FILTERS"
    }
    
    ui.container{  attr = { class = "flt_btn_box"}, content = function()
       
      ui.heading{ attr = { class = "flt_btn_head_title"}, level=2, content = _"FILTER INITIATIVES SHOWING ONLY THOSE IN PHASE:"  }
      for i=1, #btns.state do
        if state == btns.state[i] then color = "green" else color = "orange" end
        ui.link {
          attr = { id = "flt_btn_"..btns.state[i], class = "button "..color.." flt_btn_txt"},
          module = module,
          view = view,
          id = id,
          params = {
            state = btns.state[i],
            orderby = orderby,
            desc = desc,
            interest = interest,
            ftl_btns = true
          },
          content = txt_map.state[btns.state[i]]
        }
      end
    end } 

    ui.container{  attr = { class = "flt_btn_box"}, content = function()

      ui.heading{ attr = { class = "flt_btn_head_title"}, level=2, content = _"FILTER INITIATIVES SHOWING ONLY THOSE IN CATEGORY:"  }
      for i=1, #btns.interest do
        if interest == btns.interest[i] then color = "green" else color = "orange" end
        ui.link {
          attr = { id = "flt_btn_"..btns.interest[i], class = "button "..color.." flt_btn_txt"},
          module = module,
          view = view,
          id = id,
          params = {
            state = state,
            orderby = orderby,
            desc = desc,
            interest =  btns.interest[i],
            ftl_btns = true
          },
          content = txt_map.interest[btns.interest[i]]
        }
      end
    end } 

  end }

end }
