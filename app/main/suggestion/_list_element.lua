
local initiative = param.get("initiative", "table")
local suggestions_selector = param.get("suggestions_selector", "table")

suggestions_selector:add_order_by("plus2_unfulfilled_count + plus1_unfulfilled_count DESC, id")

local tab_id = param.get("tab_id")
local show_name = param.get("show_name", atom.boolean)
if show_name == nil then
  show_name = true
end
local show_filter = param.get("show_filter", atom.boolean)
if show_filter == nil then
  show_filter = true
end

local partial = {
  routing = {
    default = {
      mode = "redirect",
      module = "initiative",
      view = "show_tab",
      params = {
        initiative_id = initiative.id,
        tab = "suggestions",
        tab_id = tab_id
      },
    }
  }
}

local ui_filters = ui.filters
if true or not show_filter then
  ui_filters = function(args) args.content() end
end

ui.container{ attr = { class = "box" },
  content = function()
    ui.paginate{
      selector = suggestions_selector,
      content = function()
        ui.list{
          attr = { style = "table-layout: fixed;" },
          records = suggestions_selector:exec(),
          columns = {
            {
              label = show_name and _"Suggestion" or nil,
              content = function(record)
                if show_name then
                  ui.link{
                    text = record.name,
                    module = "suggestion",
                    view = "show",
                    id = record.id
                  }
                end
              end
            },
            {
              label = _"Collective opinion of supporters",
              label_attr = { style = "width: 101px;" },
              content = function(record)
                if record.minus2_unfulfilled_count then
                  local max_value = record.initiative.supporter_count
                  ui.bargraph{
                    max_value = max_value,
                    width = 100,
                    bars = {
                      { color = "#0a0", value = record.plus2_unfulfilled_count + record.plus2_fulfilled_count },
                      { color = "#8f8", value = record.plus1_unfulfilled_count + record.plus1_fulfilled_count },
                      { color = "#eee", value = max_value - record.minus2_unfulfilled_count - record.minus1_unfulfilled_count - record.minus2_fulfilled_count - record.minus1_fulfilled_count - record.plus1_unfulfilled_count - record.plus2_unfulfilled_count - record.plus1_fulfilled_count - record.plus2_fulfilled_count},
                      { color = "#f88", value = record.minus1_unfulfilled_count + record.minus1_fulfilled_count },
                      { color = "#a00", value = record.minus2_unfulfilled_count + record.minus2_fulfilled_count },
                    }
                  }
                end
              end
            },
            {
              label = _"My opinion",
              label_attr = { style = "width: 130px; font-style: italic;" },
              content = function(record)
                local degree
                local opinion
                if app.session.member_id then
                  opinion = Opinion:by_pk(app.session.member.id, record.id)
                end
                if opinion then
                  degree = opinion.degree
                end
                ui.container{
                  attr = { class = "suggestion_my_opinion" },
                  content = function()
                    local has_voting_right = app.session.member and app.session.member:has_voting_right_for_unit_id(initiative.issue.area.unit_id)
                    if app.session.member_id and has_voting_right then
                      if initiative.issue.state == "voting" or initiative.issue.state == "closed" then
                        if degree == -2 then
                          ui.tag{
                            tag = "span",
                            attr = {
                              class = "action" .. (degree == -2 and " active_red2" or "")
                            },
                            content = _"must not"
                          }
                        end
                        if degree == -1 then
                          ui.tag{
                            tag = "span",
                            attr = { class = "action" .. (degree == -1 and " active_red1" or "") },
                            content = _"should not"
                          }
                        end
                        if degree == nil then
                          ui.tag{
                            tag = "span",
                            attr = { class = "action" .. (degree == nil and " active" or "") },
                            content = _"neutral"
                          }
                        end
                        if degree == 1 then
                          ui.tag{
                            tag = "span",
                            attr = { class = "action" .. (degree == 1 and " active_green1" or "") },
                            content = _"should"
                          }
                        end
                        if degree == 2 then
                          ui.tag{
                            tag = "span",
                            attr = { class = "action" .. (degree == 2 and " active_green2" or "") },
                            content = _"must"
                          }
                        end
                      else
                        -- we need to put initiative_id into the parameters to have a redirect target in case the suggestion is gone after the action
                        params = param.get_all_cgi()
                        params['initiative_id'] = initiative.id

                        ui.link{
                          attr = { class = "action" .. (degree == 2 and " active_green2" or "") },
                          text = _"must",
                          module = "opinion",
                          action = "update",
                          routing = { default = { mode = "redirect", module = request.get_module(), view = request.get_view(), id = param.get_id_cgi(), params = params } },
                          params = {
                            suggestion_id = record.id,
                            degree = 2
                          },
                          partial = partial
                        }
                        slot.put(" ")
                        ui.link{
                          attr = { class = "action" .. (degree == 1 and " active_green1" or "") },
                          text = _"should",
                          module = "opinion",
                          action = "update",
                          routing = { default = { mode = "redirect", module = request.get_module(), view = request.get_view(), id = param.get_id_cgi(), params = params} },
                          params = {
                            suggestion_id = record.id,
                            degree = 1
                          },
                          partial = partial
                        }
                        slot.put(" ")
                        ui.link{
                          attr = { class = "action" .. (degree == nil and " active" or "") },
                          text = _"neutral",
                          module = "opinion",
                          action = "update",
                          routing = { default = { mode = "redirect", module = request.get_module(), view = request.get_view(), id = param.get_id_cgi(), params = params } },
                          params = {
                            suggestion_id = record.id,
                            delete = true
                          },
                          partial = partial
                        }
                        slot.put(" ")
                        ui.link{
                          attr = { class = "action" .. (degree == -1 and " active_red1" or "") },
                          text = _"should not",
                          module = "opinion",
                          action = "update",
                          routing = { default = { mode = "redirect", module = request.get_module(), view = request.get_view(), id = param.get_id_cgi(), params = params } },
                          params = {
                            suggestion_id = record.id,
                            degree = -1
                          },
                          partial = partial
                        }
                        slot.put(" ")
                        ui.link{
                          attr = { class = "action" .. (degree == -2 and " active_red2" or "") },
                          text = _"must not",
                          module = "opinion",
                          action = "update",
                          routing = { default = { mode = "redirect", module = request.get_module(), view = request.get_view(), id = param.get_id_cgi(), params = params } },
                          params = {
                            suggestion_id = record.id,
                            degree = -2
                          },
                          partial = partial
                        }
                      end
                    elseif app.session.member_id then
                      ui.field.text{ value = _"[No voting privilege]" }
                    else
                      ui.field.text{ value = _"[Registered members only]" }
                    end
                  end
                }
              end
            },
            {
              label = _"Suggestion currently not implemented",
              label_attr = { style = "width: 101px;" },
              content = function(record)
                if record.minus2_unfulfilled_count then
                  local max_value = record.initiative.supporter_count
                  ui.bargraph{
                    max_value = max_value,
                    width = 100,
                    bars = {
                      { color = "#0a0", value = record.plus2_unfulfilled_count },
                      { color = "#8f8", value = record.plus1_unfulfilled_count },
                      { color = "#eee", value = max_value - record.minus2_unfulfilled_count - record.minus1_unfulfilled_count - record.plus1_unfulfilled_count - record.plus2_unfulfilled_count },
                      { color = "#f88", value = record.minus1_unfulfilled_count },
                      { color = "#a00", value = record.minus2_unfulfilled_count },
                    }
                  }
                end
              end
            },
            {
              label = _"Suggestion currently implemented",
              label_attr = { style = "width: 101px;" },
              content = function(record)
                if record.minus2_fulfilled_count then
                  local max_value = record.initiative.supporter_count
                  ui.bargraph{
                    max_value = max_value,
                    width = 100,
                    bars = {
                      { color = "#0a0", value = record.plus2_fulfilled_count },
                      { color = "#8f8", value = record.plus1_fulfilled_count },
                      { color = "#eee", value = max_value - record.minus2_fulfilled_count - record.minus1_fulfilled_count - record.plus1_fulfilled_count - record.plus2_fulfilled_count},
                      { color = "#f88", value = record.minus1_fulfilled_count },
                      { color = "#a00", value = record.minus2_fulfilled_count },
                    }
                  }
                end
              end
            },
            {
              label = app.session.member_id and _"I consider suggestion as" or nil,
              label_attr = { style = "width: 100px; font-style: italic;" },
              content = function(record)
                local degree
                local opinion
                if app.session.member_id then
                  opinion = Opinion:by_pk(app.session.member.id, record.id)
                end
                if opinion then
                  degree = opinion.degree
                end
                if opinion then

                  ui.link{
                    attr = { class = opinion.fulfilled and "action active" or "action" },
                    text = _"implemented",
                    module = "opinion",
                    action = "update",
                    routing = { default = { mode = "redirect", module = request.get_module(), view = request.get_view(), id = param.get_id_cgi(), params = param.get_all_cgi() } },
                    params = {
                      suggestion_id = record.id,
                      fulfilled = true
                    },
                    partial = partial
                  }
                  slot.put("<br />")
                  ui.link{
                    attr = { class = not opinion.fulfilled and "action active" or "action" },
                    text = _"not implemented",
                    module = "opinion",
                    action = "update",
                    routing = { default = { mode = "redirect", module = request.get_module(), view = request.get_view(), id = param.get_id_cgi(), params = param.get_all_cgi() } },
                    params = {
                      suggestion_id = record.id,
                      fulfilled = false
                    },
                    partial = partial
                  }

                end
              end
            },
            {
              label = app.session.member_id and _"So I'm" or nil,
              content = function(record)
                local opinion
                if app.session.member_id then
                  opinion = Opinion:by_pk(app.session.member.id, record.id)
                end
                if opinion then
                  if (opinion.fulfilled and opinion.degree > 0) or (not opinion.fulfilled and opinion.degree < 0) then
                    local title = _"satisfied"
                    ui.image{ attr = { alt = title, title = title }, static = "icons/emoticon_happy.png" }
                  elseif opinion.degree == 1 or opinion.degree == -1 then
                    local title = _"a bit unsatisfied"
                    ui.image{ attr = { alt = title, title = title }, static = "icons/emoticon_unhappy.png" }
                  else
                    local title = _"more unsatisfied"
                    ui.image{ attr = { alt = title, title = title }, static = "icons/emoticon_unhappy_red.png" }
                  end
                end
              end
            },
          }
        }
      end
    }
  end
}
