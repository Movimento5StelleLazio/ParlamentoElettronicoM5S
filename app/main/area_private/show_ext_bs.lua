slot.set_layout("custom")

local create = param.get("create", atom.boolean) or false
local area = Area:by_id(param.get_id())
local state = param.get("state") or "any"
local scope = param.get("scope") or "all_units"
local orderby = param.get("orderby") or "creation_date"
local desc = param.get("desc",atom.boolean) or false
local interest = param.get("interest") or "any"
local member = app.session.member
local ftl_btns = param.get("ftl_btns",atom.boolean) or false

app.html_title.title = area.name
app.html_title.subtitle = _("Area")

util.help("area.show")

-- Determines the desc order button text
local inv_txt
if not desc then
  inv_txt = _"INVERT ORDER FROM ASCENDING TO DESCENDING"
else
  inv_txt = _"INVERT ORDER FROM DESCENDING TO ASCENDING"
end

local selector = area:get_reference_selector("issues")
  
execute.chunk{
  module    = "issue_private",
  chunk     = "_filters_ext",
  params    = { 
    state=state, 
    orderby=orderby, 
    desc=desc,
    interest=interest,
    selector=selector
  }
}

-- Category, used for routing
local category

-- This holds issue-oriented description text for shown issues
local issues_desc

if state == "admission" then
  issues_desc = _"Citizens Initiatives Looking For Supporters" or Issue:get_state_name_for_state('admission')
elseif state == "development" then
  issues_desc = _"M5S Members Initiatives In Discussion" or _"Development"
elseif state == "discussion" then
  issues_desc = _"M5S Members Initiatives In Discussion" or Issue:get_state_name_for_state('discussion')
elseif state == "voting" then
  issues_desc = _"M5S Members Initiatives In Discussion" or Issue:get_state_name_for_state('voting')
elseif state == "verification" then
  issues_desc = _"M5S Members Initiatives In Discussion" or Issue:get_state_name_for_state('verification')
elseif state == "committee" then
  issues_desc = _"M5S Members Initiatives In Discussion" or _"Committee"
elseif state == "closed" then
  issues_desc = _"M5S Members Initiatives Completed or Retired" or _"Closed"
elseif state == "canceled" then
  issues_desc = _"M5S Members Initiatives Completed or Retired" or _"Canceled"
elseif state == "finished" then
  issues_desc = _"M5S Members Initiatives Completed or Retired" or _"Finished"
elseif state == "finished_with_winner" then
  issues_desc = _"M5S Members Initiatives Completed or Retired" or _"Finished (with winner)"
elseif state == "finished_without_winner" then
  issues_desc = _"M5S Members Initiatives Completed or Retired" or _"Finished (without winner)"
elseif state == "open" then
  issues_desc = _"Open"
elseif state == "any" then
  issues_desc = _"Any"
else
  issues_desc = _"Unknown"
end

ui.container{ attr = { class  = "row-fluid" } , content = function()
  ui.container{ attr = { class  = "well span12" }, content = function()
    ui.container{ attr = { class  = "row-fluid spaceline3" }, content = function()
      ui.container{ attr = { class  = "span3" }, content = function()
        ui.link{
          attr = { class="btn btn-primary btn-large large_btn fixclick"  },
          module = "area_private",
          id = area.id,
          view = "filters_bs",
		  params = { create = create },
          content = function()
            ui.heading{level=3,content=function()
              ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
              slot.put(_"Back to previous page")
            end }
          end
        }
      end }
      ui.container{ attr = { class  = "span9" }, content = function()
        ui.container{ attr = { class  = "row-fluid" }, content = function()
          ui.container{ attr = { class  = "span12 text-center" }, content = function()
             ui.heading{level=1,attr={class="fittext0"},content=_("#{realname}, you are now in the Regione Lazio Internal Assembly", {realname = (member.realname ~= "" and member.realname or member.login)}) }
          end }
        end }
        ui.container{ attr = { class  = "row-fluid" }, content = function()
          ui.container{ attr = { class  = "span12 text-center" }, content = function()
             ui.heading{level=2,attr={class="fittext0"},content=_"CHOOSE THE INITIATIVE TO EXAMINE:" }
          end }
        end }
      end }
    end }
  end }
end }

if state == "development" or state == "verification" or state == "discussion" or state == "voting" or state == "committee" then
  btns = {
    default_state = 'development',
    state = { {"discussion", "verification", "voting", "committee"} },
    default_interest = 'any',
    interest = { {"any", "not_interested", "interested", "initiated"}, {"supported", "potentially_supported", "voted"} }
  }
elseif state == "closed" or state == "canceled" or state == "finished" then
  btns = {
    default_state = 'closed',
    default_interest = 'any',
    interest = { {"any", "not_interested", "interested", "initiated"}, {"supported", "potentially_supported", "voted"} }
  }
elseif state == "admission" then  
  btns = {
    default_state = 'admission',
    default_interest = 'any',
    interest = { {"any", "not_interested", "interested", "initiated"}, {"supported", "potentially_supported", "voted"} }
  }
end

execute.chunk{
  module = "issue_private" ,
  chunk = "_filters_btn2_bs" ,
  id = area.id,
  params = {
    state = state,
    orderby = orderby,
    desc = desc,
    interest = interest,
    btns = btns,
    ftl_btns = ftl_btns
  }
}

ui.container{ attr = { class="row-fluid text-center"}, content=function()
  ui.container{ attr = { class="span12 text-center"}, content=function()
    ui.image{ attr = { id = "parlamento_img" }, static = "parlamento_icon_small.png" }
  end }
end }

ui.container{ attr = { class="row-fluid"}, content=function()
ui.container{ attr = { class="span12 well"}, content=function()
    ui.container{ attr = { class="row-fluid"}, content=function()
      ui.container{ attr = { class="span12 text-center"}, content=function()
        ui.heading{level=3,content=_(issues_desc) or "Initiatives:" }
      end }
    end }
    ui.container{ attr = { class="row-fluid spaceline"}, content=function()
      ui.container{ attr = { class="span12 text-center btn-group"}, content=function()
          local btna,btnb,btnc,btnd = "", "", "", ""
          if orderby == "supporters" then
            btna = " active"
          elseif orderby == "creation_date" then
            btnb = " active"
          elseif orderby == "event" then
            btnc = " active"
          end
          if desc then
            btnd = " active"
          end
           
--          local btn_style = "width:25%;"
		  if not app.session.member.elected then
--            btn_style = "width:25%;"
            ui.link {
              attr = { class="btn btn-primary fixclick"..btna, style=btn_style },
              module = "area_private",
              view = "show_ext_bs",
              id = area.id,
              params = { state=state, orderby="supporters", interest=interest, desc=desc, ftl_btns=ftl_btns},
              content = function()
                ui.heading { level=4, content = _"ORDER BY NUMBER OF SUPPORTERS" }
              end
            }
          end
          ui.link {
            attr = { class="btn btn-primary fixclick"..btnb, style=btn_style },
            module = "area_private",
            view = "show_ext_bs",
            id = area.id,
            params = { state=state, orderby="creation_date", interest=interest, desc=desc, ftl_btns=ftl_btns },
            content = function()
              ui.heading { level=4, content = _"ORDER BY DATE OF CREATION" }
            end
          }
          ui.link {
            attr = { class="btn btn-primary fixclick"..btnc, style=btn_style },
            module = "area_private",
            view = "show_ext_bs",
            id = area.id,
            params = { state=state, orderby="event", interest=interest, desc=desc, ftl_btns=ftl_btns},
            content = function()
              ui.heading { level=4, content = _"ORDER BY LAST EVENT DATE"  }
            end
          }
          ui.link {
            attr = { class="btn btn-primary fixclick"..btnd, style=btn_style },
            module = "area_private",
            view = "show_ext_bs",
            id = area.id,
            params = { state=state, orderby=orderby, interest=interest, desc=not(desc), ftl_btns=ftl_btns},
            content = function()
              ui.heading { level=4, content = inv_txt  }
            end
          }
        end }
    end }

      ui.container{ attr = { id="issues_box", class="row-fluid spaceline"}, content=function()
        execute.view{
          module="issue_private" ,
          view="_list_ext2_bs",
          params={
            state=state,
            orderby=orderby,
            desc=desc,
            interest=interest,
            scope=scope,
            ftl_btns=ftl_btns,
            selector=selector, 
            view="area",
            member=member 
          }
        }
      end }
      end }
end }
