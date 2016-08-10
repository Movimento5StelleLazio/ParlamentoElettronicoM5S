slot.set_layout("custom")

local suggestion = Suggestion:by_id(param.get_id())

-- redirect to initiative if suggestion does not exist anymore
if not suggestion then
    local initiative_id = param.get('initiative_id', atom.integer)
    if initiative_id then
        slot.reset_all { except = { "notice", "error" } }
        request.redirect {
            module = 'initiative',
            view = 'show',
            id = initiative_id,
            params = { tab = "suggestions" }
        }
    else
        slot.put_into('error', _ "Suggestion does not exist anymore")
    end
    return
end


app.html_title.title = suggestion.name
app.html_title.subtitle = _("Suggestion ##{id}", { id = suggestion.id })

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
                        view = "show",
                        id = suggestion.initiative.id,
                        params = { tab = "suggestions" },
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }

            ui.container {
                attr = { class = "col-md-8 spaceline2 text-center label label-warning" },
                content = function()
                    ui.heading {
                        level = 1,
                        attr = { class = "fittext1 uppercase" },
                        content = _ "Suggestion for initiative: '#{name}'":gsub("#{name}", suggestion.initiative.name)
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
                            datacontent = _ "In questa pagina puoi proporre un emendamento. Se classificherai l'emendamento con un grado <i>deve/non deve</i> verrai aggiunto ai <i>Potenziali sostenitori</i> della proposta fino a quando non riterrai che il tuo emendamento sia stato accolto. Se classificherai <i>dovrebbe/non dovrebbe</i> verrai aggiunto ai <i>Sostenitori</i> della proposta.",
                            datahtml = "true",
                            class = "text-center"
                        },
                        content = function()
                            ui.image { attr = { class = "icon-medium" },static = "png/tutor.png" }
                        end
                    }
                end
            }
        end
    }
end)

execute.view {
    module = "suggestion",
    view = "show_tab",
    params = {
        suggestion = suggestion
    }
}
