slot.set_layout("custom")

local initiative = param.get("initiative", "table")

local show_as_head = param.get("show_as_head", atom.boolean)

initiative:load_everything_for_member_id(app.session.member_id)

local issue = initiative.issue

-- TODO performance
local initiator
if app.session.member_id then
  initiator = Initiator:by_pk(initiative.id, app.session.member.id)
end
local issues_selector_myinitiatives = Issue:new_selector()
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
if app.session.member_id then
  issue:load_everything_for_member_id(app.session.member_id)
end

local initiative = param.get("initiative", "table")

local show_as_head = param.get("show_as_head", atom.boolean)

initiative:load_everything_for_member_id(app.session.member_id)

local issue = initiative.issue

-- TODO performance
local initiator
if app.session.member_id then
  initiator = Initiator:by_pk(initiative.id, app.session.member.id)
end

if app.session.member_id then
  issue:load_everything_for_member_id(app.session.member_id)
end


local initiators_members_selector = initiative:get_reference_selector("initiating_members")
  :add_field("initiator.accepted", "accepted")
  :add_order_by("member.name")
if initiator and initiator.accepted then
  initiators_members_selector:add_where("initiator.accepted ISNULL OR initiator.accepted")
else
  initiators_members_selector:add_where("initiator.accepted")
end

local initiators = initiators_members_selector:exec()


local initiatives_selector = initiative.issue:get_reference_selector("initiatives")
--[[ slot.select("head", function()
  execute.view{
    module = "issue",
    view = "_show",
    params = {
      issue = initiative.issue,
      initiative_limit = 3,
      for_initiative = initiative
    }
  }
end)--]]

util.help("initiative.show")

local class = "initiative_head"

if initiative.polling then
  class = class .. " polling"
end

app.html_title.title = initiative.name
app.html_title.subtitle = _("Initiative ##{id}", { id = initiative.id })

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

local url=request.get_absolute_baseurl().."initiative/show/"..tostring(initiative.id)..".html"

ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span12 well"}, content=function()


    ui.container{ attr = { class  = "row-fluid" }, content = function()
      ui.container{ attr = { class  = "span3" }, content = function()
        ui.link{
          attr = { class="btn btn-primary btn-large fixclick" },
          module = "area",
          id = issue.area.id,
          view = "show_ext_bs",
          params = param.get_all_cgi(),
          content = function()
            ui.heading{level=3 ,content=function()
              ui.image{ attr = { class="arrow_medium"}, static="svg/arrow-left.svg"}
              slot.put(return_btn_txt)
            end }
          end }
              end }

      ui.container{ attr = { class  = "span8" }, content = function()
        ui.container{attr={class="row-fluid"}, content=function()
          ui.container{attr={class="span12"}, content=function()
            ui.heading{level=1,attr={class="fittext1 uppercase"},content=_"Details for initiative P"..initiative.id}
          end }
        end }
        ui.container{attr={class="row-fluid"}, content=function()
          ui.container{attr={class="span9 nowrap"}, content=function()
            ui.heading{level=6,attr={class=""},content=_"Initiative link (copy the link and share to the web):"}
            slot.put("<input id='initiative_url_box' type='text' value="..url..">") 
                    end }
          ui.container{attr={class="span2 spaceline nowrap"}, content=function()
            ui.tag{
              tag="a",
              attr={
                id="select_btn",
                href="#",
                class="btn btn-primary inline-block"
              },
              content=function()
                ui.heading{level=3,content=_"Select"}
              end
            }
          end }
          end }
      end }     

    --[[  ui.container{ attr = { id="social_box", class  = "span1 text-right" }, content = function()
        ui.container{ attr = { class  = "row-fluid" }, content = function()
          ui.container{ attr = { class  = "span12" }, content = function()

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

          end }
        end }
      end } ]]
     end }
end }
  ui.container{ attr = { class = "row-fluid"}, content = function()
end }
  ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span12 well"}, content=function()
  ui.container{ attr = { class = "row-fluid"}, content = function()
            ui.container{ attr = { class = "span9 offset1 phasesheight"}, content = function()
        execute.view{ module = "issue", view = "phasesbar", params = { state=issue.state } }       
          end }
         end }




    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{  content = function()
        ui.tag{tag="div",attr = { class = "span7"},content=function()
          ui.heading { level=3, attr = { class = "label label-warning"},content = "Q"..issue.id.." - "..(issue.title or _"No title for the issue!") }
        end }
      end }
    end }

    ui.container{ attr = { class = "row-fluid"}, content = function()
    ui.container{ attr = { class = "row-fluid span12 well"}, content = function()
      ui.container{ attr = { class = "span5"}, content = function()
        execute.view{ module = "issue", view = "info_data", params = {issue=issue}  }
      end }

      ui.container{ attr = { class = "span7"}, content = function()
        ui.heading{ level=4, attr = { class = "spaceline" }, content = function()
          ui.tag{content= _"Issue created at:"}
          ui.tag{tag="strong",content="  "..format.timestamp(issue.created)}
        end }

    if issue.state == "admission" then
            ui.heading{ level=4, attr = { class = "" }, content = function() 
              ui.tag{content=_"Time limit to reach the supporters quorum:"}
              ui.tag{tag="strong",content="  "..format.interval_text(issue.state_time_left, { mode = "time_left" }) }
      end }
    end
      end }   
      end } 
 end }
 ui.container{attr={class="row-fluid"}, content=function()
 ui.container{attr={class="span12 well"}, content=function()
 ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span8 offset2 text-center label label-warning spaceline3"}, content=function()
             ui.tag{tag="h3",content="LEGGI IL TESTO INTEGRALE E DAI IL TUO SOSTEGNO:" }
  end }
  end }     
      ui.container{attr={class="row-fluid spaceline text-center"}, content=function()
      ui.container{attr={class="span12 well-inside paper"}, content=function()
 ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span10 offset1 text-justify spaceline"}, content=function()
             ui.tag{tag="p",content="Puoi interessarti, sostenere, ignorare o proporre emendamenti alla proposta, dare il tuo interessa allarga la platea dei votanti e quindi in percentuale il quorum da raggiungere per permettere alla proposta di passare alla votazione, emendare la proposta ti permette di proporre modifiche parziali da sottoporre al giudizio dell'assemblea" }
  end }
  end } 


       ui.container{attr={class="row-fluid spaceline text-center"}, content=function()
        ui.container{attr={class="span3 spaceline"}, content=function()
	 if not issue.closed and not issue.fully_frozen then
		if issue.member_info.own_participation then
		  ui.link { attr = { class = "btn btn-primary btn_size_fix fixclick"}, 
		    in_brackets = true,
		    text    = _"Withdraw",
		    module  = "interest",
		    action  = "update",
		    params  = { issue_id = issue.id, delete = true },
		    routing = {
		      default = {
		        mode = "redirect",
		        module = request.get_module(),
		        view = request.get_view(),
		        id = param.get_id_cgi(),
		        params = param.get_all_cgi()
		      }
		    }
		  }
		elseif app.session.member:has_voting_right_for_unit_id(issue.area.unit_id) then
		  ui.link{ 
		    attr = { class="btn btn-primary btn_size_fix fixclick" },
		    text    = _"Add my interest",
		    module  = "interest",
		    action  = "update",
		    params  = { issue_id = issue.id },
		    routing = {
		      default = {
		        mode = "redirect",
		        module = request.get_module(),
		        view = request.get_view(),
		        id = param.get_id_cgi(),
		        params = param.get_all_cgi()
		      }
		    }
		  }
       		 end
      		end
              end }

if app.session.member_id then
    ui.container{ content = function()
      execute.view{
        module = "supporter",
        view = "_show_box",
        params = {
          initiative = initiative
        }
      }
    end }


ui.container{attr={class="span3 spaceline"}, content=function()
        ui.link{
        attr = { class = "btn btn-primary btn_size_fix fixclick" },
          module = "suggestion", view = "new", params = { initiative_id = initiative.id },
          text = _"New suggestion"
        }
   end }
  end
end }
end }
end }

if app.session:has_access("authors_pseudonymous") then
    ui.container{ attr = { class = "content" }, content = function()
      ui.tag{
        attr = { class = "initiator_names" },
        content = function()
          for i, initiator in ipairs(initiators) do
            slot.put(" ")
            if app.session:has_access("all_pseudonymous") then
              ui.link{
                content = function ()
                  execute.view{
                    module = "member_image",
                    view = "_show",
                    params = {
                      member = initiator,
                      image_type = "avatar",
                      show_dummy = true,
                      class = "micro_avatar",
                      popup_text = text
                    }
                  }
                end,
                module = "member", view = "show", id = initiator.id
              }
              slot.put(" ")
            end
            ui.link{
              text = initiator.name,
              module = "member", view = "show", id = initiator.id
            }
            if not initiator.accepted then
              ui.tag{ attr = { title = _"Not accepted yet" }, content = "?" }
            end
          end
          if initiator and initiator.accepted and not initiative.issue.fully_frozen and not initiative.issue.closed and not initiative.revoked then
            slot.put(" &middot; ")
            ui.link{
              attr = { class = "action" },
              content = function()
                slot.put(_"Invite initiator")
              end,
              module = "initiative",
              view = "add_initiator",
              params = { initiative_id = initiative.id }
            }
            if #initiators > 1 then
              slot.put(" &middot; ")
              ui.link{
                content = function()
                  slot.put(_"Remove initiator")
                end,
                module = "initiative",
                view = "remove_initiator",
                params = { initiative_id = initiative.id }
              }
            end
          end
          if initiator and initiator.accepted == false then
              slot.put(" &middot; ")
              ui.link{
                text   = _"Cancel refuse of invitation",
                module = "initiative",
                action = "remove_initiator",
                params = {
                  initiative_id = initiative.id,
                  member_id = app.session.member.id
                },
                routing = {
                  ok = {
                    mode = "redirect",
                    module = "initiative",
                    view = "show",
                    id = initiative.id
                  }
                }
              }
          end
          if (initiative.discussion_url and #initiative.discussion_url > 0) then
            slot.put(" &middot; ")
            if initiative.discussion_url:find("^https?://") then
              if initiative.discussion_url and #initiative.discussion_url > 0 then
                ui.link{
                  attr = {
                    target = "_blank",
                    title = _"Discussion with initiators"
                  },
                  text = _"Discuss with initiators",
                  external = initiative.discussion_url
                }
              end
            else
              slot.put(encode.html(initiative.discussion_url))
            end
          end
          if initiator and initiator.accepted and not initiative.issue.half_frozen and not initiative.issue.closed and not initiative.revoked then
            slot.put(" &middot; ")
            ui.link{
              text   = _"change discussion URL",
              module = "initiative",
              view   = "edit",
              id     = initiative.id
            }
            slot.put(" ")
          end
        end
      }
    end }
  end
ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span12 well-inside paper spaceline"}, content=function()

  local supporter

  if app.session.member_id then
    supporter = app.session.member:get_reference_selector("supporters")
      :add_where{ "initiative_id = ?", initiative.id }
      :optional_object_mode()
      :exec()
  end

  if supporter and not initiative.issue.closed then
    local old_draft_id = supporter.draft_id
    local new_draft_id = initiative.current_draft.id
    if old_draft_id ~= new_draft_id then
      ui.container{
        attr = { class = "draft_updated_info" },
        content = function()
          slot.put(_"The draft of this initiative has been updated!")
          slot.put(" ")
          ui.link{
            content = _"Show diff",
            module = "draft",
            view = "diff",
            params = {
              old_draft_id = old_draft_id,
              new_draft_id = new_draft_id
            }
          }
          if not initiative.revoked then
            slot.put(" ")
            ui.link{
              text   = _"Refresh support to current draft",
              module = "initiative",
              action = "add_support",
              id     = initiative.id,
              routing = {
                default = {
                  mode = "redirect",
                  module = "initiative",
                  view = "show",
                  id = initiative.id
                }
              }
            }
          end
        end
      }
    end
  end

  if not show_as_head then
    local drafts_count = initiative:get_reference_selector("drafts"):count()

    ui.container{ attr = { class = "row-fluid" }, content = function()
    
      if initiator and initiator.accepted and not initiative.issue.half_frozen and not initiative.issue.closed and not initiative.revoked then
        ui.link{               attr = { class = "label label-warning" },
          content = function()
            slot.put(_"Edit draft")
          end,
          module = "draft",
          view = "new",
          params = { initiative_id = initiative.id }
        }
        slot.put(" &middot; ")
        ui.link{
          content = function()
            slot.put(_"Revoke initiative")
          end,
          module = "initiative",
          view = "revoke",
          id = initiative.id
        }
        slot.put(" &middot; ")
      end
    end }
      ui.tag{
        attr = { class = "" },
        content = _("Latest draft created at #{date} #{time}", {
          date = format.date(initiative.current_draft.created),
          time = format.time(initiative.current_draft.created)
        })
      }
      if drafts_count > 1 then
        slot.put(" &middot; ")
        ui.link{
          module = "draft", view = "list", params = { initiative_id = initiative.id },
          text = _("List all revisions (#{count})", { count = drafts_count })
        }
      end


    execute.view{
      module = "draft",
      view = "_show",
      params = {
        draft = initiative.current_draft
      }
    }
  end
end }
  end }
end }
end }
     ui.container{ attr = { class = "row-fluid spaceline"}, content = function()
      ui.container{ attr = { class = "span12 well"}, content = function()
       ui.container{ attr = { class = "row-fluid"}, content = function()
       ui.container{ attr = { class = "span8 offset2 text-center label label-warning"}, content = function()     

ui.heading{ level=1, content = "ALLEGATI ALLA PROPOSTA" }
end }
end }
       ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
        ui.container{ attr = { class = "span12  well-inside paper "}, content = function()
       ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
        ui.container{ attr = { class = "span6 text-center"}, content = function() 
           ui.image{static="png/video-player.png"}

end }

        ui.container{ attr = { class = "span6 spaceline3"}, content = function() 
             ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
        ui.container{ attr = { class = "span1 offset2 "}, content = function()      

ui.image{static="png/documentation.png"}
end }
        ui.container{ attr = { class = "span8"}, content = function()      

ui.heading{ level=1, content = "DOCUMENTAZIONE" }
end }
end }
             ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
        ui.container{ attr = { class = "span1 offset2"}, content = function()      

ui.image{static="png/images.png"}
end }
        ui.container{ attr = { class = "span8"}, content = function()      

ui.heading{ level=1, content = "IMMAGINI" }
end }
end }
ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
        ui.container{ attr = { class = "span1 offset2"}, content = function()      

ui.image{static="png/hyperlink.png"}
end }
        ui.container{ attr = { class = "span8"}, content = function()      

ui.heading{ level=1, content = "LINK" }
end }
end }
end }
end }
end }
end }
end }
end }
     ui.container{ attr = { class = "row-fluid spaceline"}, content = function()
      ui.container{ attr = { class = "span12 well"}, content = function()
       ui.container{ attr = { class = "row-fluid spaceline"}, content = function()
       ui.container{ attr = { class = "span8 offset2 text-center label label-warning"}, content = function()     

ui.heading{ level=1, content = "Questa proposta è in risposta alla questione:" }
end }
end }
       

ui.container{attr={class="row-fluid spaceline2"}, content=function()
  ui.container{attr={class="span7"}, content=function()
        execute.view{ module = "issue", view = "info_box", params = {issue=issue}  }
      end }
    end }
     ui.container{ attr = { class = "row-fluid"}, content = function()
     ui.container{ attr = { class = "span12 well-inside paper"}, content = function()
       ui.container{ attr = { class = "row-fluid spaceline"}, content = function()
            local issue_id = issue.id
	    local title = issue.title
	    local policy_name = Policy:by_id(issue.policy_id).name       

ui.container{ attr = { class = "span12"}, content = function()
		ui.heading { level=1, attr = { class = "text-center"},
		content = title
	}		
end }
end }
       ui.container{ attr = { class = "row-fluid spaceline"}, content = function()
            local issue_id = issue.id
	    local created = issue.created
	    local policy_name = Policy:by_id(issue.policy_id).name 
ui.container{ attr = { class = "span12"}, content = function()
ui.field.text { content = "Creata il", value = created }

end }
end }
       ui.container{ attr = { class = "row-fluid spaceline"}, content = function()	    
            local issue_id = issue.id
            local brief_description = issue.brief_description
	    local policy_name = Policy:by_id(issue.policy_id).name 
ui.container{ attr = { class = "span12"}, content = function()
ui.field.text{
		value = brief_description
	}
end }
end }
end }
end }

       ui.container{ attr = { class = "row-fluid spaceline"}, content = function()
     ui.container{ attr = { class = "span12"}, content = function()

          ui.link { 
            attr = { id = "issue_see_det_"..issue.id, class = "span4 offset4 text-center" },
            module = "issue",
            view = "show_ext_bs",
            id = issue.id,
            params = { 
              view="area",
              state = state,
              orderby = orderby,
              desc = desc,
              interest = interest,
              scope = scope,
              view = view,
              ftl_btns = ftl_btns
            },
            content = function()
              ui.heading{ level=3,attr = {class="btn btn-primary large_btn"}, content=_"SEE DETAILS"}
          end }

end }
end }

end }
end }
ui.container{ attr = { class = "row-fluid spaceline"}, content = function()
            execute.view{
              module = "committee",
              view   = "view",
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

    ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
      ui.container{ attr = { class = "span7"}, content = function()
        ui.heading{ level=3, attr = { class = "uppercase label label-warning" }, content = function()
          ui.tag{content= _"By user:" }
        end }
      end }
    end }
    ui.container{ attr = { class = "row-fluid"}, content = function()
      ui.container{ attr = { class = "span12 well"}, content = function()
        if issue.member_id and issue.member_id > 0 then
          execute.view{ module="member", view="_info_data", id=issue.member_id }
        else
          ui.heading{ level=6, content = _"No author for this issue" }
        end
		       end }
		      end }
		     end }
  		    end }
		   end }


ui.script{static = "js/jquery.quorum_bar.js"}
ui.script{script = "jQuery('#quorum_box').quorum_bar(); " }

