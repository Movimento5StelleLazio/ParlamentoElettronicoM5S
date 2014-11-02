slot.set_layout("custom")

if not app.session.member then
    slot.put_into("error", "You must be logged in before you can vote.")
    request.redirect {
        module = "index",
        view = "index"
    }
end

local issue = Issue:by_id(param.get("issue_id"), atom.integer)

local member_id = param.get("member_id", atom.integer)
local member
local readonly = false

local preview = param.get("preview", atom.boolean) and true or false
trace.debug("preview: " .. tostring(param.get("preview")))

if member_id then
    if not issue.closed then
        error("access denied")
    end
    member = Member:by_id(member_id)
    readonly = true
end

if issue.closed then
    if not member then
        member = app.session.member
    end
    readonly = true
end

local submit_button_text = _ "Finish voting"

if issue.closed then
    submit_button_text = _ "Update voting comment"
end

local direct_voter

if member then
    direct_voter = DirectVoter:by_pk(issue.id, member.id)
    local str = _("Ballot of '#{member_name}' for issue ##{issue_id}",
        {
            member_name = string.format('<a href="%s">%s</a>',
                encode.url {
                    module = "member",
                    view = "show",
                    id = member.id,
                },
                encode.html(member.name)),
            issue_id = string.format('<a href="%s">%s</a>',
                encode.url {
                    module = "issue",
                    view = "show_ext_bs",
                    id = issue.id,
                },
                encode.html(tostring(issue.id)))
        })
    ui.raw_title(str)
else
    member = app.session.member

    direct_voter = DirectVoter:by_pk(issue.id, member.id)

    ui.title(function()
        ui.container {
            attr = { class = "row-fluid spaceline" },
            content = function()
                ui.container {
                    attr = { class = "span8 offset2 label label-warning text-center" },
                    content = function()
                        ui.heading { level = 1, content = _ "You are voting for the issue:" }
                        local issue_id = issue.id
                        local title = issue.title
                        local policy_name = Policy:by_id(issue.policy_id).name
                        ui.heading { level = 3, content = title }
                    end
                }
                ui.container {
                    attr = { class = "span1 text-center " },
                    content = function()
                        ui.field.popover {
                            attr = {
                                dataplacement = "left",
                                datahtml = "true";
                                datatitle = _ "Box di aiuto per la pagina",
                                datacontent = _ "This is the vote box. You can: <i>go back</i>; <i>cast</i>, <i>modify</i> or <i>discard</i> your vote; <i>post</i> or <i>edit</i> a comment to your vote.",
                                datahtml = "true",
                                class = "text-center"
                            },
                            content = function()
                                ui.container {
                                    attr = { class = "row-fluid" },
                                    content = function()
                                        ui.image { static = "png/tutor.png" }
                                    end
                                }
                            end
                        }
                    end
                }
            end
        }
    end)

    ui.actions(function()
        ui.container {
            attr = { class = "row-fluid spaceline2" },
            content = function()
                ui.container {
                    attr = { class = "offset1 span10" },
                    content = function()
                        ui.container {
                            attr = { class = "row-fluid" },
                            content = function()
                                ui.link {
                                    attr = { class = "span3 btn btn-primary fixclick" },
                                    module = "issue",
                                    view = "show_ext_bs",
                                    id = issue.id,
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
                                ui.container {
                                    attr = { class = "offset2 span2" },
                                    content = function()
                                        ui.image { static = "png/voting.png" }
                                    end
                                }
                                if direct_voter then
                                    ui.link {
                                        attr = { class = "offset2 span3 btn btn-primary fixclick" },
                                        module = "vote",
                                        action = "update",
                                        params = {
                                            issue_id = issue.id,
                                            discard = true
                                        },
                                        routing = {
                                            default = {
                                                mode = "redirect",
                                                module = "issue",
                                                view = "show_ext_bs",
                                                id = issue.id
                                            }
                                        },
                                        content = function()
                                            ui.heading {
                                                level = 3,
                                                content = function()
                                                    ui.image { attr = { class = "" }, static = "png/delete.png" }
                                                    slot.put(_ "Discard voting")
                                                end
                                            }
                                        end
                                    }
                                end
                            end
                        }
                    end
                }
            end
        }
    end)
end

local tempvoting_string = param.get("scoring")

local tempvotings = {}
if tempvoting_string then
    for match in tempvoting_string:gmatch("([^;]+)") do
        for initiative_id, grade in match:gmatch("([^:;]+):([^:;]+)") do
            tempvotings[tonumber(initiative_id)] = tonumber(grade)
        end
    end
end

local initiatives = issue:get_reference_selector("initiatives"):add_where("initiative.admitted"):add_order_by("initiative.satisfied_supporter_count DESC"):exec()

local min_grade = -1;
local max_grade = 1;

for i, initiative in ipairs(initiatives) do
    -- TODO performance
    initiative.vote = Vote:by_pk(initiative.id, member.id)
    if tempvotings[initiative.id] then
        initiative.vote = {}
        initiative.vote.grade = tempvotings[initiative.id]
    end
    if initiative.vote then
        if initiative.vote.grade > max_grade then
            max_grade = initiative.vote.grade
        end
        if initiative.vote.grade < min_grade then
            min_grade = initiative.vote.grade
        end
    end
end

local sections = {}
for i = min_grade, max_grade do
    sections[i] = {}
    for j, initiative in ipairs(initiatives) do
        if (initiative.vote and initiative.vote.grade == i) or (not initiative.vote and i == 0) then
            sections[i][#(sections[i]) + 1] = initiative
        end
    end
end

local approval_count, disapproval_count = 0, 0
for i = min_grade, -1 do
    if #sections[i] > 0 then
        disapproval_count = disapproval_count + 1
    end
end
local approval_count = 0
for i = 1, max_grade do
    if #sections[i] > 0 then
        approval_count = approval_count + 1
    end
end

if not readonly then
    util.help("vote.list", _ "Voting")
    slot.put('<script src="' .. request.get_relative_baseurl() .. 'static/js/dragdrop.js"></script>')
    slot.put('<script src="' .. request.get_relative_baseurl() .. 'static/js/voting.js"></script>')
end

ui.script {
    script = function()
        slot.put("voting_text_approval_single               = ", encode.json(_ "Approval [single entry]"), ";\n",
            "voting_text_approval_multi                = ", encode.json(_ "Approval [many entries]"), ";\n",
            "voting_text_first_preference_single       = ", encode.json(_ "Approval (first preference) [single entry]"), ";\n",
            "voting_text_first_preference_multi        = ", encode.json(_ "Approval (first preference) [many entries]"), ";\n",
            "voting_text_second_preference_single      = ", encode.json(_ "Approval (second preference) [single entry]"), ";\n",
            "voting_text_second_preference_multi       = ", encode.json(_ "Approval (second preference) [many entries]"), ";\n",
            "voting_text_third_preference_single       = ", encode.json(_ "Approval (third preference) [single entry]"), ";\n",
            "voting_text_third_preference_multi        = ", encode.json(_ "Approval (third preference) [many entries]"), ";\n",
            "voting_text_numeric_preference_single     = ", encode.json(_ "Approval (#th preference) [single entry]"), ";\n",
            "voting_text_numeric_preference_multi      = ", encode.json(_ "Approval (#th preference) [many entries]"), ";\n",
            "voting_text_abstention_single             = ", encode.json(_ "Abstention [single entry]"), ";\n",
            "voting_text_abstention_multi              = ", encode.json(_ "Abstention [many entries]"), ";\n",
            "voting_text_disapproval_above_one_single  = ", encode.json(_ "Disapproval (prefer to lower block) [single entry]"), ";\n",
            "voting_text_disapproval_above_one_multi   = ", encode.json(_ "Disapproval (prefer to lower block) [many entries]"), ";\n",
            "voting_text_disapproval_above_many_single = ", encode.json(_ "Disapproval (prefer to lower blocks) [single entry]"), ";\n",
            "voting_text_disapproval_above_many_multi  = ", encode.json(_ "Disapproval (prefer to lower blocks) [many entries]"), ";\n",
            "voting_text_disapproval_above_last_single = ", encode.json(_ "Disapproval (prefer to last block) [single entry]"), ";\n",
            "voting_text_disapproval_above_last_multi  = ", encode.json(_ "Disapproval (prefer to last block) [many entries]"), ";\n",
            "voting_text_disapproval_single            = ", encode.json(_ "Disapproval [single entry]"), ";\n",
            "voting_text_disapproval_multi             = ", encode.json(_ "Disapproval [many entries]"), ";\n")
    end
}
ui.field.popover {
    attr = {
        dataplacement = "left",
        datahtml = "true";
        datatitle = _ "Box di aiuto per la pagina",
        datacontent = _ "Use arrows to order initiatives from the one you agree most to the one you disagree most.",
        datahtml = "true",
        div_attr = { class = "row-fluid" },
        class = "offset11 span1"
    },
    content = function()
    --        ui.container {
    --            attr = { class = "row-fluid" },
    --            content = function()
        ui.image { attr = { class = "" }, static = "png/tutor.png" }
    --            end
    --        }
    end
}
ui.container {
    attr = { class = "row-fluid" },
    content = function()
        ui.container {
            attr = { class = "span12 well-inside paper spaceline" },
            content = function()
                ui.form {
                    record = direct_voter,
                    attr = {
                        id = "voting_form",
                        class = readonly and "voting_form_readonly" or "voting_form_active"
                    },
                    module = "vote",
                    action = "update",
                    params = { issue_id = issue.id },
                    content = function()
                        if not readonly or preview then
                            local scoring = param.get("scoring")
                            if not scoring then
                                for i, initiative in ipairs(initiatives) do
                                    local vote = initiative.vote
                                    if vote then
                                        tempvotings[initiative.id] = vote.grade
                                    else
                                        tempvotings[initiative.id] = 0
                                    end
                                end
                                local tempvotings_list = {}
                                for key, val in pairs(tempvotings) do
                                    tempvotings_list[#tempvotings_list + 1] = tostring(key) .. ":" .. tostring(val)
                                end
                                if #tempvotings_list > 0 then
                                    scoring = table.concat(tempvotings_list, ";")
                                else
                                    scoring = ""
                                end
                            end

                            ui.tag {
                                tag = "input",
                                attr = {
                                    type = "hidden",
                                    name = "scoring",
                                    value = scoring
                                }
                            }
                            -- TODO abstrahieren
                            ui.container {
                                attr = { class = "row-fluid" },
                                content = function()
                                    ui.tag {
                                        tag = "input",
                                        attr = {
                                            type = "submit",
                                            class = "offset5 span2 voting_done1 btn btn-primary btn-large large_btn",
                                            value = submit_button_text
                                        }
                                    }
                                end
                            }
                        end
                        ui.container {
                            attr = { class = "row-fluid" },
                            content = function()
                                ui.container {
                                    attr = { class = "offset1 span10" },
                                    content = function()
                                        ui.container {
                                            attr = { id = "voting" },
                                            content = function()
                                                local approval_index, disapproval_index = 0, 0
                                                for grade = max_grade, min_grade, -1 do
                                                    local entries = sections[grade]
                                                    local class
                                                    if grade > 0 then
                                                        class = "approval"
                                                    elseif grade < 0 then
                                                        class = "disapproval"
                                                    else
                                                        class = "abstention"
                                                    end
                                                    if
                                                    #entries > 0 or
                                                            (grade == 1 and not approval_used) or
                                                            (grade == -1 and not disapproval_used) or
                                                            grade == 0
                                                    then
                                                        ui.container {
                                                            attr = { class = class },
                                                            content = function()
                                                                local heading
                                                                if class == "approval" then
                                                                    approval_used = true
                                                                    approval_index = approval_index + 1
                                                                    if approval_count > 1 then
                                                                        if approval_index == 1 then
                                                                            if #entries == 1 then
                                                                                heading = _ "Approval (first preference) [single entry]"
                                                                            else
                                                                                heading = _ "Approval (first preference) [many entries]"
                                                                            end
                                                                        elseif approval_index == 2 then
                                                                            if #entries == 1 then
                                                                                heading = _ "Approval (second preference) [single entry]"
                                                                            else
                                                                                heading = _ "Approval (second preference) [many entries]"
                                                                            end
                                                                        elseif approval_index == 3 then
                                                                            if #entries == 1 then
                                                                                heading = _ "Approval (third preference) [single entry]"
                                                                            else
                                                                                heading = _ "Approval (third preference) [many entries]"
                                                                            end
                                                                        else
                                                                            if #entries == 1 then
                                                                                heading = _ "Approval (#th preference) [single entry]"
                                                                            else
                                                                                heading = _ "Approval (#th preference) [many entries]"
                                                                            end
                                                                        end
                                                                    else
                                                                        if #entries == 1 then
                                                                            heading = _ "Approval [single entry]"
                                                                        else
                                                                            heading = _ "Approval [many entries]"
                                                                        end
                                                                    end
                                                                elseif class == "abstention" then
                                                                    if #entries == 1 then
                                                                        heading = _ "Abstention [single entry]"
                                                                    else
                                                                        heading = _ "Abstention [many entries]"
                                                                    end
                                                                elseif class == "disapproval" then
                                                                    disapproval_used = true
                                                                    disapproval_index = disapproval_index + 1
                                                                    if disapproval_count > disapproval_index + 1 then
                                                                        if #entries == 1 then
                                                                            heading = _ "Disapproval (prefer to lower blocks) [single entry]"
                                                                        else
                                                                            heading = _ "Disapproval (prefer to lower blocks) [many entries]"
                                                                        end
                                                                    elseif disapproval_count == 2 and disapproval_index == 1 then
                                                                        if #entries == 1 then
                                                                            heading = _ "Disapproval (prefer to lower block) [single entry]"
                                                                        else
                                                                            heading = _ "Disapproval (prefer to lower block) [many entries]"
                                                                        end
                                                                    elseif disapproval_index == disapproval_count - 1 then
                                                                        if #entries == 1 then
                                                                            heading = _ "Disapproval (prefer to last block) [single entry]"
                                                                        else
                                                                            heading = _ "Disapproval (prefer to last block) [many entries]"
                                                                        end
                                                                    else
                                                                        if #entries == 1 then
                                                                            heading = _ "Disapproval [single entry]"
                                                                        else
                                                                            heading = _ "Disapproval [many entries]"
                                                                        end
                                                                    end
                                                                end
                                                                ui.tag {
                                                                    tag = "div",
                                                                    attr = { class = "cathead" },
                                                                    content = heading
                                                                }
                                                                for i, initiative in ipairs(entries) do
                                                                    ui.container {
                                                                        attr = {
                                                                            class = "movable",
                                                                            id = "entry_" .. tostring(initiative.id)
                                                                        },
                                                                        content = function()
                                                                            local initiators_selector = initiative:get_reference_selector("initiating_members"):add_where("accepted")
                                                                            local initiators = initiators_selector:exec()
                                                                            local initiator_names = {}
                                                                            for i, initiator in ipairs(initiators) do
                                                                                initiator_names[#initiator_names + 1] = initiator.name
                                                                            end
                                                                            local initiator_names_string = table.concat(initiator_names, ", ")
                                                                            ui.container {
                                                                                attr = { style = "float: right; position: relative;" },
                                                                                content = function()
                                                                                    ui.link {
                                                                                        attr = { class = "clickable" },
                                                                                        content = _ "Show",
                                                                                        module = "initiative",
                                                                                        view = "show",
                                                                                        id = initiative.id
                                                                                    }
                                                                                    slot.put(" ")
                                                                                    ui.link {
                                                                                        attr = { class = "clickable", target = "_blank" },
                                                                                        content = _ "(new window)",
                                                                                        module = "initiative",
                                                                                        view = "show",
                                                                                        id = initiative.id
                                                                                    }
                                                                                    if not readonly then
                                                                                        slot.put(" ")
                                                                                        ui.image { attr = { class = "grabber" }, static = "icons/grabber.png" }
                                                                                    end
                                                                                end
                                                                            }
                                                                            if not readonly then
                                                                                ui.container {
                                                                                    attr = { style = "float: left; position: relative;" },
                                                                                    content = function()
                                                                                        ui.tag {
                                                                                            tag = "input",
                                                                                            attr = {
                                                                                                onclick = "if (jsFail) return true; voting_moveUp(this.parentNode.parentNode); return(false);",
                                                                                                name = "move_up_" .. tostring(initiative.id),
                                                                                                class = not disabled and "clickable" or nil,
                                                                                                type = "image",
                                                                                                src = encode.url { static = "icons/move_up.png" },
                                                                                                alt = _ "Move up"
                                                                                            }
                                                                                        }
                                                                                        slot.put("&nbsp;")
                                                                                        ui.tag {
                                                                                            tag = "input",
                                                                                            attr = {
                                                                                                onclick = "if (jsFail) return true; voting_moveDown(this.parentNode.parentNode); return(false);",
                                                                                                name = "move_down_" .. tostring(initiative.id),
                                                                                                class = not disabled and "clickable" or nil,
                                                                                                type = "image",
                                                                                                src = encode.url { static = "icons/move_down.png" },
                                                                                                alt = _ "Move down"
                                                                                            }
                                                                                        }
                                                                                        slot.put("&nbsp;")
                                                                                    end
                                                                                }
                                                                            end
                                                                            ui.container {
                                                                                content = function()
                                                                                    ui.tag { content = "i" .. initiative.id .. ": " }
                                                                                    ui.tag { content = initiative.shortened_name }
                                                                                    slot.put("<br />")
                                                                                    for i, initiator in ipairs(initiators) do
                                                                                        ui.link {
                                                                                            attr = { class = "clickable" },
                                                                                            content = function()
                                                                                                execute.view {
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
                                                                                            module = "member",
                                                                                            view = "show",
                                                                                            id = initiator.id
                                                                                        }
                                                                                        slot.put(" ")
                                                                                        ui.tag { content = initiator.name }
                                                                                        slot.put(" ")
                                                                                    end
                                                                                end
                                                                            }
                                                                        end
                                                                    }
                                                                end
                                                            end
                                                        }
                                                    end
                                                end
                                            end
                                        }
                                        if app.session.member_id and preview then
                                            local formatting_engine = param.get("formatting_engine")
                                            local comment = param.get("comment")
                                            local rendered_comment = format.wiki_text(comment, formatting_engine)
                                            slot.put(rendered_comment)
                                        end
                                        if (readonly or direct_voter and direct_voter.comment) and not preview then
                                            local text
                                            if direct_voter and direct_voter.comment_changed then
                                                text = _("Voting comment (last updated: #{timestamp})", { timestamp = format.timestamp(direct_voter.comment_changed) })
                                            elseif direct_voter and direct_voter.comment then
                                                text = _ "Voting comment"
                                            end
                                            if text then
                                                ui.heading { level = "2", content = text }
                                            end
                                            if direct_voter and direct_voter.comment then
                                                local rendered_comment = direct_voter:get_content('html')
                                                ui.container {
                                                    attr = { class = "member_statement" },
                                                    content = function()
                                                        slot.put(rendered_comment)
                                                    end
                                                }
                                                slot.put("<br />")
                                            end
                                        end
                                        if app.session.member_id and app.session.member_id == member.id then
                                            if not readonly or direct_voter then
                                                ui.field.popover {
                                                    attr = {
                                                        dataplacement = "left",
                                                        datahtml = "true";
                                                        datatitle = _ "Box di aiuto per la pagina",
                                                        datacontent = _ "If you'd like to do so, you can post a comment to your vote. To remove a previous comment just leave this space blank and click on <i>Register</i>.",
                                                        datahtml = "true",
                                                        div_attr = { class = "row-fluid" },
                                                        class = "offset11 span1"
                                                    },
                                                    content = function()
                                                    --        ui.container {
                                                    --            attr = { class = "row-fluid" },
                                                    --            content = function()
                                                        ui.image { attr = { class = "" }, static = "png/tutor.png" }
                                                    --            end
                                                    --        }
                                                    end
                                                }
                                                ui.field.hidden { name = "update_comment", value = param.get("update_comment") or issue.closed and "1" }
                                                ui.field.select {
                                                    label = _ "Wiki engine for statement",
                                                    name = "formatting_engine",
                                                    foreign_records = {
                                                        { id = "rocketwiki", name = "RocketWiki" },
                                                        { id = "compat", name = _ "Traditional wiki syntax" }
                                                    },
                                                    attr = { id = "formatting_engine" },
                                                    foreign_id = "id",
                                                    foreign_name = "name",
                                                    value = param.get("formatting_engine") or direct_voter and direct_voter.formatting_engine
                                                }
                                                ui.field.text {
                                                    label = _ "Voting comment (optional)",
                                                    name = "comment",
                                                    multiline = true,
                                                    value = param.get("comment") or direct_voter and direct_voter.comment,
                                                    attr = { style = "height: 20ex;" },
                                                }
                                            end

                                            ui.container {
                                                attr = { class = "row-fluid" },
                                                content = function()
                                                    if not readonly or direct_voter then
                                                        ui.tag {
                                                            tag = "input",
                                                            attr = {
                                                                type = "submit",
                                                                name = "preview",
                                                                value = _ "Preview voting comment",
                                                                class = "preview text-center span5 btn btn-primary btn-large large_btn"
                                                            }
                                                        }
                                                    end
                                                    if not readonly or preview or direct_voter then
                                                        ui.tag {
                                                            tag = "input",
                                                            attr = {
                                                                type = "submit",
                                                                class = "offset4 voting_done2 btn btn-primary btn-large large_btn",
                                                                value = submit_button_text
                                                            }
                                                        }
                                                    end
                                                end
                                            }
                                        end
                                    end
                                }
                            end
                        }
                    end
                }
            end
        }
    end
}

