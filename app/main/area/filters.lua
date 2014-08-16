local area = Area:by_id(param.get_id())

if not area then
    slot.put_into("error", "Please provide a valid area id")
    return false
end

app.html_title.title = area.name
app.html_title.subtitle = _("Area")

util.help("area.show")

ui.container {
    attr = { class = "area_filter_header_box" },
    content = function()
        ui.tag { tag = "p", attr = { id = "unit_title", class = "welcome_text_l" }, content = _("#{realname}, you are now in the Regione Lazio Assembly", { realname = app.session.member.realname }) }
        ui.tag { tag = "p", attr = { class = "welcome_text_xl" }, content = _ "CHOOSE THE CITIZENS INITIATIVES YOU WANT TO READ:" }
        ui.link {
            attr = { class = "area_filter_button button orange" },
            module = "unit",
            view = "show_ext",
            id = area.unit_id,
            content = function()
                ui.image { attr = { id = "unit_arrow_back" }, static = "arrow_left.png" }
                ui.tag { tag = "p", attr = { class = "button_text" }, content = _ "BACK TO PREVIOUS PAGE" }
            end
        }
        if not app.session.member.elected then
            ui.link {
                attr = { class = "area_filter_button button orange" },
                module = "area",
                view = "show_ext",
                params = { state = "admission" },
                id = area.id,
                content = function()
                    ui.tag { tag = "p", attr = { class = "button_text" }, content = _ "INITIATIVES LOOKING FOR SUPPORTERS" }
                end
            }
        end
        ui.link {
            attr = { class = "area_filter_button button orange" },
            module = "area",
            view = "show_ext",
            params = { state = "development" },
            id = area.id,
            content = function()
                ui.tag { tag = "p", attr = { class = "button_text" }, content = _ "INITIATIVES NOW IN DISCUSSION" }
            end
        }
        ui.link {
            attr = { class = "area_filter_button button orange" },
            module = "area",
            view = "show_ext",
            params = { state = "closed" },
            id = area.id,
            content = function()
                ui.tag { tag = "p", attr = { class = "button_text" }, content = _ "COMPLETED OR RETIRED INITIATIVES" }
            end
        }
        slot.put("<br />")
    end
}
