local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1] or 'default'
slot.set_layout("m5s_bs")

if not app.session.member_id then
  ui.container{attr = {class = "row-fluid" },content = function()
    ui.container{
      attr = {class = "text-center span8 offset2 well" },
      content = function()
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.container{attr = {class = "span12" },content = function()
            ui.heading{level=1,content=function()
              slot.put( _"5 STARS MOVEMENT E-PARLIAMENT REGIONE LAZIO")
            end }
          end }
        end }
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.container{attr = {class = "span12" },content = function()
            ui.heading{level=5,content=function()
              ui.tag{ attr={class="pull-right"}, tag = "small", content = "Versione 0.2" }
            end }
          end }
        end }
      end
    }
  end}
end

if app.session.member_id then
  util.help("index.index", _"Home")
  local member = Member:by_id(app.session.member.id)

  ui.container{attr = {class = "row-fluid" },content = function()

    ui.container{ attr = { class  = "well span10 offset1 text-center" }, content = function()
   
      -- Codifica coordinate memorizzate in member_login
      local lastLogin = member:get_last_login_data()
      if lastLogin and lastLogin.geolat and lastLogin.geolng and lastLogin.login_time then
        trace.debug('Calling codelatlng('..lastLogin.geolat..','..lastLogin.geolng..',"location","'.._"from "..'");')
        ui.script{ static = "js/position.js" }
        ui.script{ script = 'codelatlng('..lastLogin.geolat..','..lastLogin.geolng..',"location","'.._"from "..'");'}
      else
        trace.debug('Cannot retrieve coordinates from database')
      end
      ui.heading{level=4,content=function()
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
      end }
      ui.tag{ tag="h3", content= _"Scegli l'assemblea alla quale vuoi partecipare:"}

    end }
  
  end }

  ui.container{attr = {class = "row-fluid" },content = function()

    ui.container{ 
      attr = {class = "well span5 offset1 text-center" },
      content=function()
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.container{attr = {class = "span12" },content = function()
            ui.image{static="parlamento_icon_small.png" } 
          end }
        end }
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.tag{tag="span",attr={class="span12"},content=function()
            ui.link{
              module="index", 
              view="homepage", 
              attr = {id = "region_assembly_btn", class = "btn btn-primary btn-large" }, 
              content=function()
                ui.heading{level=4,content= _"REGIONE LAZIO ASSEMBLY"}
              end
            }
          end }
        end }
      end
    }

    ui.container{ 
      attr = {class = "well span5 text-center" }, 
      content=function()
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.container{attr = {class = "span12" },content = function()
            ui.image{ static="parlamento_icon_small.png" }
          end }
        end }
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.tag{tag="span",attr={class="span12"},content=function()
            ui.link{ 
              attr = { id = "internal_assembly_btn", class = "btn btn-primary btn-large" }, 
              module="unit", 
              view="show_ext", 
              id=config.gui_preset[gui_preset].units["iscritti"].unit_id,
              content=function()
                ui.heading{level=4,content= _"5 STARS MOVEMENT LAZIO INTERNAL ASSEMBLY"}
              end
            }
          end }
        end }
      end
    }

  end }
  ui.script{static = "js/jquery.equalheight.js"}
  ui.script{script = '$(document).ready(function() { equalHeight($(".eq1")); $(window).resize(function() { equalHeight($(".eq1")); }); }); ' }
--  ui.script{static = "js/jquery.fittext.js"}
--  ui.script{script = "jQuery('.fittext').fitText(1.1, {minFontSize: '10px', maxFontSize: '23px'}); " }

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
            ui.tag{ tag = "legend",attr = { class = "span12 text-center" }, content = function()
              ui.heading{level=5,content= _"Insert user name and password to access:" }
            end }
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
             ui.tag{ 
               tag="button", 
               attr = { type="submit", class="btn btn-primary btn-large span4 offset4 " }, 
               content= function()
                 ui.heading{ level=5,content= _"Login"}
               end 
             }
          end }
        end }
      end 
    }
    ui.container{ attr = { id="registration-info", class = "span6" }, content = function ()

      ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
        ui.container{ attr = { id="registration-info", class = "span12 well" }, content = function ()
          ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
            ui.tag{ attr = { class="span5 text-center"}, content=function()
              ui.heading{ level=5,content= "Sei un cittadino del Lazio e vuoi iscriverti? Clicca qui per le informazioni:" }
            end }
            ui.link{
              attr = {class="span7 btn btn-primary btn-large"},
              module = "index",
              view = "register",
              content = function()
                ui.heading{ level=4,content= _"Guida alla registrazione" }
              end 
            }
          end }
        end }
      end }

      ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
        ui.container{ attr = { id="registration", class = "span12 well" }, content = function ()
          ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
            ui.tag{ attr = { class="span5 text-center"}, content=function()
              ui.heading{ level=5,content= _"Possiedi gia' un codice di invito? Clicca qui:"}
            end }
            ui.link{
              attr = {class="span7 btn btn-primary btn-large"},
              module = "index",
              view = "register",
              content = function()
                ui.heading{ level=4,content= _"Registrati" }
              end 
            }
          end }
        end }
      end }

      ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
        ui.container{ attr = { id="lost_password", class = "span12 well" }, content = function ()
          ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
            ui.tag{ attr = { class="span5 text-center"}, content=function()
              ui.heading{ level=5,content= _"Hai smarrito la password? Clicca qui:"}
            end }
            ui.link{
              attr = { class="span7 btn btn-primary btn-large"},
              module = 'index',
              view   = 'reset_password',
              content = function()
                ui.heading{ level=4,content= _"Reset Password"}
              end
            }
          end }
        end }
      end }

    end }

  end }
--  ui.script{static = "js/jquery.fittext.js"}
--  ui.script{script = "jQuery('.fittext').fitText(0.7, {minFontSize: '10px', maxFontSize: '19px'}); " }

end
