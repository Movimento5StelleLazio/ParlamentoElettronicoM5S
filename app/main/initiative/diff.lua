slot.set_layout("custom")

local first_initiative_id = param.get("first_initiative_id", atom.integer)
local second_initiative_id = param.get("second_initiative_id", atom.integer)

if not first_initiative_id or not second_initiative_id then
    slot.put(_ "Please choose two versions of the draft to compare")
    return
end

if first_initiative_id == second_initiative_id then
    slot.put(_ "Please choose two different versions of the draft to compare")
    return
end

if first_initiative_id > second_initiative_id then
    local tmp = first_initiative_id
    first_initiative_id = second_initiative_id
    second_initiative_id = tmp
end

local first_initiative = Initiative:by_id(first_initiative_id).current_draft
local second_initiative = Initiative:by_id(second_initiative_id).current_draft

ui.title(function()
    ui.container {
        attr = { class = "row" },
        content = function()
            ui.container {
                attr = { class = "col-md-3 text-left" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-large large_btn fixclick btn-back" },
                        module = "initiative",
                        view = "compare",
                        params = { issue_id = param.get_id() },
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            ui.container {
                attr = { class = "col-md-8 text-center spaceline2 label label-warning fittext1" },
                content = function()
                    ui.heading {
                        level = 1,
                        content = _ "Initiatives diff"
                    }
                end
            }
            ui.container {
                attr = { class = "col-md-1 text-center spaceline" },
                content = function()
                    ui.field.popover {
                        attr = {
                            dataplacement = "left",
                            datahtml = "true";
                            datatitle = _ "Box di aiuto per la pagina",
                            datacontent = _ "Ti trovi nel box che mostra le differenze tra le due proposte selezionate.",
                            datahtml = "true",
                            class = "text-center"
                        },
                        content = function()
                            ui.container {
                                attr = { class = "row" },
                                content = function()
                                    ui.image { attr = { class = "icon-medium" },static = "png/tutor.png" }
                                --								    ui.heading{level=3 , content= _"What you want to do?"}
                                end
                            }
                        end
                    }
                end
            }
        end
    }
end)

--if app.session.member_id and not second_initiative.initiative.revoked then
--    local supporter = Supporter:new_selector():add_where { "member_id = ?", app.session.member_id }:count()
--    if supporter then
--        ui.container {
--            attr = { class = "draft_updated_info" },
--            content = function()
--                slot.put(_ "The draft of this initiative has been updated!")
--                slot.put(" ")
--                ui.link {
--                    text = _ "Refresh support to current draft",
--                    module = "initiative",
--                    action = "add_support",
--                    id = second_initiative.initiative.id,
--                    routing = {
--                        default = {
--                            mode = "redirect",
--                            module = "initiative",
--                            view = "show",
--                            id = second_initiative.initiative.id
--                        }
--                    }
--                }
--            end
--        }
--    end
--end

local first_initiative_content = string.gsub(string.gsub(first_initiative.content, "\n", " ###ENTER###\n"), " ", "\n")
local second_initiative_content = string.gsub(string.gsub(second_initiative.content, "\n", " ###ENTER###\n"), " ", "\n")

local key = multirand.string(26, "123456789bcdfghjklmnpqrstvwxyz");

local first_initiative_filename = encode.file_path(request.get_app_basepath(), 'tmp', "diff-" .. key .. "-old.tmp")
local second_initiative_filename = encode.file_path(request.get_app_basepath(), 'tmp', "diff-" .. key .. "-new.tmp")

local first_initiative_file = assert(io.open(first_initiative_filename, "w"))
first_initiative_file:write(first_initiative_content)
first_initiative_file:write("\n")
first_initiative_file:close()

local second_initiative_file = assert(io.open(second_initiative_filename, "w"))
second_initiative_file:write(second_initiative_content)
second_initiative_file:write("\n")
second_initiative_file:close()

local output, err, status = extos.pfilter(nil, "sh", "-c", "diff -U 1000000000 '" .. first_initiative_filename .. "' '" .. second_initiative_filename .. "' | grep -v ^--- | grep -v ^+++ | grep -v ^@")

os.remove(first_initiative_filename)
os.remove(second_initiative_filename)

local last_state = "first_run"

local function process_line(line)
    local state_char = string.sub(line, 1, 1)
    local state
    if state_char == "+" then
        state = "added"
    elseif state_char == "-" then
        state = "removed"
    elseif state_char == " " then
        state = "unchanged"
    end
    local state_changed = false
    if state ~= last_state then
        if last_state ~= "first_run" then
            slot.put("</span> ")
        end
        last_state = state
        state_changed = true
        slot.put("<span class=\"diff_" .. tostring(state) .. "\">")
    end

    line = string.sub(line, 2, #line)
    if line ~= "###ENTER###" then
        if not state_changed then
            slot.put(" ")
        end
        slot.put(encode.html(line))
    else
        slot.put("<br />")
    end
end

ui.container {
    attr = { class = "row" },
    content = function()
        ui.container {
            attr = { class = "col-md-3" },
            content = function()
                ui.heading { level = 3, attr = { class = "label label-warning" }, content = _ "Diff" }
            end
        }
    end
}
ui.container {
    attr = { class = "row" },
    content = function()
        if not status then
            ui.field.text { value = _ "The drafts do not differ" }
        else
            ui.container {
                tag = "div",
                attr = { class = "col-md-12 well-inside paper" },
                content = function()
                    output = output:gsub("[^\n\r]+", function(line)
                        process_line(line)
                    end)
                end
            }
        end
    end
}

