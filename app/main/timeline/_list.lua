local timeline_selector = param.get("timeline_selector", "table")
local event_names = param.get("event_names", "table")
local initiatives_per_page = param.get("initiatives_per_page", atom.number) or 3


-- test if selector is valid
local test_selector = timeline_selector:get_db_conn():new_selector()
test_selector:add_field('count(1)')
test_selector:add_from(timeline_selector)
test_selector:single_object_mode()

err, x = test_selector:try_exec()

if err then
  slot.put_into("error", _"Invalid query")
else
  ui.paginate{
    per_page = param.get("per_page", atom.number) or 25,
    selector = timeline_selector,
    container_attr = { class = "ui_paginate timeline_results" },
    content = function()
      local timelines = timeline_selector:exec()
      timelines:load("issue")
      timelines:load("initiative")
      timelines:load("member")
      ui.list{
        attr = { class = "nohover" },
        records = timelines,
        columns = {
          {
            field_attr = { style = "width: 10em;" },
            content = function(timeline)
              ui.field.text{
                attr = { style = "font-size: 75%; font-weight: bold; background-color: #ccc; display: block; margin-bottom: 1ex;"},
                value = format.time(timeline.occurrence)
              }

              ui.field.text{
                attr = { style = "font-size: 75%; font-weight: bold;"},
                value = event_names[timeline.event] or timeline.event
              }
              if timeline.event == "draft_created" and timeline.count > 1 then
                ui.field.text{
                  attr = { style = "font-size: 75%;"},
                  value = _("(#{more_count} duplicates removed)", { more_count = timeline.count - 1 })
                }
              end
            end
          },
          {
            content = function(timeline)
              local issue
              local initiative
              if timeline.issue then
                issue = timeline.issue
              elseif timeline.initiative then
                initiative = timeline.initiative
                issue = initiative.issue
              elseif timeline.draft then
                initiative = timeline.draft.initiative
                issue = initiative.issue
              elseif timeline.suggestion then
                initiative = timeline.suggestion.initiative
                issue = initiative.issue
              end
              if issue then
                if timeline.is_interested then
                  local label = _"You are interested in this issue",
                  ui.image{
                    attr = { alt = label, title = label, style = "float: left; margin-right: 0.5em;" },
                    static = "icons/16/eye.png"
                  }
                end
                slot.put(" ")
                ui.tag{
                  tag = "span",
                  attr = { style = "font-size: 75%; font-weight: bold; background-color: #ccc; display: block; margin-bottom: 1ex;"},
                  content = issue.area.name_with_unit_name .. ", " .. _("Issue ##{id}", { id = issue.id })
                }
              else
                ui.tag{
                  tag = "span",
                  attr = { style = "font-size: 75%; background-color: #ccc; display: block; margin-bottom: 1ex;"},
                  content = function() slot.put("&nbsp;") end
                }
              end

              if timeline.member then
                execute.view{
                  module = "member_image",
                  view = "_show",
                  params = {
                    member = timeline.member,
                    image_type = "avatar",
                    show_dummy = true
                  }
                }
                ui.link{
                  content = timeline.member.name,
                  module = "member",
                  view = "show",
                  id = timeline.member.id
                }
              end
              if timeline.issue then
                local initiatives_selector = timeline.issue
                  :get_reference_selector("initiatives")
                execute.view{
                  module = "initiative",
                  view = "_list",
                  params = {
                    issue = timeline.issue,
                    initiatives_selector = initiatives_selector,
                    per_page = initiatives_per_page,
                    no_sort = true,
                    limit = initiatives_per_page
                  }
                }
              elseif initiative then
                execute.view{
                  module = "initiative",
                  view = "_list",
                  params = {
                    issue = initiative.issue,
                    initiatives_selector = Initiative:new_selector():add_where{ "initiative.id = ?", initiative.id },
                    per_page = initiatives_per_page,
                    no_sort = true
                  }
                }
              end
              if timeline.suggestion then
                ui.link{
                  module = "suggestion",
                  view = "show",
                  id = timeline.suggestion.id,
                  content = timeline.suggestion.name
                }
              end
            end
          },
        }
      }
    end
  }
end
