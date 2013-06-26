slot.set_layout("m5s_bs")
local issue = Issue:by_id(param.get_id())
local view = param.get("view") 

local return_view, return_module
if view == "homepage" then
  return_module="index"
  return_view="homepage_bs"
  return_btn_txt=_"Back to homepage"
elseif view == "area" then
  return_module="area"
  return_view="show_ext_bs"
  return_btn_txt=_"Back to issue listing"
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
          attr = { class="btn btn-primary btn-large"  },
          module = return_module,
          id = issue.area.id,
          view = return_view,
          content = function()
            ui.heading{level=3,attr={class="fittext_back_btn"},content=function()
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
          ui.container{attr={class="span12"}, content=function()
            ui.heading{level=6,attr={class=""},content=_"Issue link (copy the link and share to the web):"}
            slot.put("<input id='issue_url_box' type='text' value="..url..">") 

            ui.tag{
              tag="a",
              attr={
                href="#",
                class="btn btn-primary btn-mini inline-block",
                onclick='document.getElementById("issue_url_box").select();'
              },
              content=function()
                ui.heading{level=6,content=_"Select"}
              end
            }
            -- Copy button
            --[[
            ui.tag{ 
              tag="a", 
              attr={ 
                href="#", 
                id="copy-button", 
                class="btn btn-primary btn-mini inline-block", 
                dataclipboardtext=url
              },
              content=function()
                ui.heading{level=6,content=_"Copy"}
              end 
            }
            ui.script{static = "js/ZeroClipboard.js"}
            ui.script{static = "js/copytoclipboard.js"}
            --]]

          end }
        end }
      end }
      ui.container{ attr = { id="social_box", class  = "span1 text-center" }, content = function()
        slot.put('<div class="fb-like" data-send="false" data-layout="box_count" data-width="450" data-show-faces="true" data-font="lucida grande"></div>')
        slot.put('<div class="g-plusone" data-size="tall" data-href='..url..'></div><script type="text/javascript">window.___gcfg = {lang: "it"}; (function() { var po = document.createElement("script"); po.type = "text/javascript"; po.async = true; po.src = "https://apis.google.com/js/plusone.js"; var s = document.getElementsByTagName("script")[0]; s.parentNode.insertBefore(po, s); })(); </script>')
        slot.put('<a href="https://twitter.com/share" class="twitter-share-button" data-lang="it" data-count="vertical">Tweet</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="https://platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>')
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
        ui.container{attr={class="pull-right"}, content=function()
          execute.view{ module = "issue", view = "phasesbar", params = { state=issue.state,size="" } }
        end }
      end }
    end }
  end }
end }

ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span12 alert alert-simple"}, content=function()
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading { level=5, content = "Q"..issue.id.." - "..issue.title }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        execute.view{ module = "issue", view = "info_data", params = {issue=issue}  }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.tag { tag="p", attr = { class="issue_brief_description" }, content = issue.brief_description }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "uppercase" }, content = _"Issue created at:".." "..format.timestamp(issue.created) }
        if issue.state == "admission" then
          ui.heading{ level=5, attr = { class = "uppercase" }, content = _"Time limit to reach the supporters quorum:".." "..format.interval_text(issue.state_time_left, { mode = "time_left" }) }
        end
        ui.heading{ level=5, attr = { class = "uppercase" }, content = _"By user:" }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        slot.put("user image")
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "uppercase" }, content = _"Keywords:" }
        ui.tag{ content = _"(Press a keyword to see all issues created until today discussing that topic)" }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        for i=1,5,1 do 
          ui.tag{tag="span",attr={ class="btn btn-danger btn-small filter_btn"}, content=function()
            ui.heading{ level=6, attr = { class = "uppercase" },content = "keyword"}
          end }
        end
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "uppercase" }, content = _"Technical competence areas:" }
        ui.tag{ content = _"(Press an area of competence to see all issues created until today concerning that area)" }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        for i=1,3,1 do 
          ui.tag{tag="span",attr={ class="btn btn-info btn-small filter_btn"}, content=function()
            ui.heading{ level=6, attr = { class = "uppercase" },content = "area"}
          end }
        end
      end }
    end }
    ui.container{ attr = { class = "row-fluid spaceline"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "alert head-orange uppercase inline-block" }, content = _"Problem description:" }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12 alert alert-simple"}, content = function()
        ui.tag{content=issue.problem_description}
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "alert head-orange uppercase inline-block" }, content = _"Aim description:" }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12 alert alert-simple"}, content = function()
        ui.tag{content=issue.aim_description}
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12"}, content = function()
        ui.heading{ level=5, attr = { class = "alert head-orange uppercase inline-block" }, content = _"Proposed solutions:" }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12 alert alert-simple"}, content = function()
        ui.container{ attr = { class = "row-fluid"}, content = function()
          ui.container{ attr = { class = "span9"}, content = function()
            if #issue.initiatives == 1 then
              content= _"initiative"
            else
              content= _"initiatives"
            end

            ui.tag{content= _("Vi sono attualmente #{count} #{initiatives} per risolvere la questione sollevata. Decidi a quale dare il tuo sostegno o presenta una proposta tua. Almeno una proposta tra quelle presentate deve raggiungere il quorum di sostenitori entro #{days} affinche' questione venga ammessa alla fase successiva.",{ count=#issue.initiatives, initiatives=content}) }
          end }

          ui.container{ attr = { class = "span3"}, content = function()
            ui.link{
              attr = { class="btn btn-primary"  },
              module = "wizard",
              params = { issue_id=issue.id},
              view = "new",
              content = function()
                ui.heading{level=6,attr={class=""},content=_"Create your own alternative initiative" }
              end
            }
          end }
        end }
      end }
    end }
        ui.container{attr = {class="row-fluid"}, content =function()
          ui.container{attr = {class="span12 alert alert-simple"}, content =function()
            local initiatives_selector = issue:get_reference_selector("initiatives")
            local highlight_string = param.get("highlight_string")
            if highlight_string then
              initiatives_selector:add_field( {'"highlight"("initiative"."name", ?)', highlight_string }, "name_highlighted")
            end
            execute.view{
              module = "initiative",
              view = "_list_ext_bs",
              params = {
                issue = issue,
                initiatives_selector = initiatives_selector,
                highlight_initiative = for_initiative,
                highlight_string = highlight_string,
                no_sort = true,
                limit = (for_listing or for_initiative) and 5 or nil,
                hide_more_initiatives=false,
                limit=25,
                for_member = for_member
              }
            }
          end }
        end }
  end }
end }

slot.select("head", function()
  execute.view{ module = "issue", view = "_show", params = { issue = issue } }
end )

if app.session:has_access("all_pseudonymous") then

  ui.container{ attr = { class = "heading" }, content = _"Interested members" }
  
  local interested_members_selector = issue:get_reference_selector("interested_members_snapshot")
    :join("issue", nil, "issue.id = direct_interest_snapshot.issue_id")
    :add_field("direct_interest_snapshot.weight")
    :add_where("direct_interest_snapshot.event = issue.latest_snapshot_event")

  execute.view{
    module = "member",
    view = "_list",
    params = {
      issue = issue,
      members_selector = interested_members_selector
    }
  }

  ui.container{ attr = { class = "heading" }, content = _"Details" }
  
  execute.view{
    module = "issue",
    view = "_details",
    params = { issue = issue }
  }
  
end

if issue.snapshot then
  slot.put("<br />")
  ui.field.timestamp{ label = _"Last snapshot:", value = issue.snapshot }
end

ui.script{static = "js/jquery.fittext.js"}
--ui.script{script = "jQuery('.fittext').fitText(1.0, {minFontSize: '24px', maxFontSize: '28px'}); " }
--ui.script{script = "jQuery('.fittext0').fitText(1.0, {minFontSize: '24px', maxFontSize: '32px'}); " }
--ui.script{script = "jQuery('.fittext1').fitText(1.1, {minFontSize: '12px', maxFontSize: '32px'}); " }
ui.script{script = "jQuery('.fittext_back_btn').fitText(1.1, {minFontSize: '14px', maxFontSize: '32px'}); " }


