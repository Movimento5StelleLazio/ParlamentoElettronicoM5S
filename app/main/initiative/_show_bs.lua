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
trace.debug(url)
--url = string.gsub(url, ":", "\%3A")
--trace.debug(url)
url = encode.url{ base = request.get_absolute_baseurl(), module = "initiative", view = "show", params = { initiative_id = initiative.id } }
trace.debug(url)

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
              slot.put(_"Back to previous page")
            end }
          end }
              end }

      ui.container{ attr = { class  = "span8" }, content = function()
        ui.container{attr={class="row-fluid"}, content=function()
          ui.container{attr={class="span8 offset2 text-center label label-warning"}, content=function()
            ui.heading{level=1,attr={class="fittext1 uppercase"},content=_"Dettagli della Proposta N°"..initiative.id}
          end }
        end }
        ui.container{attr={class="row-fluid spaceline"}, content=function()
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
          
        ui.container { attr = { id="social_box", class="spaceline"}, content = function()
		      ui.container{ attr = { class  = "row-fluid"}, content = function()
		        ui.container{ attr = { class  = "offset3 span1" }, content = function()

		          slot.put('<div class="fb-like" data-href="'..url..'" data-width="100%" data-layout="box_count" data-action="like" data-show-faces="true" data-share="true"></div>')
		        end }
		        ui.container{ attr = { class  = "span1" }, content = function()
		        	local message 
		          slot.put('<a data-hashtags="parelon" data-url="'..url..'" href="https://twitter.com/share" class="twitter-share-button" data-text="'.. _"I found this initiative very interesting and I\'m supporting it! Please, help me with this: add yourself as supporter!" ..'" data-count="vertical" data-lang="it">Tweet</a>')
		        end }
		        ui.container{ attr={class="span1"},content=function()
		        	slot.put('<div class="g-plusone" data-size="tall"></div>')
		        end }
		        ui.container{ attr = {class="span1"}, content = function()
		        	slot.put('<a url="'..url..'" href="//it.pinterest.com/pin/create/button/" data-pin-do="buttonBookmark"  data-pin-height="28"><img src="//assets.pinterest.com/images/pidgets/pinit_fg_en_rect_gray_28.png" /></a>')
		        end }
		        ui.container{ attr={class="span1"}, content=function()
		        	slot.put('<script type="IN/Share" data-counter="top"></script>')
		        end }
		      end }
				end }
    
      end }     
            	    ui.container{attr={class="span1 text-center "},content=function()
					ui.field.popover{
							attr={
								dataplacement="left",
								datahtml = "true";
								datatitle= _"Box di aiuto per la pagina",
								datacontent=_"Ti trovi nei dettagli della QUESTIONE, con le informazioni integrali. Al box SOLUZIONI PROPOSTE puoi leggere la, o le PROPOSTE presentate per risolvere la QUESTIONE, o presentrare una tua PROPOSTA alternativa. ",
								datahtml = "true",
								class = "text-center"
							},
							content = function() 
								ui.container{
								  attr={class="row-fluid"},
									content=function()
				        		ui.image { static = "png/tutor.png"}                                                
--								    ui.heading{level=3 , content= _"What you want to do?"}
									end 
								}
						  end 
						}
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
          
            	    ui.container{attr={class="span1 offset1 text-center "},content=function()
					ui.field.popover{
							attr={
								dataplacement="left",
								datahtml = "true";
								datatitle= _"Box di aiuto per la pagina",
								datacontent=_"La barra delle fasi la trovi in testa alle questioni ed alle proposte, tienila d' occhio, in quanto ti avvisa quando puoi emendare o votare la proposta. ",
								datahtml = "true",
								class = "text-center"
							},
							content = function() 
								ui.container{
								  attr={class="row-fluid"},
									content=function()
				        		ui.image { static = "png/tutor.png"}                                                
--								    ui.heading{level=3 , content= _"What you want to do?"}
									end 
								}
						  end 
						}
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
              	    ui.container{attr={class="span1 text-center "},content=function()
					ui.field.popover{
							attr={
								dataplacement="left",
								datahtml = "true";
								datatitle= _"Box di aiuto per la pagina",
								datacontent=_"Puoi interessarti, sostenere, ignorare o proporre emendamenti alla proposta, dare il tuo interessa allarga la platea dei votanti e quindi in percentuale il quorum da raggiungere per permettere alla proposta di passare alla votazione, emendare la proposta ti permette di proporre modifiche parziali da sottoporre al giudizio dell'assemblea",
								datahtml = "true",
								class = "text-center"
							},
							content = function() 
								ui.container{
								  attr={class="row-fluid"},
									content=function()
				        		ui.image { static = "png/tutor.png"}                                                
--								    ui.heading{level=3 , content= _"What you want to do?"}
									end 
								}
						  end 
						}
						end }
  end }     
      ui.container{attr={class="row-fluid spaceline text-center"}, content=function()
      ui.container{attr={class="span12 well-inside paper"}, content=function()
       ui.container{attr={class="row-fluid spaceline text-center"}, content=function()
        ui.container{attr={class="span3 spaceline spaceline-bottom"}, content=function()
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


ui.container{attr={class="span3 spaceline spaceline-bottom"}, content=function()
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
local direct_voter
if app.session.member_id then
  direct_voter = issue.member_info.direct_voted
end

local voteable = app.session.member_id and issue.state == 'voting' and
       app.session.member:has_voting_right_for_unit_id(issue.area.unit_id)

local vote_comment_able = app.session.member_id and issue.closed and direct_voter

local vote_link_text
if voteable then 
  vote_link_text = direct_voter and _"Change vote" or _"Vote now"

ui.container{ attr = { class = "row-fluid spaceline2"}, content = function()
	ui.container{ attr = { class = "span12 well-inside paper"}, content = function()

		ui.container{ attr = { class = "span4 offset1 spaceline"}, content = function()
			ui.heading{ level=2, content= "Se la proposta è passata per la fase di votazione, clicca  sul pulsante per votare:"}
		end }
		ui.container{ attr = { class = "span2 spaceline"}, content = function()
			ui.image{ static="svg/arrow-right.svg"}
		end }
			
		ui.container{ attr = { class = "span5"}, content = function()
			ui.container{ attr = { class = "row-fluid spaceline-bottom"}, content = function()
				ui.link {        
					attr = { id = "issue_see_det_"..issue.id},
					module = "vote",
					view = "list",
					id = issue.id,
					params = {issue_id = issue.id },
					content = function()
					ui.container{ attr = { class = "span6  btn btn-primary "}, content = function()
						ui.container{ attr = { class = "row-fluid"}, content = function()
							ui.container{ attr = { class = "span6"}, content = function()
								ui.image{static="png/voting.png"}
							end }

							ui.container{ attr = { class = "span6 text-center spaceline"}, content = function()									
										ui.heading{ level=2, attr = { class = "spaceline"}, content=_"Vote now"}
								end }
							end }
						end }
					end }
				end }
		end }
	end }
end }
elseif vote_comment_able then
  vote_link_text = direct_voter and _"Update voting comment"
end 

--  if app.session:has_access("authors_pseudonymous") then
  --  ui.container{ attr = { class = "content" }, content = function()
  --  ui.tag{
--        attr = { class = "initiator_names" },
--        content = function()
 --         for i, initiator in ipairs(initiators) do
--            slot.put(" ")
--            if app.session:has_access("all_pseudonymous") then
--              ui.link{
--                content = function ()
--                  execute.view{
--                    module = "member_image",
--                    view = "_show",
--                    params = {
--                      member = initiator,
--                      image_type = "avatar",
--                      show_dummy = true,
--                      class = "micro_avatar",
--                      popup_text = text
--                    }
--                  }
--                end,
--                module = "member", view = "show", id = initiator.id
--              }
--              slot.put(" ")
--            end
--            ui.link{
--              text = initiator.name,
--              module = "member", view = "show", id = initiator.id
--            }
--            if not initiator.accepted then
--              ui.tag{ attr = { title = _"Not accepted yet" }, content = "?" }
--            end
--          end
--          if initiator and initiator.accepted and not initiative.issue.fully_frozen and not initiative.issue.closed and not initiative.revoked then
--            slot.put(" &middot; ")
--            ui.link{
--              attr = { class = "action" },
--              content = function()
--                slot.put(_"Invite initiator")
--              end,
--              module = "initiative",
--              view = "add_initiator",
--              params = { initiative_id = initiative.id }
--            }
--              slot.put(" &middot; ")
--              ui.link{
--                content = function()
 --                 slot.put(_"Remove initiator")
--                end,
--                module = "initiative",
--                view = "remove_initiator",
--                params = { initiative_id = initiative.id }
--              }
--            end
--          end
--          if initiator and initiator.accepted == false then
--              slot.put(" &middot; ")
--              ui.link{
--                text   = _"Cancel refuse of invitation",
--                module = "initiative",
--                action = "remove_initiator",
--                params = {
--                  initiative_id = initiative.id,
--                  member_id = app.session.member.id
--                },
--                routing = {
 --                 ok = {
 --                   mode = "redirect",
--                    module = "initiative",
--                    view = "show",
--                    id = initiative.id
--                  }
--                }
--              }
 --         end
--          if (initiative.discussion_url and #initiative.discussion_url > 0) then
--            slot.put(" &middot; ")
--            if initiative.discussion_url:find("^https?://") then
--              if initiative.discussion_url and #initiative.discussion_url > 0 then
--                  attr = {
--                    target = "_blank",
--                    title = _"Discussion with initiators"
--                  },
 --                 text = _"Discuss with initiators",
--                  external = initiative.discussion_url
--                }
--              end
--            else
 --             slot.put(encode.html(initiative.discussion_url))
--            end
--          end
--          if initiator and initiator.accepted and not initiative.issue.half_frozen and not initiative.issue.closed and not initiative.revoked then
 --           slot.put(" &middot; ")
--            ui.link{
 --             text   = _"change discussion URL",
--              module = "initiative",
--              view   = "edit",
--              id     = initiative.id
--            }
--            slot.put(" ")
--          end
--        end
--      }
--    end }
--  end
ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span12 well-inside paper spaceline"}, content=function()
ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span12 spaceline"}, content=function()
  		local initiative_id = initiative.id
	    local title = initiative.title
	    local policy_name = Policy:by_id(issue.policy_id).name 
	        
  
  end }
  end }
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
        ui.container{ attr = { class = "span5 offset7 text-right spaceline-bottom" }, content = function()
    
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
        ui.link{               attr = { class = "label label-warning" },
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
        end }
       ui.container{ attr = { class = "row-fluid spaceline-bottom" }, content = function() 
      ui.tag{tag="h3",
        content = _("Latest draft created at #{date} #{time}", {
          date = format.date(initiative.current_draft.created),
          time = format.time(initiative.current_draft.created)
        })
      }
      end }       
      ui.container{ attr = { class = "row-fluid spaceline"}, content = function()
       ui.container{ attr = { class = "span12"}, content = function()
      


		ui.heading { level=1, attr = { class = "text-center"},
		content = "LA PROPOSTA"
	}		
end }
end }
--[[      if drafts_count > 1 then
        slot.put(" &middot; ")
        ui.link{
          module = "draft", view = "list", params = { initiative_id = initiative.id },
          text = _("List all revisions (#{count})", { count = drafts_count })
        }
      end]]


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
           ui.container{       
          content = function()
          	local resource = Resource:by_initiative_id(initiative.id)
          	if resource and resource.url ~= "" then
          		if resource.url:gmatch("https://www.youtube.com/watch?v=") then
          			local code = resource.url:sub(resource.url:find("=")+1)
          			trace.debug("url: "..resource.url.."; code: "..code)
          			trace.debug(code)          			
            		slot.put('<iframe width=\"560\" height=\"315\" src=\"//www.youtube.com/embed/'..code..'\" frameborder=\"0\" allowfullscreen></iframe>')
            	else
            		trace.debug("url: "..resource.url)
            		slot.put('<iframe width="560" height="315" src="//www.youtube.com/embed/'..resource.url..'" frameborder="0" allowfullscreen></iframe>')
            	end
            else
            	ui.image{static = "png/video-player.png" }
            end

end }
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
      ui.container{ attr = { class = "span12 well-blue"}, content = function()
       ui.container{ attr = { class = "row-fluid spaceline"}, content = function()
       ui.container{ attr = { class = "span8 offset2 text-center label label-warning"}, content = function()     

ui.heading{ level=1, content = "Questa proposta è in risposta alla questione:" }
end }
end }
       

ui.container{attr={class="row-fluid spaceline2"}, content=function()
  ui.container{attr={class="span7 well-blue spaceline paper-green"}, content=function()
        execute.view{ module = "issue", view = "info_box", params = {issue=issue}  }
      end }
    end }
     ui.container{ attr = { class = "row-fluid"}, content = function()
     ui.container{ attr = { class = "span12 well-inside paper"}, content = function()

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
--[[ui.container{ attr = { class = "row-fluid spaceline"}, content = function()
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

end }]]

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
          execute.view{ module="member", view="_info_data", id=issue.member_id, params={ module = "initiative", view = "show", content_id = initiative.id} }
        else
          ui.heading{ level=6, content = _"No author for this issue" }
        end
		       end }
		      end }



--//  suggestion area


      ui.container{ attr = { class = "row-fluid"}, content = function()
            ui.container{ attr = { class = "span12 well"}, content = function()
					if not show_as_head then
						execute.view{
							module = "suggestion",
							view = "_list",
							params = {
								initiative = initiative,
								suggestions_selector = initiative:get_reference_selector("suggestions"),
								tab_id = param.get("tab_id")
							}
						}

						if app.session:has_access("all_pseudonymous") then
							if initiative.issue.fully_frozen and initiative.issue.closed then
								local members_selector = initiative.issue:get_reference_selector("direct_voters")
										  :left_join("vote", nil, { "vote.initiative_id = ? AND vote.member_id = member.id", initiative.id })
										  :add_field("direct_voter.weight as voter_weight")
										  :add_field("coalesce(vote.grade, 0) as grade")
										  :add_field("direct_voter.comment as voter_comment")
										  :left_join("initiative", nil, "initiative.id = vote.initiative_id")
										  :left_join("issue", nil, "issue.id = initiative.issue_id")
						
								ui.anchor{ name = "voter", attr = { class = "heading" }, content = _"Voters" }
						
								execute.view{
									module = "member",
									view = "_list",
									params = {
										initiative = initiative,
										for_votes = true,
										members_selector = members_selector,
										paginator_name = "voter"
									}
								}
							end
	 
							local members_selector = initiative:get_reference_selector("supporting_members_snapshot")
										    :join("issue", nil, "issue.id = direct_supporter_snapshot.issue_id")
										    :join("direct_interest_snapshot", nil, "direct_interest_snapshot.event = issue.latest_snapshot_event AND direct_interest_snapshot.issue_id = issue.id AND direct_interest_snapshot.member_id = member.id")
										    :add_field("direct_interest_snapshot.weight")
										    :add_where("direct_supporter_snapshot.event = issue.latest_snapshot_event")
										    :add_where("direct_supporter_snapshot.satisfied")
										    :add_field("direct_supporter_snapshot.informed", "is_informed")

							if members_selector:count() > 0 then
								if issue.fully_frozen then
									ui.anchor{ name = "supporters", attr = { class = "heading" }, content = _"Supporters (before begin of voting)" }
								else
									ui.anchor{ name = "supporters", attr = { class = "heading" }, content = _"Supporters" }
								end      
 
								execute.view{
									module = "member",
									view = "_list",
									params = {
										initiative = initiative,
										members_selector = members_selector,
										paginator_name = "supporters"
									}
							}
							else
								if issue.fully_frozen then
									ui.anchor{ name = "supporters", attr = { class = "heading" }, content = _"No supporters (before begin of voting)" }
								else
									ui.anchor{ name = "supporters", attr = { class = "heading" }, content = _"No supporters" }
								end						

								slot.put("<br />")
							end
 
							local members_selector = initiative:get_reference_selector("supporting_members_snapshot")
										    :join("issue", nil, "issue.id = direct_supporter_snapshot.issue_id")
										    :join("direct_interest_snapshot", nil, "direct_interest_snapshot.event = issue.latest_snapshot_event AND direct_interest_snapshot.issue_id = issue.id AND direct_interest_snapshot.member_id = member.id")
										    :add_field("direct_interest_snapshot.weight")
										    :add_where("direct_supporter_snapshot.event = issue.latest_snapshot_event")
										    :add_where("NOT direct_supporter_snapshot.satisfied")
										    :add_field("direct_supporter_snapshot.informed", "is_informed")

							if members_selector:count() > 0 then
								if issue.fully_frozen then
									ui.anchor{ name = "potential_supporters", attr = { class = "heading" }, content = _"Potential supporters (before begin of voting)" }
								else
									ui.anchor{ name = "potential_supporters", attr = { class = "heading" }, content = _"Potential supporters" }
								end
   
								execute.view{
									module = "member",
									view = "_list",
									params = {
										initiative = initiative,
										members_selector = members_selector,
										paginator_name = "potential_supporters"
									}
								}
							else
								if issue.fully_frozen then
									ui.anchor{ name = "potential_supporters", attr = { class = "heading" }, content = _"No potential supporters (before begin of voting)" }
								else
									ui.anchor{ name = "potential_supporters", attr = { class = "heading" }, content = _"No potential supporters" }
								end
								slot.put("<br />")
							end

							ui.container{ attr = { class = "heading" }, content = _"Details" }
							execute.view {
								module = "initiative",
								view = "_details",
								params = {
									initiative = initiative,
									members_selector = members_selector
								}
							}

						end
					end
				end }
								end }
						     end }
  		    end }
		   end }
					ui.script{static = "js/jquery.quorum_bar.js"}
					ui.script{script = "jQuery('#quorum_box').quorum_bar(); " }

