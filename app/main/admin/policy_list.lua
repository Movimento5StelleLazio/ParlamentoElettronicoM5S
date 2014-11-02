slot.set_layout("custom")

local show_not_in_use = param.get("show_not_in_use", atom.boolean) or false

local policies = Policy:build_selector { active = not show_not_in_use }:exec()

ui.title(function()
    ui.container {
        attr = { class = "row-fluid text-left" },
        content = function()
            ui.container {
                attr = { class = "span3" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-large large_btn fixclick btn-back" },
                        module = "admin",
                        view = "index",
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            ui.tag {
                tag = "strong",
                attr = { class = "span9 text-center" },
                content = _ "Policy list"
            }
        end
    }
end)
ui.actions(function()
    ui.container {
        attr = { class = "row-fluid spaceline2" },
        content = function()
            if show_not_in_use then
                ui.link {
                    text = _ "Show policies in use",
                    module = "admin",
                    view = "policy_list",
                    attr = { class = "offset4 span2 btn btn-primary text-center" }
                }

            else
                ui.link {
                    text = _ "Create new policy",
                    module = "admin",
                    view = "policy_show",
                    attr = { class = "offset4 span2 btn btn-primary text-center" }
                }
                ui.link {
                    text = _ "Show policies not in use",
                    module = "admin",
                    view = "policy_list",
                    attr = { class = "offset1 span2 btn btn-primary text-center" },
                    params = { show_not_in_use = true }
                }
            end
        end
    }
end)


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
