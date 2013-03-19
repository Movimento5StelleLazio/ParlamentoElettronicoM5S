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

app.html_title.title = initiative.name
app.html_title.subtitle = _("Initiative ##{id}", { id = initiative.id })

slot.select("head", function()
  execute.view{
    module = "issue", view = "_head",
    params = { issue = issue, initiative = initiative }
  }
end)
  
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
slot.select("head", function()
  execute.view{
    module = "issue",
    view = "_show",
    params = {
      issue = initiative.issue,
      initiative_limit = 3,
      for_initiative = initiative
    }
  }
end)

util.help("initiative.show")

local class = "initiative_head"

if initiative.polling then
  class = class .. " polling"
end

ui.container{ attr = { class = class }, content = function()

  local text = _("Initiative i#{id}: #{name}", { id = initiative.id, name = initiative.name }) 
  if show_as_head then
    ui.link{
      attr = { class = "title" }, text = text,
      module = "initiative", view = "show", id = initiative.id
    }
  else
    ui.container{ attr = { class = "title" }, content = text }
  end
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

  if app.session.member_id then
    ui.container{ attr = { class = "content" }, content = function()
      execute.view{
        module = "supporter",
        view = "_show_box",
        params = {
          initiative = initiative
        }
      }
    end }
  end

  
  -- voting results
  if initiative.issue.fully_frozen and initiative.issue.closed and initiative.admitted then
    local class = initiative.winner and "admitted_info" or "not_admitted_info"
    ui.container{
      attr = { class = class },
      content = function()
        local max_value = initiative.issue.voter_count
        slot.put("&nbsp;")
        local positive_votes = initiative.positive_votes
        local negative_votes = initiative.negative_votes
        local sum_votes = initiative.positive_votes + initiative.negative_votes
        local function perc(votes, sum)
          if sum > 0 and votes > 0 then return " (" .. string.format( "%.f", votes * 100 / sum ) .. "%)" end
          return ""
        end
        slot.put(_"Yes" .. ": <b>" .. tostring(positive_votes) .. perc(positive_votes, sum_votes) .. "</b>")
        slot.put(" &middot; ")
        slot.put(_"Abstention" .. ": <b>" .. tostring(max_value - initiative.negative_votes - initiative.positive_votes)  .. "</b>")
        slot.put(" &middot; ")
        slot.put(_"No" .. ": <b>" .. tostring(initiative.negative_votes) .. perc(negative_votes, sum_votes) .. "</b>")
        slot.put(" &middot; ")
        slot.put("<b>")
        if initiative.winner then
          slot.put(_"Approved")
        elseif initiative.rank then
          slot.put(_("Not approved (rank #{rank})", { rank = initiative.rank }))
        else
          slot.put(_"Not approved")
        end
        slot.put("</b>")
      end
    }
  end

  ui.container{ attr = { class = "content" }, content = function()
    execute.view{
      module = "initiative",
      view = "_battles",
      params = { initiative = initiative }
    }
  end }
    
  -- initiative not admitted info
  if initiative.admitted == false then
    local policy = initiative.issue.policy
    ui.container{
      attr = { class = "not_admitted_info" },
      content = _("This initiative has not been admitted! It failed the quorum of #{quorum}.", { quorum = format.percentage(policy.initiative_quorum_num / policy.initiative_quorum_den) })
    }
  end

  -- initiative revoked info
  if initiative.revoked then
    ui.container{
      attr = { class = "revoked_info" },
      content = function()
        slot.put(_("This initiative has been revoked at #{revoked}", { revoked = format.timestamp(initiative.revoked) }))
        local suggested_initiative = initiative.suggested_initiative
        if suggested_initiative then
          slot.put("<br /><br />")
          slot.put(_("The initiators suggest to support the following initiative:"))
          slot.put(" ")
          ui.link{
            content = _("Issue ##{id}", { id = suggested_initiative.issue.id } ) .. ": " .. encode.html(suggested_initiative.name),
            module = "initiative",
            view = "show",
            id = suggested_initiative.id
          }
        end
      end
    }
  end


  -- invited as initiator
  if initiator and initiator.accepted == nil and not initiative.issue.half_frozen and not initiative.issue.closed then
    ui.container{
      attr = { class = "initiator_invite_info" },
      content = function()
        slot.put(_"You are invited to become initiator of this initiative.")
        slot.put(" ")
        ui.link{
          image  = { static = "icons/16/tick.png" },
          text   = _"Accept invitation",
          module = "initiative",
          action = "accept_invitation",
          id     = initiative.id,
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
        slot.put(" ")
        ui.link{
          image  = { static = "icons/16/cross.png" },
          text   = _"Refuse invitation",
          module = "initiative",
          action = "reject_initiator_invitation",
          params = {
            initiative_id = initiative.id,
            member_id = app.session.member.id
          },
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
    }
  end

  -- draft updated
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

    ui.container{ attr = { class = "content" }, content = function()
    
      if initiator and initiator.accepted and not initiative.issue.half_frozen and not initiative.issue.closed and not initiative.revoked then
        ui.link{
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

      ui.tag{
        attr = { class = "draft_version" },
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
    end }

    execute.view{
      module = "draft",
      view = "_show",
      params = {
        draft = initiative.current_draft
      }
    }
  end
end }

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