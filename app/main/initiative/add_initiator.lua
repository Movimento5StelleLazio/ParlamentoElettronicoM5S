slot.set_layout("custom")

local initiative = Initiative:by_id(param.get("initiative_id", atom.integer))

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
                        id = initiative.id,
                        params = {
                            tab = "initiators"
                        },
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
                        content = _ "Invite an initiator to initiative"
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
                            datacontent = _ "Puoi invitare alcuni tuoi amici come co-autori della proposta. Per farlo, selezionali nell'elenco sottostante e poi clicca su <i>Salva</i>. Per aggiungere amici apri il profilo della persona che vuoi aggiungere cliccando sulla sua miniatura e clicca su <i>Aggiungi ai contatti</i>",
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

ui.form {
    attr = { class = "vertical" },
    module = "initiative",
    action = "add_initiator",
    params = {
        initiative_id = initiative.id,
    },
    routing = {
        ok = {
            mode = "redirect",
            module = "initiative",
            view = "show",
            id = initiative.id,
            params = {
                tab = "initiators",
            }
        }
    },
    content = function()
        local records = {
            {
                id = "-1",
                name = _ "Choose member"
            }
        }
        local contact_members = app.session.member:get_reference_selector("saved_members"):add_order_by("name"):exec()
        for i, record in ipairs(contact_members) do
            records[#records + 1] = record
        end
        ui.field.select {
            label = _ "Member",
            name = "member_id",
            foreign_records = records,
            foreign_id = "id",
            foreign_name = "name"
        }
        ui.tag {
            tag = "input",
            attr = {
                type = "submit",
                class = "col-md-offset-4 btn btn-primary btn-large large_btn",
                value = _ "Save"
            }
        }
    end
}