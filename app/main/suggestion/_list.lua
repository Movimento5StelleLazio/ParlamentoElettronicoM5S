local initiative = param.get("initiative", "table")
local suggestions_selector = param.get("suggestions_selector", "table")

suggestions_selector:add_order_by("proportional_order NULLS LAST, plus2_unfulfilled_count + plus1_unfulfilled_count DESC, id")

local ui_filters = ui.filters
if true or not show_filter then
    ui_filters = function(args) args.content() end
end

ui.container {
    attr = { class = "row" },
    content = function()
        ui.container {
            attr = { class = "col-md-11 label label-warning-tbox spaceline" },
            content = function()
                ui.tag { tag = "h3", attr = {name = "suggestions" }, content = _ "Suggestions" }
            end
        }
        ui.container {
            attr = { class = "col-md-1 hidden-xs text-right " },
            content = function()
                ui.field.popover {
                    attr = {
                        dataplacement = "bottom",
                        datahtml = "true";
                        datatitle = _ "Box di aiuto",
                        datacontent = _ "In questo box trovi l' Elenco degli emendamenti presentati (click sul titolo evidenziato per vedere il dettaglio), ed il loro andamento nel gradimento ed opinione dell' Assemblea, puoi tu stesso presentare un emendamento, oppure dare la tua opinione, consenso o diniego, di uno o piu emendamenti, queste azioni condizionano la stesura finale del testo di Legge, da proporre per il voto definitivo. Ogni sostenitore ha diritto ad un max di 3 emendamenti (Regola sperimentale).",
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

ui.container {
    attr = { class = "row" },
    content = function()
        ui.container {
            attr = { class = "col-md-12 well-inside paper" },
            content = function()
                ui.container {
                    attr = { class = "row spaceline" },
                    content = function()
                        ui.paginate {
                            selector = suggestions_selector,
                            anchor = "suggestions",
                            content = function()
                                local suggestions = suggestions_selector:exec()
                                if #suggestions < 1 then
                                    if not initiative.issue.fully_frozen and not initiative.issue.closed then
                                        ui.tag { content = _ "No suggestions yet" }
                                    else
                                        ui.tag { content = _ "No suggestions" }
                                    end
                                else
                                    ui.list {
                                        attr = { class = "table stripped" },
                                        records = suggestions,
                                        columns = {
                                            {
                                                label_attr = { style = "width: 101px;" },
                                                content = function(record)
                                                    if record.minus2_unfulfilled_count then
                                                        local max_value = record.initiative.supporter_count
                                                        ui.bargraph {
                                                            max_value = max_value,
                                                            width = 100,
                                                            bars = {
                                                                { color = "#0a0", value = record.plus2_unfulfilled_count + record.plus2_fulfilled_count },
                                                                { color = "#8f8", value = record.plus1_unfulfilled_count + record.plus1_fulfilled_count },
                                                                { color = "#eee", value = max_value - record.minus2_unfulfilled_count - record.minus1_unfulfilled_count - record.minus2_fulfilled_count - record.minus1_fulfilled_count - record.plus1_unfulfilled_count - record.plus2_unfulfilled_count - record.plus1_fulfilled_count - record.plus2_fulfilled_count },
                                                                { color = "#f88", value = record.minus1_unfulfilled_count + record.minus1_fulfilled_count },
                                                                { color = "#a00", value = record.minus2_unfulfilled_count + record.minus2_fulfilled_count },
                                                            }
                                                        }
                                                    end
                                                end
                                            },
                                            {
                                                content = function(record)
                                                    ui.link {
                                                        attr = { class = "label label-info" },
                                                        text = record.name,
                                                        module = "suggestion",
                                                        view = "show",
                                                        id = record.id
                                                    }
                                                    local degree
                                                    local opinion
                                                    if app.session.member_id then
                                                        opinion = Opinion:by_pk(app.session.member.id, record.id)
                                                    end
                                                    if opinion then
                                                        local degrees = {
                                                            ["-2"] = _ "must not",
                                                            ["-1"] = _ "should not",
                                                            ["0"] = _ "neutral",
                                                            ["1"] = _ "should",
                                                            ["2"] = _ "must"
                                                        }
                                                        slot.put(" &middot; ")
                                                        ui.tag { content = degrees[tostring(opinion.degree)] }
                                                        slot.put(" &middot; ")
                                                        if opinion.fulfilled then
                                                            ui.tag { content = _ "implemented" }
                                                        else
                                                            ui.tag { content = _ "not implemented" }
                                                        end
                                                    end
                                                end
                                            },
                                        }
                                    }
                                end
                            end
                        }
                    end
                }
                if app.session.member_id
                        and not initiative.issue.half_frozen
                        and not initiative.issue.closed
                        and not initiative.revoked
                        and app.session.member:has_voting_right_for_unit_id(initiative.issue.area.unit_id)
                then
                    ui.container {
                        attr = { class = "row text-center" },
                        content = function()
                            ui.container {
                                attr = { class = "col-md-6 col-md-offset-3 text-center spaceline-bottom" },
                                content = function()
                                    ui.link {
                                        attr = { class = "btn btn-primary btn_size_fix fixclick" },
                                        module = "suggestion",
                                        view = "new",
                                        params = { initiative_id = initiative.id },
                                        text = _ "New suggestion"
                                    }
                                end
                            }
                        end
                    }
                end
            end
        }
    end
}
