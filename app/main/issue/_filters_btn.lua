local id = param.get_id()
local state = param.get("state")
local orderby = param.get("orderby")
local desc = param.get("desc",atom.boolean)
local interest = param.get("interest")
local btns = param.get("btns","table")

local module = request.get_module()
local view = request.get_view()

local color

ui.container{ attr = { id = "", class = ""}, content = function()
  
--  ui.container{ attr = { id = "", class = ""}, content = function()
    ui.link {
      attr = { id = "flt_btn_apply", class = "button orange"},
      content = _"APPLY FILTERS"
    }
--  end }

  ui.container{  attr = { id = "flt_box", class = "", style="height: 300px;"}, content = function()
    
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
            interest = interest
          },
          content = btns.state[i]
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
            interest =  btns.interest[i]
          },
          content = btns.interest[i]
        }
      end
    end } 

  end }

end }
