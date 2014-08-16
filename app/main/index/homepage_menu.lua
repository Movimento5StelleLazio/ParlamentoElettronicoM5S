local welcomeText = _ "Homepage welcome text"
welcomeText = welcomeText .. _ "Homepage welcome text2"


ui.container {
    attr = { id = "menuDiv", class = "menuDiv" },
    content = function()

        ui.tag {
            tag = "p",
            attr = { class = "welcomeText", readonly = "true" },
            content = _ "Homepage welcome" .. " " .. app.session.member.name .. ","
        }

        ui.tag {
            tag = "p",
            attr = { class = "welcomeText", readonly = "true" },
            content = welcomeText
        }


        slot.put("<br />")

        ui.tag {
            tag = "p",
            attr = { class = "sceltaText", readonly = "true" },
            content = _ "Homepage what to do?"
        }
        ui.tag {
            tag = "p",
            attr = { class = "sceltaText", readonly = "true" },
            content = _ "Homepage Choose action:"
        }


        ui.container
            {
                attr = { id = "btnMenuDiv" },
                content = function()


                    ui.container
                        {
                            attr = { id = "btnReadInitiative", class = "menuButton" },
                            content = function()
                            --pulsante 1
                                ui.link {
                                    attr = { class = "button orange" },
                                    module = "unit",
                                    view = "show_ext",
                                    content = _ "Homepage read new issues"
                                }
                            end
                        }


                    ui.container
                        {
                            attr = { id = "btnWriteInitiative", class = "menuButton" },
                            content = function()
                            --pulsante 2
                                ui.link {
                                    attr = { class = "button orange " },
                                    module = "wizard",
                                    view = "show_ext",
                                    content = _ "Homepage write new issue"
                                }
                            end
                        }

                    ui.container
                        {
                            attr = { id = "btnReadNewM5Sinitiative", class = "menuButton" },
                            content = function()
                            --pulsante 3
                                ui.link {
                                    attr = { class = "button orange " },
                                    module = "unit",
                                    view = "show_ext",
                                    content = _ "Homepage read m5s issues"
                                }
                            end
                        }

                    ui.container
                        {
                            attr = { id = "btnReadNewOtherInitiative", class = "menuButton" },
                            content = function()
                            --pulsante 4
                                ui.link {
                                    attr = { class = "button orange" },
                                    module = "unit",
                                    view = "show_ext",
                                    content = _ "Homepage read other issues",
                                }
                            end
                        }
                end -- fine container.content
            }
    end
}
