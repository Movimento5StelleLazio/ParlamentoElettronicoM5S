local member = Member:by_id(param.get_id())

ui.container{attr={class="row-fluid"}, content=function()
  ui.container{attr={class="span12 alert member_data"}, content=function()
    ui.container{attr={class="row-fluid"}, content=function()
      ui.container{attr={class="span3 text-center"}, content=function()
        execute.view{
          module = "member_image", view = "_show",
          params = {
            member = member,
            image_type = "photo",
            show_dummy = true,
            class= "member_img_bs"
          }
        }
      end }

      ui.container{attr={class="span6"}, content=function()
        ui.heading{level=6,content=function()
          ui.tag{content=_"Name"..": "}
          ui.tag{tag="strong",content=member.realname}
        end }
        ui.heading{level=6,content=function()
          ui.tag{content=_"Codice Fiscale"..": "}
          ui.tag{tag="strong",content=member.codice_fiscale}
        end }
        ui.heading{level=6,content=function()
          ui.tag{content=_"Comune"..": "}
          ui.tag{tag="strong",content="Roma"}
        end }
        ui.heading{level=6,content=function()
          ui.tag{content=_"Municipio"..": "}
          ui.tag{tag="strong",content="IX"}
        end }
        ui.heading{level=6,content=function()
          ui.tag{content=_"Certificatore"..": "}
          ui.tag{tag="strong",content="Paolo Rossi"}
        end }
      end }

      ui.container{attr={class="span3 text-center"}, content=function()
        ui.anchor{
          attr = {
            href = "#",
            class = "btn btn-primary table-cell medium_btn spaceline",
            onclick = "alert('Dato sospetto segnalato! (Non implementato)' );"
          },
          content=function()
            ui.heading{level=6,attr={class=""},content= _"Report false identity"}
          end
        }
      end }
      
    end }

  end }
end }

