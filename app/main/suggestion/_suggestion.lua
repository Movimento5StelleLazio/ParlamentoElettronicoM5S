local suggestion = param.get("suggestion", "table")
ui.container {
    attr = { class = "row-fluid" },
    content = function()
        ui.container {
            attr = { class = "span12 well" },
            content = function()
                ui.form {
                    attr = { class = "text-center" },
                    record = suggestion,
                    readonly = true,
                    content = function()
                        ui.container {
                            attr = { class = "row-fluid" },
                            content = function()
                                ui.container {
                                    attr = { class = "span8 offset1 label label-warning" },
                                    content = function()
                                        ui.container {
                                            attr = { class = "span6" },
                                            content = function()
                                                if suggestion.author then
                                                    suggestion.author:ui_field_text { label = _ "Author" }
                                                end
                                            end
                                        }
                                        ui.container {
                                            attr = { class = "span6" },
                                            content = function()
                                                ui.field.text { label = _ "Title", name = "name" }
                                            end
                                        }
                                    end
                                }
                                ui.container {
                                    attr = { class = "span1 offset1 text-right " },
                                    content = function()
                                        ui.field.popover {
                                            attr = {
                                                dataplacement = "left",
                                                datahtml = "true";
                                                datatitle = _ "Box di aiuto",
                                                datacontent = _("Qui puoi esprimere la tua opinione, in merito all' emendamento presentato: <ol><li> OPINIONE DEI SOSTENITORI; sono le opinioni dei sostenitori, il colore va dal verde (positivo) al Rosso (negativo)</li><li>LA  MIA OPINIONE; hai 5 opzioni con diverse sfumature, se la tua opinione è positiva condiziona il campo RITENGO L' EMENDAMENTO.</li><li> ADOTTATO - NON ADOTTATO </li><li>RITENGO L' EMENDAMENTO; Implementato e sono soddisfatto, se ho espresso un opinione DEVE - DOVREBBE, Implementato e non sono soddisfatto, se ho espresso un opinione, NON DEVE - NON DOVREBBE; Non Implementato e sono soddisfatto, se ho espresso un opinione NON DEVE - NON DOVREBBE; Non implementato e Non sono soddisfatto se ho espresso un opinione DEVE - DOVREBBE.</li></0l>"),
                                                datahtml = "true",
                                                class = "text-center"
                                            },
                                            content = function()
                                                ui.container {
                                                    attr = { class = "row-fluid" },
                                                    content = function()
                                                        ui.image { static = "png/tutor.png" }
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
                            attr = { class = "row-fluid spaceline spaceline-bottom text-left" },
                            content = function()
                                ui.container {
                                    attr = { class = "span12 well-inside paper" },
                                    content = function()
                                        slot.put(suggestion:get_content("html"))
                                    end
                                }
                            end
                        }
                    end
                }
                execute.view {
                    module = "suggestion",
                    view = "_list_element",
                    params = {
                        suggestions_selector = Suggestion:new_selector():add_where { "id = ?", suggestion.id },
                        initiative = suggestion.initiative,
                        show_name = false,
                        show_filter = false
                    }
                }
            end
        }
    end
}
