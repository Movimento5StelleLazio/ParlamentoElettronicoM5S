slot.set_layout("m5s_bs")
local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1] or 'default'

local area = Area:by_id(param.get_id())
local state = param.get("state")
local scope = param.get("scope")
local orderby = param.get("orderby")
local desc = param.get("desc",atom.boolean) or false
local interest = param.get("interest")
local member = app.session.member
local ftl_btns = param.get("ftl_btns",atom.boolean) or false

app.html_title.title = area.name
app.html_title.subtitle = _("Area")

util.help("area.show")

-- Get the unit name from the configuration file
local unit_name
for i,v in pairs(config.gui_preset[gui_preset].units) do
  if config.gui_preset[gui_preset].units[i].unit_id == area.unit_id then unit_name = i end
end

if not config.gui_preset[gui_preset].units[unit_name] then
  slot.put_into("error", "unit_id for selected area is not configured in config.gui_preset")
  return false
end

-- Determines the desc order button text
local inv_txt
if not desc then
  inv_txt = _"INVERT ORDER FROM ASCENDING TO DESCENDING"
else
  inv_txt = _"INVERT ORDER FROM DESCENDING TO ASCENDING"
end

local selector = area:get_reference_selector("issues")
  
execute.chunk{
  module    = "issue",
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
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_admission or Issue:get_state_name_for_state('admission')
elseif state == "development" then
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_development or _"Development"
elseif state == "discussion" then
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_development or Issue:get_state_name_for_state('discussion')
elseif state == "voting" then
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_development or Issue:get_state_name_for_state('voting')
elseif state == "verification" then
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_development or Issue:get_state_name_for_state('verification')
elseif state == "committee" then
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_development or _"Committee"
elseif state == "closed" then
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_closed or _"Closed"
elseif state == "canceled" then
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_closed or _"Canceled"
elseif state == "finished" then
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_closed or _"Finished"
elseif state == "finished_with_winner" then
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_closed or _"Finished (with winner)"
elseif state == "finished_without_winner" then
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_closed or _"Finished (without winner)"
elseif state == "open" then
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_open or _"Open"
elseif state == "any" then
  issues_desc = config.gui_preset[gui_preset].units[unit_name].issues_desc_any or _"Any"
else
  issues_desc = _"Unknown"
end

ui.container{ attr = { class  = "row-fluid" } , content = function()
  ui.container{ attr = { class  = "well span12" }, content = function()
    ui.container{ attr = { class  = "row-fluid" }, content = function()
      ui.container{ attr = { class  = "span3" }, content = function()
        ui.link{
          attr = { class="btn btn-primary btn-large"  },
          module = "area",
          id = area.id,
          view = "filters_bs",
          content = function()
            ui.heading{level=3,attr={class="fittext_back_btn"},content=function()
              ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
              slot.put(_"Back to previous page")
            end }
          end
        }
      end }
      ui.container{ attr = { class  = "span9" }, content = function()
        ui.container{ attr = { class  = "row-fluid" }, content = function()
          ui.container{ attr = { class  = "span12 text-center" }, content = function()
             ui.heading{level=1,attr={class="fittext0"},content=_(config.gui_preset[gui_preset].units[unit_name].assembly_title, {realname = member.realname}) }
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
  state = { "discussion", "verification", "voting", "committee" },
  default_interest = 'any',
  interest = { "any", "not_interested", "interested", "initiated", "supported", "potentially_supported", "voted" }
}
elseif state == "closed" or state == "canceled" or state == "finished" then
btns = {
  default_state = 'closed',
  default_interest = 'any',
  interest = { "any", "not_interested", "interested", "initiated", "supported", "potentially_supported", "voted" }
}
elseif state == "admission" then  
  btns = {
  default_state = 'admission',
  default_interest = 'any',
  interest = { "any", "not_interested", "interested", "initiated", "supported", "potentially_supported", "voted" }
}
else
  btns = {
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
    },
    default_scope = "any",
    scope = {
      "all_units",
      "my_units",
      "my_areas"
    }
  }
end

execute.chunk{
  module = "issue" ,
  chunk = "_filters_btn_bs" ,
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

local spanstyle
if unit_name == "cittadini" or unit_name == "iscritti" then
  spanstyle =""
else
  spanstyle="margin-left: 12.5%"
end


ui.container{ attr = { class="row-fluid"}, content=function()
  ui.container{ attr = { class="span12 well"}, content=function()
    ui.container{ attr = { class="row-fluid"}, content=function()
      ui.container{ attr = { class="span12 text-center"}, content=function()
        ui.heading{level=3,content=_(issues_desc) or "Initiatives:" }
      end }
    end }
    ui.container{ attr = { class="row-fluid btn_box_top  btn_box_bottom"}, content=function()
      if unit_name == "cittadini" or unit_name == "iscritti" then
        ui.container{ attr = { class="span3" }, content=function()
          ui.link {
            attr = { class="btn btn-primary btn-large large_btn table-cell eq1" },
            module = "area",
            view = "show_ext_bs",
            id = area.id,
            params = { state=state, orderby="supporters", interest=interest, desc=desc, ftl_btns=ftl_btns},
            content = function()
              ui.heading { level=4, attr={class="fittext1"}, content = _"ORDER BY NUMBER OF SUPPORTERS" }
            end
          }
        end }
      end
      ui.container{ attr = { class="span3", style=spanstyle }, content=function()
        ui.link {
          attr = { class="btn btn-primary btn-large large_btn table-cell eq1" },
          module = "area",
          view = "show_ext_bs",
          id = area.id,
          params = { state=state, orderby="creation_date", interest=interest, desc=desc, ftl_btns=ftl_btns },
          content = function()
            ui.heading { level=4,attr={class="fittext1"}, content = _"ORDER BY DATE OF CREATION" }
          end
        }
      end }
      ui.container{ attr = { class="span3" }, content=function()
        ui.link {
          attr = { class="btn btn-primary btn-large large_btn table-cell eq1" },
          module = "area",
          view = "show_ext_bs",
          id = area.id,
          params = { state=state, orderby="event", interest=interest, desc=desc, ftl_btns=ftl_btns},
          content = function()
            ui.heading { level=4,attr={class="fittext1"}, content = _"ORDER BY LAST EVENT DATE"  }
          end
        }
      end }
      ui.container{ attr = { class="span3" }, content=function()
        ui.link {
          attr = { class="btn btn-primary btn-large large_btn table-cell eq1" },
          module = "area",
          view = "show_ext_bs",
          id = area.id,
          params = { state=state, orderby=orderby, interest=interest, desc=not(desc), ftl_btns=ftl_btns},
          content = function()
            ui.heading { level=4,attr={class="fittext1"}, content = inv_txt  }
          end
        }
      end }
    end }
    ui.container{ attr = { class="row-fluid"}, content=function()
      ui.container{ attr = { id="issues_box", class="span12 alert alert-simple issue_listing_box"}, content=function()
        execute.view{
          module="issue" ,
          view="_list_ext2_bs",
          params={
         --   state=state,
         --   orderby=orderby,
         --   desc=desc,
         --   interest=interest,
            selector=selector, 
            member=member 
          }
        }
      end }
    end }
  end }
end }

ui.script{static = "js/jquery.equalheight.js"}
ui.script{script = '$(document).ready(function() { equalHeight($(".eq1")); $(window).resize(function() { equalHeight($(".eq1")); }); }); ' }
ui.script{static = "js/jquery.fittext.js"}
--ui.script{script = "jQuery('.fittext').fitText(1.0, {minFontSize: '24px', maxFontSize: '28px'}); " }
ui.script{script = "jQuery('.fittext0').fitText(1.0, {minFontSize: '24px', maxFontSize: '32px'}); " }
ui.script{script = "jQuery('.fittext1').fitText(0.9, {minFontSize: '12px', maxFontSize: '26px'}); " }
ui.script{script = "jQuery('.fittext_back_btn').fitText(1.1, {minFontSize: '17px', maxFontSize: '32px'}); " }

