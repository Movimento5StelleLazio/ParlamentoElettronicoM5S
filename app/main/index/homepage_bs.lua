slot.set_layout("custom")
local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1] or 'default'

local state = param.get("state") or "any"
local scope = param.get("scope") or "all_units"
local orderby = param.get("orderby") or "event" 
local desc = param.get("desc",atom.boolean) or false
local interest = param.get("interest") or "any"
local member = app.session.member
local ftl_btns = param.get("ftl_btns",atom.boolean) or false

-- Right selector
local issues_selector_myinitiatives =Issue:new_selector()
execute.chunk{
  module    = "issue",
  chunk     = "_filters_ext",
  params    = {
    state=state,
    orderby=orderby,
    desc=desc,
    scope=scope,
    interest=interest,
    selector=issues_selector_myinitiatives
  }
}
--[[
if selector then 
  issues_selector_myinitiatives = selector
  selector = nil
else
  slot.put_into("error", "No selector returned from filter")
end
--]]

-- Left selector
local issues_selector_voted =Issue:new_selector()
execute.chunk{
  module    = "issue",
  chunk     = "_filters_ext",
  params    = {
    state=state,
    orderby=orderby,
    desc=desc,
    scope=scope,
    interest="voted",
    selector=issues_selector_voted
  }
}
--[[
if selector then
  issues_selector_voted = selector
  selector = nil
else
  slot.put_into("error", "No selector returned from filter")
end
--]]
 
ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 well text-center"},content=function()
    ui.container{attr={class="row-fluid"},content=function()
      ui.container{attr={class="span12"},content=function()
        ui.heading{level=1, content=function()
          slot.put(_("Welcome <strong>#{realname}.</strong>", {realname = app.session.member.realname}))
        end }

        ui.heading{level=6, content=_"You are now inside the Digital Assembly of M5S Lazio's Public Affairs."}
        ui.heading{level=6, content=_"Here laws and measures for Region and his citizens are being discussed."}
      end }
    end }

    ui.container{attr={class="row-fluid spaceline"},content=function()
      ui.container{attr={class="span12"},content=function()
        ui.heading{level=2, content=_"What you want to do?"}
        ui.heading{level=6, content=_"Choose by pressing one of the following buttons:"}
      end }
    end }

    ui.container{attr={class="row-fluid btn_box_top btn_box_bottom"},content=function()
    
      ui.container{attr={class="span3"},content=function()
        ui.link{attr={class="btn btn-primary btn-large large_btn table-cell eq1 fixclick"},
          module="unit", view="show_ext_bs",
          id=config.gui_preset[gui_preset].units["cittadini"].unit_id,
          content=function()
            ui.heading{level=3, attr={class="fittext"}, content=_"Homepage read new issues"}
          end }
      end }
    
      ui.container{attr={class="span3"},content=function()
        ui.link{attr={class="btn btn-primary btn-large large_btn table-cell eq1 fixclick"},
          module = "unit", view = "show_ext_bs",
          id=config.gui_preset[gui_preset].units["cittadini"].unit_id,
          params={wizard=true},
          content=function()
             ui.heading{level=3,attr={class="fittext"}, content=_"Homepage write new issue"}
          end }
      end }
    
      ui.container{attr={class="span3"},content=function()
        ui.link{attr={class="btn btn-primary btn-large large_btn table-cell eq1 fixclick"},
          module="unit", view="show_ext_bs",
          id=config.gui_preset[gui_preset].units["eletti"].unit_id,
          content=function()
            ui.heading{level=3, attr={class="fittext"}, content=_"Homepage read m5s issues"}
          end }
      end }
       
      ui.container{attr={class="span3"},content=function()
        ui.link{attr={class="btn btn-primary btn-large large_btn table-cell eq1 fixclick"},
          module="unit", view="show_ext_bs",
          id=config.gui_preset[gui_preset].units["altri_gruppi"].unit_id,
          content=function()
            ui.heading{level=3, attr={class="fittext"}, content=_"Homepage read other issues"}
          end }
      end }

    end }
  end }
end }
ui.script{static = "js/jquery.equalheight.js"}
ui.script{script = '$(document).ready(function() { equalHeight($(".eq1")); $(window).resize(function() { equalHeight($(".eq1")); }); }); ' }
ui.script{static = "js/jquery.fittext.js"}
ui.script{script = "jQuery('.fittext').fitText(0.9, {minFontSize: '10px', maxFontSize: '28px'}); " }



btns = {
  default_state = 'any',
  state = {
    { 
      "any",
      "open",
      "admission",
      "discussion",
      "verification"
    },
    {
      "voting",
      "committee",
      "closed",
      "canceled"
    }
  },
  default_scope = "all_units",
  scope = {
    {
      "all_units",
      "my_units",
      "citizens"
    },
    {
      "electeds",
      "others"
    }
  }
}


ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
    execute.chunk{
      module = "issue" ,
      chunk = "_filters_btn2_bs" ,
      params = {
        state = state,
        orderby = orderby,
        desc = desc,
        scope = scope,
        btns = btns,
        ftl_btns = ftl_btns
      }
    }
  end }
end }

if not issues_selector_voted or not issues_selector_myinitiatives then
  return true
end

ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span6"},content=function()
    ui.container{attr={class="row-fluid"},content=function()
      ui.container{attr={class="span12 text-center"},content=function()
        ui.image{static = "parlamento_icon_small.png"}
      end }
    end }
    ui.container{attr={class="row-fluid"},content=function()
      ui.container{attr={class="span12 well"},content=function()
        ui.container{attr={class="row-fluid"},content=function()
          ui.container{attr={class="span12 text-center"},content=function()
            ui.heading{level=3,attr={class="uppercase"},content=_"Your Voting"}
          end }
        end }
        ui.container{attr={class="row-fluid"},content=function()
          ui.container{attr={class="span12 well-inside"},content=function()
            execute.view{
              module = "issue",
              view   = "_list_ext2_bs",
              params = {
                state=state,
                orderby=orderby,
                desc=desc,
                scope=scope,
                interest=interest,
                list="voted",
                ftl_btns=ftl_btns,
		for_member=member,
                for_details = false,
                selector = issues_selector_voted
              }
            }
          end }
        end }
      end }
    end }
  end }
  ui.container{attr={class="span6"},content=function()
    ui.container{attr={class="row-fluid"},content=function()
      ui.container{attr={class="span12 text-center"},content=function()
        ui.image{static = "parlamento_icon_small.png"}
      end }
    end }
    ui.container{attr={class="row-fluid"},content=function()
      ui.container{attr={class="span12 well"},content=function()
        ui.container{attr={class="row-fluid"},content=function()
          ui.container{attr={class="span12 text-center"},content=function()
            ui.heading{level=3,attr={class="uppercase"},content=_"Your Proposals"}
          end }
        end }
        ui.container{attr={class="row-fluid"},content=function()
          ui.container{attr={class="span12 well-inside"},content=function()
            execute.view{
              module = "issue",
              view   = "_list_ext2_bs",
              params = {
                state=state,
                orderby=orderby,
                desc=desc,
                scope=scope,
                interest=interest,
                list="proposals",
                ftl_btns=ftl_btns,
                for_member=member,
                for_details = false,
                selector = issues_selector_myinitiatives
              }
            }
          end }
        end }
      end }
    end }
  end }
end }



