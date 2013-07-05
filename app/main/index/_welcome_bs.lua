local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1] or 'default'

slot.set_layout("m5s_bs")



ui.script{static = "js/jquery.fittext.js"}
if not app.session.member_id then
  ui.container{attr = {class = "row-fluid" },content = function()
    ui.container{
      attr = {class = "text-center span8 offset2 well-title" },
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
              ui.tag{ attr={class="pull-right"}, tag = "small", content = "Versione 0.3" }
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
    ui.container{ attr = { class  = "span12 well text-center" }, content = function()

      ui.script{ static = "js/position.js" }

      --local curLogin = member:get_current_login_data()
      local curLogin = member:get_last_login_data()
      if curLogin and curLogin.geolat and curLogin.geolng and curLogin.login_time then

        trace.debug("curLogin.geolat:"..curLogin.geolat.." curLogin.geolng:"..curLogin.geolng)
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.container{ attr = { class  = "span12 alert location_data text-center" }, content = function()
  
            ui.container{attr = {class = "row-fluid" },content = function()
              ui.container{ attr = { class  = "span9 text-center" }, content = function()
  
                ui.container{attr = {class = "row-fluid" },content = function()
                  ui.container{ attr = { class  = "span12 text-left" }, content = function()
                    ui.heading{level=4,content=function()
                      slot.put( _("Welcome <strong>#{realname}</strong>.", {realname = member.realname}) )
                      slot.put(" ")
                      slot.put( _("You're connected "))
                      slot.put(" ")
                      ui.tag{ tag="span", attr = { id = "current_location"}, content="" }
                      ui.script{ script = 'codelatlng('..curLogin.geolat..','..curLogin.geolng..',"current_location","'.._"from "..'");'}
                    end }
                  end }
                end }
  
                
                ui.container{attr = {class = "row-fluid" },content = function()
                  ui.container{ attr = { class  = "span12 text-right" }, content = function()
                    ui.heading{level=6,content=function()
                      slot.put(_"If it is not so, press here:")
                      ui.image{ attr = { class="arrow_small"}, static="svg/arrow-right.svg"}
                    end }
                  end }
                end }
  
              end }
  
              ui.container{ attr = { class  = "span3 text-center" }, content = function()
                ui.anchor{
                  attr = {
                    href = "#",
                    class = "btn btn-primary table-cell medium_btn",
                    onclick = "alert('Posizione aggiornata! (Non implementato)');"
                  },
                  content=function()
                    ui.heading{level=6,attr={class="fittext_report"},content= _"Correct your position"}
                  end
                }
                ui.script{script = "jQuery('.fittext_report').fitText(1.0, {minFontSize: '19px', maxFontSize: '28px'}); " }
              end }
            end }
  
  
          end }
        end }
      else
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.container{ attr = { class  = "span12 alert location_data text-center" }, content = function()
            ui.container{attr = {class = "row-fluid" },content = function()
              ui.container{ attr = { class  = "span12" }, content = function()
                ui.heading{level=4,content=function()
                  slot.put( _("Welcome <strong>#{realname}</strong>.", {realname = member.realname}) )
                end }
              end }
            end }
            --[[
            ui.container{attr = {class = "row-fluid" },content = function()
              ui.container{ attr = { class  = "span12" }, content = function()
                ui.heading{level=5,content=function()
                  slot.put( _"Locazione utente non rilevata" )
                end }
              end }
            end }
            --]]
          end }
        end }
      end

      local lastLogin = member:get_last_login_data()
      if lastLogin and lastLogin.geolat and lastLogin.geolng and lastLogin.login_time then

        ui.container{attr = {class = "row-fluid spaceline" },content = function()
          ui.container{ attr = { class  = "span12 alert location_data2 text-center" }, content = function()
            ui.container{attr = {class = "row-fluid" },content = function()
  
              ui.container{ attr = { class  = "span9 text-center" }, content = function()
                ui.container{attr = {class = "row-fluid" },content = function()
  
                  ui.container{ attr = { class  = "span12 text-left" }, content = function()
                    ui.heading{level=4,content=function()
                      if lastLogin and lastLogin.login_time then
                        ui.tag{
                          content= _("Your last login was on #{last_login_date} at #{last_login_time}", {
                            last_login_date = format.date(lastLogin.login_time),
                            last_login_time = format.time(lastLogin.login_time)
                          })
                        }
                        slot.put("&nbsp;")
                        ui.tag{ tag="span", attr = { id = "location"}, content="" }
                        ui.script{ script = 'codelatlng('..lastLogin.geolat..','..lastLogin.geolng..',"location","'.._"from "..'");'}
                      end
                    end }
                  end }
  
                end }
  
                ui.container{attr = {class = "row-fluid" },content = function()
                  ui.container{ attr = { class  = "span12 text-right" }, content = function()
                    ui.heading{level=6,content=function()
                      slot.put(_"You didn't logged in from this location? Report it immediatly:")
                      ui.image{ attr = { class="arrow_small"}, static="svg/arrow-right.svg"}
                    end }
                  end }
                end }
  
              end }
  
              ui.container{ attr = { class  = "span3 text-center" }, content = function()
                ui.anchor{
                  attr = {
                    href = "#",
                    class = "btn btn-primary table-cell medium_btn", 
                    onclick = "alert('Dato sospetto segnalato! (Non implementato)' );"
                  },
                  content=function()
                    ui.heading{level=6,attr={class="fittext_report"},content= _"Report suspect data"}
                  end
                }
                ui.script{script = "jQuery('.fittext_report').fitText(1.0, {minFontSize: '19px', maxFontSize: '28px'}); " }
  
              end }
            end }
  
          end }
        end }

      end

      ui.container{attr = {class = "row-fluid spaceline" },content = function()
        ui.container{ attr = { class  = "span12 text-center" }, content = function()
          ui.heading{level=2,attr = { class  = "uppercase" }, content= _"Choose the assembly you want to participate:"}
        end }
      end }

      ui.container{attr = {class = "row-fluid" },content = function()
        ui.container{ attr = {class = "span6 text-center" }, content=function()
          ui.container{attr = {class = "row-fluid" },content = function()
            ui.container{attr = {class = "span12" },content = function()
              ui.image{attr = {class = "img_assembly_small" }, static="parlamento_icon_small.png" }
            end }
          end }
          ui.container{attr = {class = "row-fluid" },content = function()
            ui.tag{tag="span",attr={class="span12"},content=function()
              ui.container{attr = {class = "inline-block" },content = function()
                ui.link{
                  module="index",
                  view="homepage_bs",
                  attr = {class = "btn btn-primary btn-large large_btn_home table-cell eq1" },
                  content=function()
                    ui.heading{level=3,attr={class="fittext"},content= _"REGIONE LAZIO ASSEMBLY"}
                  end
                }
              end }
            end }
          end }
        end }
        ui.container{ attr = {class = "span6 text-center" }, content=function()
          ui.container{attr = {class = "row-fluid" },content = function()
            ui.container{attr = {class = "span12" },content = function()
              ui.image{ attr = {class = "img_assembly_small" }, static="parlamento_icon_small.png" }
            end }
          end }
          ui.container{attr = {class = "row-fluid" },content = function()
            ui.tag{tag="span",attr={class="span12"},content=function()
              ui.container{attr = {class = "inline-block" },content = function()
                ui.link{
                  attr = { class = "btn btn-primary btn-large large_btn_home table-cell eq1" },
                  module="unit",
                  view="show_ext_bs",
                  id=config.gui_preset[gui_preset].units["iscritti"].unit_id,
                  content=function()
                    ui.heading{level=3,attr={class="fittext"},content= _"5 STARS MOVEMENT LAZIO INTERNAL ASSEMBLY"}
                  end
                }
              end }
            end }
          end }
        end }
        ui.script{static = "js/jquery.equalheight.js"}
        ui.script{script = '$(document).ready(function() { equalHeight($(".eq1")); $(window).resize(function() { equalHeight($(".eq1")); }); }); ' }
      end }
    end }
  end }
  execute.view{module="index",view="_registration_info"}

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
            ui.container{ attr = { class = "span6 offset3" }, content = function()
              ui.tag{ 
                tag="button",
                attr = { type="submit", class="btn btn-primary btn-large" }, 
                content= function()
                  ui.heading{ level=4, attr = { class="inline-block"}, content= _"Login"}
                end 
              }
            end }
          end }
        end }
      end 
    }
    ui.container{ attr = { id="registration-info", class = "span6" }, content = function ()

      ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
        ui.container{ attr = { id="registration", class = "span12 well" }, content = function ()
          ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
            ui.tag{ attr = { class="span12 text-center"}, content=function()
              ui.tag{ tag="p",content= _"Possiedi gia' un codice di invito? Clicca qui:"}
            end }
          end }
          ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
            ui.container{ attr = { id="registration", class = "span12" }, content = function ()
              ui.link{
                attr = {class="btn btn-primary btn-large"},
                module = "index",
                view = "register",
                content = function()
                  ui.heading{ level=4,content= _"Registrati" }
                end 
              }
            end }
          end }
        end }
      end }

      ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
        ui.container{ attr = { id="lost_password", class = "span12 well" }, content = function ()
          ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
            ui.tag{ attr = { class="span12 text-center"}, content=function()
              ui.tag{ tag="p",content= _"Hai smarrito la password? Clicca qui:"}
            end }
          end }
          ui.container{ attr = { class = "row-fluid text-center" }, content = function ()
            ui.container{ attr = { id="lost_password", class = "span12" }, content = function ()
              ui.link{
                attr = { class="btn btn-primary btn-large"},
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
  end }

  execute.view{module="index",view="_registration_info"}

--ui.script{static = "js/jquery.fittext.js"}
--ui.script{script = "jQuery('.fittext_register').fitText(0.7, {minFontSize: '18px', maxFontSize: '28px'}); " }
--ui.script{script = "jQuery('.fittext').fitText(1.1, {minFontSize: '25px', maxFontSize: '28px'}); " }

end
