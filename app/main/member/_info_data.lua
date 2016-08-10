local member = Member:by_id(param.get_id())

ui.container {
    attr = { class = "col-md-2 text-center" },
    content = function()
        execute.view {
            module = "member_image",
            view = "_show",
            params = {
                member = member,
                image_type = "photo",
                show_dummy = true,
                class = "img-responsive"
            }
        }
    end
}
ui.container {
    attr = { class = "col-md-4 col-md-offset-1" },
    content = function()
        ui.form {
            method = "post",
            attr = { id = "false_identity" },
            module = 'member',
            action = 'report_false_identity',
            params = { member_id = member.id },
            routing = {
                ok = {
                    mode = 'redirect',
                    module = param.get("module", atom.string),
                    view = param.get("view", atom.string),
                    id = param.get("content_id", atom.integer)
                },
                error = {
                    mode = 'redirect',
                    module = param.get("module", atom.string),
                    view = param.get("view", atom.string),
                    id = param.get("content_id", atom.integer)
                }
            },
            content = function()
                    ui.heading {
                        level = 3,
                        content = function()
                            ui.tag { content = _ "Name" .. ": " }
                            ui.tag { tag = "h3", content = member.realname }
                        end
                    }
                    ui.heading {
                        level = 3,
                        content = function()
                            ui.tag { content = _ "NIN" .. ": " }
                            ui.tag { tag = "h3", content = member.nin }
                        end
                    }
                            --                                        ui.heading {
                            --                                            level = 3,
                            --                                            content = function()
                            --                                                ui.tag { content = _ "Comune" .. ": " }
                            --                                                ui.tag { tag = "strong", content = "Roma" }
                            --                                            end
                            --                                        }
                            --                                        ui.heading {
                            --                                            level = 3,
                            --                                            content = function()
                            --                                                ui.tag { content = _ "Municipio" .. ": " }
                            --                                                ui.tag { tag = "strong", content = "IX" }
                            --                                            end
                            --                                        }
                            --                                        ui.heading {
                            --                                            level = 3,
                            --                                            content = function()
                            --                                                ui.tag { content = _ "Certificatore" .. ": " }
                            --                                                ui.tag { tag = "strong", content = "Paolo Rossi" }
                            --                                            end
                            --                                        }

                  ui.anchor {
                      attr = {
                          href = "#",
                          class = "btn btn-primary large-btn spaceline3",
                          onclick = "document.getElementById(\"false_identity\").submit();"
                      },
                      content = function()
                          ui.heading { level = 3, attr = { class = "" }, content = _ "Report false identity" }
                      end
                  }
            end
        }
    end
}