slot.set_layout("custom")

local search = param.get("search")

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
                content = _ "Member list" .. ": " .. tostring((db:query("SELECT total_count FROM member_count")[1]).total_count)
            }
        end
    }
end)

ui.form {
    module = "admin",
    view = "member_list",
    content = function()
        ui.field.text { label = _ "Search for members", name = "search" }

        ui.submit { value = _ "Start search" }
    end
}

if not search then
    return
end

local members_selector = Member:build_selector {
    admin_search = search,
    order = "id DESC"
}

ui.paginate {
    selector = members_selector,
    per_page = 30,
    content = function()
        ui.list {
            records = members_selector:exec(),
            columns = {
                {
                    field_attr = { style = "text-align: center; padding:0px 10px 0px 10px" },
                    label = _ "Id",
                    name = "id"
                },
                {
                    field_attr = { style = "text-align: center; padding:0px 10px 0px 10px" },
                    label = _ "Identification",
                    name = "identification"
                },
                {
                    field_attr = { style = "text-align: center; padding:0px 10px 0px 10px" },
                    label = _ "Screen name",
                    name = "name"
                },
                {
                    field_attr = { style = "text-align: center; padding:0px 10px 0px 10px" },
                    label = _ "Admin?",
                    content = function(record)
                        if record.admin then
                            ui.field.text { value = "admin" }
                        end
                    end
                },
                {
                    field_attr = { style = "text-align: center; padding:0px 10px 0px 10px" },
                    content = function(record)
                        if not record.activated then
                            ui.field.text { value = "not activated" }
                        elseif not record.active then
                            ui.field.text { value = "inactive" }
                        else
                            ui.field.text { value = "active" }
                        end
                    end
                },
                {
                    field_attr = { style = "text-align: center; padding:0px 10px 0px 10px" },
                    content = function(record)
                        if record.locked then
                            ui.field.text { value = "locked" }
                        end
                    end
                },
                {
                    field_attr = { style = "text-align: center; padding:0px 10px 0px 10px" },
                    content = function(record)
                        ui.link {
                            attr = { class = "action admin_only" },
                            text = _ "Edit",
                            module = "admin",
                            view = "member_edit",
                            id = record.id
                        }
                    end
                }
            }
        }
    end
}
