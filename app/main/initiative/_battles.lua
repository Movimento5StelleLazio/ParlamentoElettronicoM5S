local initiative = param.get("initiative", "table")

if not initiative.issue.closed then
  return
end

local battled_initiatives = Initiative:new_selector()
  :add_field("winning_battle.count", "winning_count")
  :add_field("losing_battle.count", "losing_count")
  :join("battle", "winning_battle", { "winning_battle.winning_initiative_id = ? AND winning_battle.losing_initiative_id = initiative.id", initiative.id })
  :join("battle", "losing_battle", { "losing_battle.losing_initiative_id = ? AND losing_battle.winning_initiative_id = initiative.id", initiative.id })
  :add_order_by("rank")
  :exec()


local number_of_initiatives = Initiative:new_selector()
  :add_where{ "issue_id = ?", initiative.issue_id }
  :add_where("admitted")
  :count()

if number_of_initiatives > 1 then
  ui.list{
    records = battled_initiatives,
    columns = {
      {
        content = function()
          slot.put(_"This initiative")
        end
      },
      {
        content = function(record)
          local population = initiative.issue.voter_count
          local value = record.winning_count
          ui.bargraph{
            class = "bargraph bargraph50",
            max_value = population,
            width = 50,
            bars = {
              { color = "#aaa", value = population - value },
              { color = "#444", value = value },
            }
          }
        end
      },
      {
        content = function(record)
          slot.put(record.winning_count)
        end
      },
      {
        content = function(record)
          if record.winning_count == record.losing_count then
            ui.image{ static = "icons/16/bullet_blue.png" }
          elseif record.winning_count > record.losing_count then
            ui.image{ static = "icons/16/resultset_previous.png" }
          else
            ui.image{ static = "icons/16/resultset_next.png" }
          end
        end
      },
      {
        field_attr = { style = "text-align: right;" },
        content = function(record)
          slot.put(record.losing_count)
        end
      },
      {
        content = function(record)
          local population = initiative.issue.voter_count
          local value = record.losing_count
          ui.bargraph{
            class = "bargraph bargraph50",
            max_value = population,
            width = 50,
            bars = {
              { color = "#444", value = value },
              { color = "#aaa", value = population - value },
            }
          }
        end
      },
      {
        content = function(record)
          ui.link{
            module = "initiative",
            view = "show",
            id = record.id,
            text = record.name
          }
        end
      }
    }
  }
end
