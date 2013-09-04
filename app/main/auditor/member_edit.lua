slot.set_layout("custom")
local id = param.get_id()

local member = Member:by_id(id)
local member_data = MemberData:by_id(id)

ui.container{ attr = { class = "row-fluid" }, content = function()
  ui.container{ attr = { class = "span12 well" }, content = function()
    ui.container{ attr = { class = "row-fluid" }, content = function()
      ui.container{ attr = { class = "span12 text-center" }, content = function()
        ui.heading{ level = 1, attr = { class = "uppercase"  }, content = function()
          if member then
            slot.put(_("Member: #{firstname} #{lastname}", { firstname = member.firstname, lastname = member.lastname }))
          else
            slot.put(_"Register new member")
          end
        end }
      end }
    end }
  end }
end }

ui.container{ attr = { class = "row-fluid spaceline2" }, content = function()
  ui.container{ attr = { class = "span12 alert alert-simple issue_box paper"}, content = function()
    ui.form{
      attr = { class = "", role="form" },
      module = "auditor",
      action = "member_update",
      id = member and member.id,
      record = member,
      readonly = not app.session.member.auditor,
      routing = {
        default = {
          mode = "redirect",
          modules = "auditor",
          view = "index"
        },
        error = {
          mode = "redirect",
          modules = "auditor",
          view = "member_edit",
          id = member.id
        },
        ok = {
          mode = "redirect",
          modules = "auditor",
          view = "index"
        }
      },
      content = function()
        ui.heading{ level = 2, attr = { class = "text-center"  }, content = _"Personal data" }
        ui.field.text{ 
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"Name"},
          label=_"Name", 
          name = "firstname" 
        }
        ui.field.text{ 
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"Surname"}, 
          label = _"Surname", 
          name = "lastname" 
        }
        ui.field.text{ 
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"NIN"}, 
          label = _"NIN", 
          name = "nin" 
        }
        ui.field.text{ 
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder="email@example.org"}, 
          label = _"Email", 
          name = "notify_email" 
        }
        ui.field.text{ 
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"City"}, 
          label = _"Birthplace", 
          name = "birthplace" 
        }
        ui.field.text{ 
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"dd/mm/yyyy", maxlength="10"}, 
          label = _"Birthdate", 
          name = "birthdate" 
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"ID card number"},
          label = _"ID card number",
          name = "idcard"
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"Token Serial"},
          label = _"Token serial",
          name = "token_serial"
        }

        --[[ 
          Residence
        --]]
        ui.heading{ level = 2, attr = { class = "text-center"  }, content = _"Residence" }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"Residence address"},
          label = _"Residence address",
          name = "residence_address"
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"Residence city"},
          label = _"Residence city",
          name = "residence_city"
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"Residence province"},
          label = _"Residence province",
          name = "residence_province"
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"Residence postcode"},
          label = _"Residence postcode",
          name = "residence_postcode"
        }

        --[[ 
          Domicile
        --]]
        ui.heading{ level = 2, attr = { class = "text-center"  }, content = _"Domicile" }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"Domicile address"},
          label = _"Domicile address",
          name = "domicile_address"
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"Domicile city"},
          label = _"Domicile city",
          name = "domicile_city"
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"Domicile province"},
          label = _"Domicile province",
          name = "domicile_province"
        }
        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"Domicile postcode"},
          label = _"Domicile postcode",
          name = "domicile_postcode"
        }

        ui.field.text{
          record = member_data,
          label_attr={class="auditor_input_label"},
          attr={class="auditor_input",placeholder=_"Municipality ID"},
          label = _"Municipality ID",
          name = "municipality_id"
        }

        --[[
        ui.container{content=function()
          ui.tag{ attr={ class="auditor_input_label"}, tag = "label", content =_"Birthdate"}
          ui.tag{tag = "input", attr={style="width:40px;", type ="text", maxlength="2", placeholder=_"dd", name="day"},content =""}
          ui.tag{tag = "input", attr={style="width:40px;", type ="text", maxlength="2", placeholder=_"mm", name="month"},content =""}
          ui.tag{tag = "input", attr={style="width:40px;", type ="text", maxlength="4", placeholder=_"yyyy", name="year"},content =""}
        end }
        --]]
    
        if not member or not member.activated then
          ui.field.boolean{label_attr={class="auditor_input_label"},  label = _"Send invite?",       name = "invite_member" }
        end
        
        if member and member.activated then
          ui.field.boolean{label_attr={class="auditor_input_label"},  label = _"Lock member?",       name = "locked" }
        end
        --[[
        ui.field.boolean{ 
          label_attr={class="auditor_input_label"},
          label = _"Member inactive?", name = "deactivate",
          readonly = member and member.active, value = member and member.active == false
        }
        --]]
        
        ui.container{ attr = { class = "row-fluid text-center spaceline2" }, content = function()
            ui.container{ attr = { class = "span6 offset3" }, content = function()
              ui.tag{
                tag="button",
                attr = { type="submit", class="btn btn-primary btn-large fixclick" },
                content= function()
                  ui.heading{ level=4, attr = { class="inline-block"}, content= _"Save"}
                end
              }
            end }
          end }
      end
    }
  end }
end }
