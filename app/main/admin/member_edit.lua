slot.set_layout("custom")

local id = param.get_id()

local member = Member:by_id(id)

ui.title(function()
    ui.container {
        attr = { class = "row text-left" },
        content = function()
            ui.container {
                attr = { class = "col-md-3" },
                content = function()
                    ui.link {
                        attr = { class = "btn btn-primary btn-large large_btn fixclick btn-back" },
                        module = "admin",
                        view = "member_list",
                        image = { attr = { class = "arrow_medium" }, static = "svg/arrow-left.svg" },
                        content = _ "Back to previous page"
                    }
                end
            }
            if member then
                ui.tag {
                    tag = "strong",
                    attr = { class = "col-md-9 text-center" },
                    content = _("Member: '#{identification}' (#{name})", { identification = member.identification, name = member.name })
                }
            else
                ui.tag {
                    tag = "strong",
                    attr = { class = "col-md-9 text-center" },
                    content = _ "Register new member"
                }
            end
        end
    }
end)


local units_selector = Unit:new_selector()

if member then
    units_selector:left_join("privilege", nil, { "privilege.member_id = ? AND privilege.unit_id = unit.id", member.id }):add_field("privilege.voting_right", "voting_right")
end

local units = Unit:get_flattened_tree{} --units_selector:exec()

ui.form {
    attr = { class = "vertical" },
    module = "admin",
    action = "member_update",
    id = member and member.id,
    record = member,
    readonly = not app.session.member.admin,
    routing = {
        default = {
            mode = "redirect",
            modules = "admin",
            view = "member_list"
        }
    },
    content = function()
        ui.field.text { label = _ "Identification", name = "identification" }
        ui.field.text { label = _ "Notification email", name = "notify_email" }
        ui.field.text { label = _ "NIN", name = "nin" }
        if member and member.activated then
            ui.field.text { label = _ "Screen name", name = "name" }
            ui.field.text { label = _ "Login name", name = "login" }
        end
        ui.field.boolean { label = _ "Admin?", name = "admin" }
        ui.field.boolean { label = _ "LQFB Access?", name = "lqfb_access" }
        ui.field.boolean { label = _ "Auditor?", name = "auditor" }
        ui.field.boolean { label = _ "Elected?", name = "elected" }

        slot.put("<br />")

        --[[for i, unit in ipairs(units) do
            ui.field.boolean {
                name = "unit_" .. unit.id,
                label = unit.name,
                value = unit.voting_right
            }
        end]]
        ui.list {
					records = units,
					columns = {
						  {
						  		field_attr = { style = "font-weight:bold;font-size:22px;"},
						      content = function(unit)
						          for i = 1, unit.depth - 1 do
						              slot.put("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;")
						          end
						          local style = ""
						          if not unit.active then
						              style = "text-decoration: line-through;"
						          end
						          ui.link {						          
						          		name = "unit_" .. unit.id,
						          		text = unit.name
						          }
						      end
						  },
						  {
						  		content = function(unit)
						  				ui.field.boolean {
						          		name = "unit_" .. unit.id,
										      --label = unit.name,
										      value = member:has_voting_right_for_unit_id(unit.id)
										  }
						  		end
						  }
					}
			}
        slot.put("<br /><br />")

        if not member or not member.activated then
            ui.field.boolean { label = _ "Send invite?", name = "invite_member" }
        end

        if member and member.activated then
            ui.field.boolean { label = _ "Lock member?", name = "locked" }
        end

        ui.field.boolean {
            label = _ "Member inactive?",
            name = "deactivate",
            readonly = member and member.active,
            value = member and member.active == false
        }

        slot.put("<br />")
        ui.submit { text = _ "Save" }
    end
}
