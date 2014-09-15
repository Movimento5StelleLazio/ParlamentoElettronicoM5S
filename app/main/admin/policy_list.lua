local show_not_in_use = param.get("show_not_in_use", atom.boolean) or false

local policies = Policy:build_selector { active = not show_not_in_use }:exec()


ui.title(_ "Policy list")


ui.actions(function()

    if show_not_in_use then
        ui.link {
            text = _ "Show policies in use",
            module = "admin",
            view = "policy_list"
        }

    else
        ui.link {
            text = _ "Create new policy",
            module = "admin",
            view = "policy_show"
        }
        slot.put(" &middot; ")
        ui.link {
            text = _ "Show policies not in use",
            module = "admin",
            view = "policy_list",
            params = { show_not_in_use = true }
        }
    end
end)

ui.container{ 
		attr = {class = "row-fluid well"},
		content = function()
			ui.container {
          attr = { class = "span3" },
          content = function()
              ui.link {
                  attr = { class = "btn btn-primary btn-large large_btn fixclick" },
                  module = "admin",
                  view = "index",
                  content = function()
                      ui.heading {
                          level = 3,
                          content = function()
                              ui.image { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" }
                              slot.put(_ "Back to previous page")
                          end
                      }
                  end
              }
          end
      }
  end
}
ui.list {
    records = policies,
    columns = {
        { label = _ "Policy", name = "name" },

        {
            content = function(record)
                ui.link {
                    text = _ "Edit",
                    module = "admin",
                    view = "policy_show",
                    id = record.id
                }
            end
        }
    }
}
