slot.set_layout("custom")

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
  end }
end

if app.session.member_id then
  --util.help("index.index", _"Home")
  local member = Member:by_id(app.session.member.id)
  
  ui.container{attr = {class = "row-fluid" },content = function()
    ui.container{ attr = { class  = "span12 well text-center" }, content = function()
			ui.script{ static = "js/position.js" }
      
      local curLogin = member:get_login_data('last')

      -- Demo data start
      --------------------------------------------------------------------------
      --[[if not curLogin or not curLogin.geolat or not curLogin.geolng or not curLogin.login_time  then
        curLogin = { member_id = member.id, geolat = "41.87499810", geolng = "12.51125750", login_time = atom.timestamp:load("2013-07-10 18:05:55") }
      end]]
      --------------------------------------------------------------------------
      -- Stop demo data

      if curLogin and curLogin.geolat and curLogin.geolng and curLogin.login_time then

        trace.debug("curLogin.geolat:"..curLogin.geolat.." curLogin.geolng:"..curLogin.geolng)
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.container{ attr = { class  = "span12 alert location_data text-center" }, content = function()
  
            ui.container{attr = {class = "row-fluid" },content = function()
              ui.container{ attr = { class  = "span9 text-center" }, content = function()
  
                ui.container{attr = {class = "row-fluid" },content = function()
                  ui.container{ attr = { class  = "span12 text-left" }, content = function()
                    ui.heading{level=4,content=function()
                    	trace.debug(member.realname .. " " .. member.login)
                      slot.put( _("Welcome <strong>#{realname}</strong>.",  {realname = (member.realname ~= "" and member.realname or member.login)}) )
                      ui.tag{ tag="span", attr = { id = "current_location"}, content="" }
                      ui.script{ script = 'getLocation("current_location", " '.. _"You're connected from" ..'");'}                      
                    end }
                  end }
                end }
                
                --[[ui.container{attr = {class = "row-fluid" },content = function()
                  ui.container{ attr = { class  = "span12 text-right" }, content = function()
                    ui.heading{level=6,content=function()
                      slot.put(_"If it is not so, press here:")
                      ui.image{ attr = { class="arrow_small"}, static="svg/arrow-right.svg"}
                    end }
                  end }
                end }]]
  
              end }
  
              --[[ui.container{ attr = { class  = "span3 text-right" }, content = function()
                ui.anchor{
                  attr = {
                    href = "#",
                    class = "btn btn-primary fixclick",
                    onclick = "alert('Posizione aggiornata! (Non implementato)');"
                  },
                  content=function()
                    ui.heading{level=3 ,content= _"Correct your position"}
                  end
                }
                ui.script{script = "jQuery('.fittext_report').fitText(1.0, {minFontSize: '19px', maxFontSize: '28px'}); " }
              end }]]
            end }
  
  
          end }
        end }
      else
        ui.container{attr = {class = "row-fluid" },content = function()
          ui.container{ attr = { class  = "span12 alert location_data text-center" }, content = function()
            ui.container{attr = {class = "row-fluid" },content = function()
              ui.container{ attr = { class  = "span12" }, content = function()
                ui.heading{level=4,content=function()
                  slot.put( _("Welcome <strong>#{realname}</strong>.",  {realname = (member.realname ~= "" and member.realname or member.login)}) )
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

      --[[local lastLogin = member:get_login_data()
      if lastLogin and lastLogin.geolat and lastLogin.geolng and lastLogin.login_time then

        ui.container{attr = {class = "row-fluid spaceline" },content = function()
          ui.container{ attr = { class  = "span12 alert location_data2 text-center" }, content = function()
            ui.container{attr = {class = "row-fluid" },content = function()
  
              ui.container{ attr = { class  = "span9 text-center" }, content = function()
                ui.container{attr = {class = "row-fluid" },content = function()
  
                  ui.container{ attr = { class  = "span12 text-left" }, content = function()
                    ui.heading{level=4,content=function()
                        ui.tag{
                          content= _("Your last login was on #{last_login_date} at #{last_login_time}", {
                            last_login_date = format.date(lastLogin.login_time),
                            last_login_time = format.time(lastLogin.login_time)
                          })
                        }
                        slot.put("&nbsp;")
                        ui.tag{ tag="span", attr = { id = "last_location"}, content="" }
                        ui.script{ script = 'getLastLocation('..lastLogin.geolat..','..lastLogin.geolng..',"last_location", "'..  _"from " ..'");'} 
                    end }
                  end }
  
                end }
  
                --[ [ui.container{attr = {class = "row-fluid" },content = function()
                  ui.container{ attr = { class  = "span12 text-right" }, content = function()
                    ui.heading{level=6,content=function()
                      slot.put(_"You didn't logged in from this location? Report it immediatly:")
                      ui.image{ attr = { class="arrow_small"}, static="svg/arrow-right.svg"}
                    end }
                  end }
                end }] ]
  
              end }
  
              --[ [ui.container{ attr = { class  = "span3 text-right" }, content = function()
                ui.anchor{
                  attr = {
                    href = "#",
                    class = "btn btn-primary fixclick", 
                    onclick = "alert('Dato sospetto segnalato! (Non implementato)' );"
                  },
                  content=function()
                    ui.heading{level=3, content= _"Report suspect data"}
                  end
                }
                ui.script{script = "jQuery('.fittext_report').fitText(1.0, {minFontSize: '19px', maxFontSize: '28px'}); " }
  
              end }] ]
            end }
  
          end }
        end }

			else
			
			ui.container{attr = {class = "row-fluid spaceline" },content = function()
          ui.container{ attr = { class  = "span12 alert location_data2 text-center" }, content = function()
            ui.container{attr = {class = "row-fluid" },content = function()
  
              ui.container{ attr = { class  = "span9 text-center" }, content = function()
                ui.container{attr = {class = "row-fluid" },content = function()
  
                  ui.container{ attr = { class  = "span12 text-left" }, content = function()
                    ui.heading{level=4,content=function()
                      if lastLogin and lastLogin.login_time then
                        ui.tag{ content= _("This is your first connection") }
                      end
                    end }
                  end }
  
                end }
  
                --[ [ui.container{attr = {class = "row-fluid" },content = function()
                  ui.container{ attr = { class  = "span12 text-right" }, content = function()
                    ui.heading{level=6,content=function()
                      slot.put(_"You didn't logged in from this location? Report it immediatly:")
                      ui.image{ attr = { class="arrow_small"}, static="svg/arrow-right.svg"}
                    end }
                  end }
                end }] ]
  
              end }
  
              --[ [ui.container{ attr = { class  = "span3 text-right" }, content = function()
                ui.anchor{
                  attr = {
                    href = "#",
                    class = "btn btn-primary fixclick", 
                    onclick = "alert('Dato sospetto segnalato! (Non implementato)' );"
                  },
                  content=function()
                    ui.heading{level=3, content= _"Report suspect data"}
                  end
                }
                ui.script{script = "jQuery('.fittext_report').fitText(1.0, {minFontSize: '19px', maxFontSize: '28px'}); " }
  
              end }] ]
            end }
  
          end }
        end }
			
      end]]

      ui.container{attr = {class = "row-fluid spaceline" },content = function()
        ui.container{ attr = { class  = "span10 offset1 text-center" }, content = function()
          ui.heading{level=2,attr = { class  = "uppercase" }, content= _"Choose the assembly you want to participate:"}
        end }
                      	    ui.container{attr={class="span1 text-center "},content=function()
					ui.field.popover{
							attr={
								dataplacement="left",
								datahtml = "true";
								datatitle= _"Box di aiuto per la pagina",
								datacontent=_"Puoi interessarti, sostenere, ignorare o proporre emendamenti alla proposta, dare il tuo interessa allarga la platea dei votanti e quindi in percentuale il quorum da raggiungere per permettere alla proposta di passare alla votazione, emendare la proposta ti permette di proporre modifiche parziali da sottoporre al giudizio dell'assemblea",
								datahtml = "true",
								class = "text-center"
							},
							content = function() 
								ui.container{
								  attr={class="row-fluid"},
									content=function()
				        		ui.image { static = "png/tutor.png"}                                                
--								    ui.heading{level=3 , content= _"What you want to do?"}
									end 
								}
						  end 
						}
						end }
      end }

      -- inizio icone
      ui.container{attr = {class = "row-fluid" },content = function()
       ui.container{ attr = {class = "span6 text-center" },
content=function()
        ui.image{attr = {class = "img_assembly_small" },
static="parlamento_icon_small.png" }
       end }
       ui.container{ attr = {class = "span6 text-center" },
content=function()
        ui.image{ attr = {class = "img_assembly_small" },
static="parlamento_icon_small.png" }
       end }
      end }
			--  fine icone
			--  Bottoni

		  ui.container{attr = {class = "row-fluid" },content = function()
		    ui.container{attr = {class = "span6" },content = function()
		      ui.link{
		        attr = {class = "btn btn-primary btn-large large_btn fixclick" },
		        module="index",
		        view="homepage_bs",
		        content=function()
		        ui.heading{level=3, content= _"REGIONE LAZIO ASSEMBLY"}
		      end }
		     end }

	      ui.container{attr = {class = "span6" },content = function()
	        ui.link{
	          attr = { class = "btn btn-primary btn-large large_btn fixclick" },
	          module="index", view="homepage_private_bs",					
	          content=function()
	            ui.heading{level=3, content= _"5 STARS MOVEMENT LAZIO INTERNAL ASSEMBLY"}
          end }
	      end }
	    end }
	  end }
	end }
	--[[ execute.view{module="index",view="_registration_info"} ]]--
else
  if config.motd_public then
    local help_text = config.motd_public
    ui.container{
      attr = { class = "wiki motd" },
      content = function()
        slot.put(format.wiki_text(help_text))
    end }
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
                attr = { type="submit", class="btn btn-primary btn-large large_btn spaceline fixclick" }, 
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
            ui.container{ attr = { id="registration", class = "span12 spaceline" }, content = function ()
              ui.link{
                attr = {class="btn btn-primary btn-large large_btn fixclick"},
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
            ui.container{ attr = { id="lost_password", class = "span12 spaceline" }, content = function ()
              ui.link{
                attr = { class="btn btn-primary btn-large fixclick"},
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
--  execute.view{module="index",view="_registration_info"}
end
