slot.select('navbar', function()

    ui.tag { tag="ul", attr={class="nav"}, content= function()
      ui.tag { tag="li", content=function()
        ui.link{
          content = function()
            ui.image{static = "logo_withe.png"}
          end,
          module = 'index',
          view   = 'index'
        }
      end }
    
    end }
    ui.container{ attr={ class="btn-group nav pull-right" }, content = function()
			ui.tag{
				tag = "a",
				attr = { datatoggle="dropdown", class="btn btn-primary fixclick btn-dropdown-toggle"},
				module = "index",
				view = "menu_ext",
				content = function()
					if app.session.member_id then
						execute.view{
							module = "member_image",
							view = "_show",
							params = {
								member = app.session.member,
								image_type = "avatar",
								show_dummy = true,
								class = "micro_avatar",
							}
						}
						slot.put("&nbsp;"..app.session.member.name )
					else
--								ui.tag{ tag ="i" , attr = { class = "iconic black flag" }, content=""}
						slot.put("&nbsp;".. _"Select language" )
					end
				end
			}  
		  execute.view{ module = "index", view = "_menu_ext" }        
			end
  	}
end)

slot.select("footer_bs", function()
  if app.session.member_id and app.session.member.admin then
    ui.link{
      text   = _"Admin",
      module = 'admin',
      view   = 'index'
    }
    slot.put(" &middot; ")
  end
  ui.link{
    text   = _"About site",
    module = 'index',
    view   = 'about'
  }
  if config.use_terms then
    slot.put(" &middot; ")
    ui.link{
      text   = _"Use terms",
      module = 'index',
      view   = 'usage_terms'
    }
  end
  slot.put(" &middot; ")
  ui.tag{ content = _"This site is using" }
  slot.put(" ")
  ui.link{
    text   = _"LiquidFeedback",
    external = "http://www.public-software-group.org/liquid_feedback"
  }
end
)

execute.inner()
