slot.set_layout("m5s_bs")

slot.put( "<br/>")
if not app.session.member_id then
  ui.container{attr = {class = "row-fluid" },content = function()
    ui.container{
      attr = {class = "text-center span8 offset2 well" },
      content = function()
        slot.put( "<h2>".._"5 STARS MOVEMENT<br />E-PARLIAMENT<br />REGIONE LAZIO".."</h2>")
        ui.tag{ tag = "small", content = "Versione 0.2" }
      end
    }
  end}
end

if app.session.member_id then
  util.help("index.index", _"Home")
  local member = Member:by_id(app.session.member.id)

  ui.container{attr = {class = "row-fluid" },content = function()

    ui.container{ attr = { class  = "well span8 offset2 text-center" }, content = function()
   
      -- Codifica coordinate memorizzate in member_login
      local lastLogin = member:get_last_login_data()
      if lastLogin and lastLogin.geolat and lastLogin.geolng and lastLogin.login_time then
        trace.debug('Calling codelatlng('..lastLogin.geolat..','..lastLogin.geolng..',"location","'.._"from "..'");')
        ui.script{ static = "js/position.js" }
        ui.script{ script = 'codelatlng('..lastLogin.geolat..','..lastLogin.geolng..',"location","'.._"from "..'");'}
      else
        trace.debug('Cannot retrieve coordinates from database')
      end
      slot.put( _("Welcome <strong>#{realname}</strong>.", {realname = member.realname}) )
      slot.put("&nbsp;")
      if lastLogin and lastLogin.login_time then
        ui.tag{
          content= _("Your last login was on #{last_login_date} at #{last_login_time}", {
            last_login_date = format.date(lastLogin.login_time),
            last_login_time = format.time(lastLogin.login_time)
          })
        }
        slot.put("&nbsp;")
        ui.tag{ tag="span", attr = { id = "location"}, content="" }
      end
      ui.tag{ tag="h3", content= _"Scegli l'assemblea alla quale vuoi partecipare:"}

    end }
  
  end }

  ui.container{attr = {class = "row-fluid" },content = function()

    ui.container{ 
      attr = {class = "sameheight well span4 offset2 text-center" },
      content=function()
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.container{attr = {class = "span12" },content = function()
            ui.image{static="parlamento_icon_small.png" } 
          end }
        end }
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.container{attr = {class = "span12" },content = function()
            ui.link{
              module="index", 
              view="homepage", 
              attr = {class = "btn btn-primary btn-large" }, 
              content= _"REGIONE LAZIO ASSEMBLY"
            }
          end }
        end }
      end
    }

    ui.container{ 
      attr = {class = "sameheight well span4 text-center" }, 
      content=function()
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.container{attr = {class = "span12" },content = function()
            ui.image{ static="parlamento_icon_small.png" }
          end }
        end }
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.container{attr = {class = "span12" },content = function()
            ui.link{ 
              attr = {class = "btn btn-primary btn-large" }, 
              module="unit", 
              view="show_ext", 
              id=config.gui_preset.M5S.units["iscritti"].unit_id,
              content= _"5 STARS MOVEMENT LAZIO INTERNAL ASSEMBLY"
           }
          end }
        end }
        ui.script{static = "js/sameheight.js"}
      end
    }

  end }

else

  if config.motd_public then
    local help_text = config.motd_public
    ui.container{
      attr = { class = "wiki motd" },
      content = function()
        slot.put(format.wiki_text(help_text))
      end
    }
  end


  ui.container{ attr = { class = "row-fluid" }, content = function ()

    ui.form{
      attr = { id="login_div", class = "well span6" },
      module = 'index',
      action = 'login',
      routing = {
        ok = {
          mode   = 'redirect',
          module = param.get("redirect_module") or "index",
          view = param.get("redirect_view") or "index",
          id = param.get("redirect_id"),
        },
        error = {
          mode   = 'forward',
          module = 'index',
          view   = 'index',
        }
      },
      content = function()
        ui.tag{ tag = "fieldset", content = function()
          ui.container{ attr = { class = "row-fluid" }, content = function()
            ui.tag{ tag = "legend",attr = { class = "span12 text-center" }, content = _"Insert user name and password to access:" }
          end }

          ui.container{ attr = { class = "row-fluid" }, content = function()
            ui.tag{ tag="label", attr = { class = "span4" },content =_'login name' }
            ui.tag{ 
              tag="input", 
              attr = { id="username_field", type="text", placeholder=_'login name', class = "span8 input-large", name="login" }, 
              content = '' 
            }
          end }
        
          ui.container{ attr = { class = "row-fluid" }, content = function()
            ui.tag{ tag="label",attr = { class = "span4" },  content =_'Password' }
            ui.script{ script = 'document.getElementById("username_field").focus();' }
            ui.tag{ tag="input", attr = { type="password", placeholder=_'Password', class = "span8 input-large", name="password" }, content = '' }
          end }
  
          ui.container{ attr = { class = "row-fluid text-center" }, content = function()
             ui.tag{ tag="button",  attr = { type="submit", class="btn btn-primary btn-large span4 offset4" }, content=_'Login' }
          end }
        end }
      end 
    }

    ui.container{ attr = { id="registration-info", class = "span6 well" }, content = function ()
        ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
          ui.tag{ attr = { class="span8 text-center"}, content= "Sei un cittadino del Lazio e vuoi iscriverti? Clicca qui per le informazioni:"}
          ui.container{ attr = { class = "span4 text-center" }, content = function ()
            ui.link{
              module = "index",
              view = "register",
              attr = {class="btn btn-primary btn-large"},
              content= _"Guida alla registrazione"
            }
          end }
        end }
    end }

    ui.container{ attr = { id="registration", class = "span6 well" }, content = function ()
        ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
          ui.tag{ attr = { class="span8 text-center"}, content= _"Possiedi gia' un codice di invito? Clicca qui:"}
          ui.container{ attr = { class = "span4 text-center" }, content = function ()
            ui.link{
              module = "index",
              view = "register",
              attr = {class="btn btn-primary btn-large"},
              content= "Registrati"
            }
          end }
        end }
    end }

    ui.container{ attr = { id="lost_password", class = "span6 well" }, content = function ()
        ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
          ui.tag{ attr = { class="span8 text-center"}, content= _"Hai smarrito la password? Clicca qui:"}
          ui.container{ attr = { class = "span4 text-center" }, content = function ()
            ui.link{
                 attr = { class="btn btn-primary btn-large"},
                 text   = _"Reset password",
                 module = 'index',
                 view   = 'reset_password'
            }
          end }
        end }
    end }

  end }

end
