slot.set_layout("custom")

local issue = Issue:by_id(param.get_id())
local state = param.get("state")
local orderby = param.get("orderby") or ""
local desc =  param.get("desc", atom.boolean)
local interest = param.get("interest")
local scope = param.get("scope")
local view = param.get("view") or "homepage"
local ftl_btns = param.get("ftl_btns",atom.boolean)
local init_ord = param.get("init_ord") or "supporters"

local function round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

local return_view, return_module
if view == "homepage" then
  return_module="index"
  return_view="homepage_bs"
  return_btn_txt=_"Back to homepage"
elseif view == "area" then
  return_module="area"
  return_view="show_ext_bs"
  return_btn_txt=_"Back to issue listing"
elseif view == "area_private" then
	return_module = "area_private"
	return_view = "show_ext_bs"
	return_btn_txt = _"Back to issue listing"
end

if app.session.member_id then
  issue:load_everything_for_member_id(app.session.member_id)
end

if not app.html_title.title then
  app.html_title.title = _("Issue ##{id}", { id = issue.id })
end

local url=request.get_absolute_baseurl().."issue/show/show_ext2_bs/"..tostring(issue.id)..".html"

ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span12 well"}, content=function()
    ui.container{ attr = { class  = "row-fluid" }, content = function()
      ui.container{ attr = { class  = "span3" }, content = function()
        ui.link{
          attr = { class="btn btn-primary btn-large fixclick" },
          module = return_module,
          id = issue.area.id,
          view = return_view,
          params = param.get_all_cgi(),
          content = function()
            ui.heading{level=3 ,content=function()
              ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
              slot.put(return_btn_txt)
            end }
          end
        }
      end }
      ui.container{ attr = { class  = "span8" }, content = function()
        ui.container{attr={class="row-fluid"}, content=function()
          ui.container{attr={class="span12"}, content=function()
            ui.heading{level=1,attr={class="fittext1 uppercase"},content=_"Details for issue Q"..issue.id}
          end }
        end }
        ui.container{attr={class="row-fluid"}, content=function()
          ui.container{attr={class="span12 nowrap"}, content=function()
            ui.heading{level=6,attr={class=""},content=_"Issue link (copy the link and share to the web):"}
            slot.put("<input id='issue_url_box' type='text' value="..url..">") 
            ui.script{static="js/jquery.select_popover.js"}

            ui.tag{
              tag="a",
              attr={
                id="select_btn",
                href="#",
                class="btn btn-primary inline-block"
              },
              content=function()
                ui.heading{level=6,content=_"Select"}
              end
            }
          end }
        end }
      end }
      ui.container{ attr = { id="social_box", class  = "span1 text-right" }, content = function()
        ui.container{ attr = { class  = "row-fluid" }, content = function()
          ui.container{ attr = { class  = "span12" }, content = function()
--[[
            slot.put('<div class="fb-like" data-send="false" data-layout="box_count" data-width="450" data-show-faces="true" data-font="lucida grande"></div>')
          end }
        end }
        ui.container{ attr = { class  = "row-fluid" }, content = function()
          ui.container{ attr = { class  = "span12" }, content = function()
            slot.put('<div class="g-plusone" data-size="tall" data-href='..url..'></div><script type="text/javascript">window.___gcfg = {lang: "it"}; (function() { var po = document.createElement("script"); po.type = "text/javascript"; po.async = true; po.src = "https://apis.google.com/js/plusone.js"; var s = document.getElementsByTagName("script")[0]; s.parentNode.insertBefore(po, s); })(); </script>')
          end }
        end }
        ui.container{ attr = { class  = "row-fluid" }, content = function()
          ui.container{ attr = { class  = "span12" }, content = function()
            slot.put('<a href="https://twitter.com/share" class="twitter-share-button" data-lang="it" data-count="vertical">Tweet</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>')
--]]
          end }
        end }
      end }
    end }
  end }
end }

ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span12"}, content=function()
    ui.container{attr={class="row-fluid"}, content=function()
      ui.container{ attr = { class = "span3"}, content = function()
        execute.view{ module = "issue", view = "info_box", params = {issue=issue}  }
      end }
      ui.container{ attr = { class = "span9"}, content = function()
        execute.view{ module = "issue", view = "phasesbar", params = { state=issue.state } }
      end }
    end }
  end }
end }

ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span12 alert alert-simple issue_box paper"}, content=function()
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.tag{tag="strong",content=function()
          ui.heading { level=5, content = "Q"..issue.id.." - "..(issue.title or _"No title for the issue!") }
        end }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        execute.view{ module = "issue", view = "info_data", params = {issue=issue}  }
      end }
    end }
    ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.tag { tag="p", attr = { class="issue_brief_description" }, content = issue.brief_description or _"No description available" }
      end }
    end }
    ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "uppercase spaceline" }, content = function()
          ui.tag{content= _"Issue created at:"}
          ui.tag{tag="strong",content="  "..format.timestamp(issue.created)}
        end }
      end }
    end }
    if issue.state == "admission" then
      ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
        ui.container{ attr = { class = "span12"}, content = function()
            ui.heading{ level=5, attr = { class = "uppercase" }, content = function() 
              ui.tag{content=_"Time limit to reach the supporters quorum:"}
              ui.tag{tag="strong",content="  "..format.interval_text(issue.state_time_left, { mode = "time_left" }) }
            end }
        end }
      end }
    end
    ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "uppercase" }, content = function()
          ui.tag{content= _"By user:" }
        end }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span8"}, content = function()
        if issue.member_id and issue.member_id > 0 then
          execute.view{ module="member", view="_info_data", id=issue.member_id }
        else
          ui.heading{ level=6, content = _"No author for this issue" }
        end
      end }
    end }
    ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "uppercase" }, content = function()
          ui.tag{content= _"Keywords:" }
        end }
        ui.tag{ content = _"(Press a keyword to see all issues created until today discussing that topic)" }
      end }
    end }
    ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        local keywords=Keyword:by_issue_id(issue.id)
        if keywords and #keywords > 0 then
          for k = 1, #keywords do
            ui.tag{tag="span",attr={ class="btn btn-danger btn-small filter_btn nowrap"}, content=function()
              ui.heading{ level=5, attr = { class = "uppercase" },content = keywords[k].name}
            end }
          end
        end
      end }
    end }
    ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "uppercase" }, content = function()
          ui.tag{content=  _"Technical competence areas:" }
        end }
        ui.tag{ content = _"(Press an area of competence to see all issues created until today concerning that area)" }
      end }
    end }
    ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        areas={"biologia","chimica","fisica", "ingegneria edile", "riciclaggio", "ecologia"}
        for i,k in ipairs(areas) do
          ui.tag{tag="span",attr={ class="btn btn-info btn-small filter_btn nowrap"}, content=function()
            ui.heading{ level=5, attr = { class = "uppercase" },content = k}
          end }
        end
      end }
    end }
    ui.container{ attr = { class = "row-fluid spaceline3"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "alert head-orange uppercase inline-block" }, content = _"Problem description:" }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12 depression_box"}, content = function()
        ui.tag{content=issue.problem_description  or _"No description available" }
      end }
    end }
    ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "alert head-orange uppercase inline-block" }, content = _"Aim description:" }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12 depression_box"}, content = function()
        ui.tag{content=issue.aim_description  or _"No description available"  }
      end }
    end }

    ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "alert head-chocolate uppercase inline-block" }, content = _"Proposed solutions:" }
      end }
    end }
    ui.container{attr = {class="row-fluid"}, content =function()
      ui.container{attr = {class="span12 depression_box"}, content =function()

        ui.container{ attr = { class = "row-fluid"}, content = function()
          ui.container{ attr = { class = "span12 alert label-area"}, content = function()
            ui.container{ attr = { class = "row-fluid"}, content = function()
              ui.container{ attr = { class = "span8"}, content = function()
                if #issue.initiatives == 1 then
                  content= _"initiative"
                else
                  content= _"initiatives"
                end
    
                ui.tag{content=function()
                  
                  slot.put( _("Vi sono attualmente <strong>#{count}</strong> proposte per risolvere la questione sollevata. Decidi a quale dare il tuo sostegno o presenta una proposta tua. Almeno una proposta tra quelle presentate deve raggiungere il quorum di sostenitori entro <strong>#{days}</strong> affinche' la questione venga ammessa alla fase successiva.",{ count=#issue.initiatives, days=format.interval_text(issue.state_time_left)}) )
                end }
              end }
    
              ui.container{ attr = { class = "span4"}, content = function()
                ui.link{
                  attr = { class="btn btn-primary spaceline btn_box_bottom fixclick"  },
                  module = "wizard",
                  params = { issue_id=issue.id},
                  view = "new",
                  content = function()
                    ui.container{ attr = { class = "row-fluid"}, content = function()
                      ui.container{ attr = { class = "span4"}, content = function()
                        ui.image{ attr = { class="pen_paper"}, static="svg/pen_paper.svg"}
                      end }
                      ui.container{ attr = { class = "span6"}, content = function()
                        ui.heading{level=5,attr={class="fittext_write"},content=_"Create your own alternative initiative"}
                      end }
                    end }
                  end
                }
              end }
            end }
          end }
        end }
		

        ui.container{attr = {class="row-fluid"}, content =function()
          local quorum_percent = issue.policy.issue_quorum_num * 100 / issue.policy.issue_quorum_den
          local quorum_supporters  
          if issue.population and issue.population > 0 then
            quorum_supporters = math.floor(issue.population * quorum_percent / 100)
          else
            quorum_supporters = 0
          end

          ui.container{attr = {class="span2 offset2"}, content =function()
            ui.container{attr = {class="initiative_quorum_out_box"}, content =function()
              ui.container{attr = {id="quorum_box", class="initiative_quorum_box", style="left:"..2+quorum_percent.."%"}, content =function()
                ui.container{attr = {id="quorum_txt"}, content=function()
                  slot.put(" ".."Quorum".." "..quorum_percent.."%".."<br>".."    ("..quorum_supporters.." ".._"supporters"..")")
                end }
              end }
            end }
          end }

          ui.container{attr = {class="span7 offset1 text-center"}, content =function()
            ui.container{attr = {class="btn-group"}, content =function()
              local btna, btnb = "",""
              if init_ord == "supporters" then btna = " active" end
              if init_ord == "event" then btnb = " active" end

              ui.link{
                attr = { class="btn btn-primary btn-large fixclick wrap"..btna },
                module = request.get_module(),
                id = issue.id,
                view = request.get_view(),
                params = { state=state, orderby=orderby, desc=desc, interest=interest,scope=scope,view=view,ftl_btns=ftl_btns, init_ord="supporters" },
                content = function()
                  ui.heading{level=6,attr={class="fittext_ord"},content=_"ORDER BY NUMBER OF SUPPORTERS"}
                end
              }
              ui.link{
                attr = { class="btn btn-primary btn-large fixclick wrap"..btnb },
                module = request.get_module(),
                id = issue.id,
                view = request.get_view(),
                params = { state=state, orderby=orderby, desc=desc, interest=interest,scope=scope,view=view,ftl_btns=ftl_btns, init_ord="event" },
                content = function()
                  ui.heading{level=6,attr={class="fittext_ord"},content=_"ORDER BY LAST EVENT DATE"}
                end
              }
            end }

          end }
        end }
		

        ui.container{attr = {class="row-fluid spaceline2"}, content =function()
          ui.container{attr = {class="span12 initiative_list_box"}, content =function()

            local initiatives_selector = issue:get_reference_selector("initiatives")
            local highlight_string = param.get("highlight_string")
            if highlight_string then
              initiatives_selector:add_field( {'"highlight"("initiative"."name", ?)', highlight_string }, "name_highlighted")
            end

            execute.view{
              module = "initiative",
              view = "_list_ext2_bs",
              id = issue.id,
              params = {
--                issue = issue,
--                initiatives_selector = initiatives_selector,
--                highlight_initiative = for_initiative,
--                highlight_string = highlight_string,
--                no_sort = true,
--                limit = (for_listing or for_initiative) and 5 or nil,
--                hide_more_initiatives=false,
--                limit=25,
                for_details=true,
--                for_member = for_member,
                init_ord=init_ord
              }
            }

          end }
        end }

      end }
    end }
  end }
end }
ui.script{static = "js/jquery.fittext.js"}
ui.script{script = "jQuery('.fittext_back_btn').fitText(1.1, {minFontSize: '14px', maxFontSize: '32px'}); " }
ui.script{script = "jQuery('.fittext_write').fitText(0.9, {minFontSize: '19px', maxFontSize: '32px'}); " }
--ui.script{script = "jQuery('.fittext_ord').fitText(0.9, {minFontSize: '12px', maxFontSize: '32px'}); " }
--ui.script{static = "js/jquery.equalheight.js"}
--ui.script{script = '$(document).ready(function() { equalHeight($(".eq_ord")); $(window).resize(function() { equalHeight($(".eq_ord")); }); }); ' }
ui.script{static = "js/jquery.quorum_bar.js"}
ui.script{script = "jQuery('#quorum_box').quorum_bar(); " }

