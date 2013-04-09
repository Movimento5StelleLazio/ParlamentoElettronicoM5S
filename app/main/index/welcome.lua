local member = Member:by_id(app.session.member.id)

ui.container{
  attr = {id = "welcome_title_box" }, 
  content = function() 
    slot.put( "<p  class = \"welcome_text_xl\">".._"5 STARS MOVEMENT<br />E-PARLIAMENT<br />REGIONE LAZIO".."</p>")
  end
}


ui.container{ attr = { id  = "welcome_middle_box" }, content = function()
  if app.session.member_id then     
    locale.set{date_format="DD/MM/YYYY"}
 
    -- Codifica coordinate memorizzate in member_login
    local lastLogin = member:get_last_login_data()
      if lastLogin and lastLogin.geolat and lastLogin.geolng and lastLogin.login_time then
        trace.debug('Calling codelatlng('..lastLogin.geolat..','..lastLogin.geolng..',"location","'.._"from "..'");')
        ui.script{ static = "js/position.js" }
        ui.script{ script = 'codelatlng('..lastLogin.geolat..','..lastLogin.geolng..',"location","'.._"from "..'");'}
      else
        trace.debug('Cannot retrieve coordinates from database')
      end
    ui.tag{ tag="p", attr = { class = "welcome_text_l"}, content= _("WELCOME #{realname}.", {realname = member.realname}) }
    ui.container{ attr = { class = "welcome_text_l" }, content = function ()
      ui.tag{
        tag="span",
        attr = {class = "welcome_text_l"},
        content= _("#{realname}, your last login was on #{last_login_date} at #{last_login_time}", {
          realname = member.realname,
          last_login_date = format.date(member.last_login),
          last_login_time = format.time(member.last_login)
        })
      }
      ui.tag{tag="span",attr = { id = "location", class = "welcome_text_l"}}
    end}
  end

      slot.put("<br />")
      ui.tag{ tag="p", attr = { class = "welcome_text_xl"}, content= _"CHOOSE THE ASSEMBLY YOU WANT TO PARTECIPATE TO:"}

      ui.link{ attr = {id = "welcome_middle_box_left", class="button orange menuButton"}, module="index", view="homepage", content=function()
        ui.tag{ tag="p", attr = {class = "button_text" }, content= _"REGIONE LAZIO ASSEMBLY"}
      end}
      ui.link{ attr = {id = "welcome_middle_box_right", class="button orange menuButton" }, content=function()
        ui.tag{ tag="p", attr = {class = "button_text" }, content= _"5 STARS MOVEMENT LAZIO INTERNAL ASSEMBLY"}
      end}
      ui.tag{  tag="img", attr = { id = "welcome_parlamento_left", src="../static/parlamento_icon_small.png", alt="Icona Parlamento"} }
      ui.tag{  tag="img", attr = { id = "welcome_parlamento_right", src="../static/parlamento_icon_small.png", alt="Icona Parlamento"} }

end}

ui.container{ attr = {id = "welcome_footer_container" }, content=function()
  ui.tag{  tag="img", attr = { id = "welcome_footer_box_left" , src="../static/simbolo_movimento.png", alt="Movimento 5 Stelle"} }
  ui.tag{ tag="p", attr = { id = "welcome_footer_box_middle" , class = "welcome_text_xl" }, content= _"ARE YOU A LAZIO CITIZEN AND YOU WANT TO REGISTER? HERE'S HOW TO DO IT:"}
  ui.tag{  tag="img", attr = { id = "arrow_right" , src="../static/arrow_right.png", alt="Freccia destra"} }
  ui.container{ attr = {id = "welcome_footer_box_right", class="button orange menuButton" }, content=function()
    ui.tag{ tag="p", attr = {class = "button_text" }, content= _"REGISTRATION GUIDE"}
  end}
end}

slot.put("<br />")
slot.put("<br />")
