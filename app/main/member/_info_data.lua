local member = Member:by_id(param.get_id())

ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span12 member_data"}, content=function()
    ui.container{attr={class="row-fluid"}, content=function()
      ui.container{attr={class="span2 text-center"}, content=function()

        execute.view{
          module = "member_image",
          view = "_show",
          params = {
            member = member,
            image_type = "avatar",
            show_dummy = true,
            class= "member_img_bs"
          }
        }

      end }
      ui.container{attr={class="span10"}, content=function()

        ui.heading{level=6,content=function()
          ui.tag{content=_"Name"..": "}
          ui.tag{tag="strong",content=member.realname}
        end }
        ui.heading{level=6,content=function()
          ui.tag{content=_"Codice Fiscale"..": "}
          ui.tag{tag="strong",content=member.codice_fiscale}
        end }
    
      end }
    end }

  end }
end }

