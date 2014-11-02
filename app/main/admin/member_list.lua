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
                content = _ "Member list"
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
    order = "identification"
}

ui.paginate {
    selector = members_selector,
    per_page = 30,
    content = function()
        ui.list {
            records = members_selector:exec(),
            columns = {
                {
                    field_attr = { style = "text-align: right;" },
                    label = _ "Id",
                    name = "id"
                },
                {
                    label = _ "Identification",
                    name = "identification"
                },
                {
                    label = _ "Screen name",
                    name = "name"
                },
                {
                    label = _ "Admin?",
                    content = function(record)
                        if record.admin then
                            ui.field.text { value = "admin" }
                        end
                    end
                },
                {
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
                    content = function(record)
                        if record.locked then
                            ui.field.text { value = "locked" }
                        end
                    end
                },
                {
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
