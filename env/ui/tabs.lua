function ui.tabs(tabs)
  local attr = tabs.attr or {}
  attr.class = (attr.class and attr.class .. " " or "") .. "row-fluid"
  ui.container{
    attr = attr,
    content = function()
      local params = param.get_all_cgi()
      local current_tab = params["tab"]
     ui.container{ attr = { class = "row-fluid" }, content = function()
			ui.container{ attr = { class = "span12 well text-center spaceline spaceline-bottom" },	content = function()
     ui.container{ attr = { class = "row-fluid" }, content = function()
			ui.container{ attr = { class = "span11" },	content = function()
		        for i, tab in ipairs(tabs) do
		          local params = param.get_all_cgi()
		          if tab.link_params then
		            for key, value in pairs(tab.link_params) do
		              params[key] = value
		            end
		          end
		          params["tab"] = i > 1 and tab.name or nil
		          ui.link{
		            attr = { 
		              class = "btn btn-primary large_btn margin_line spaceline spaceline-bottom", (
		                tab.name == current_tab and "selected" .. (tab.class and (" " .. tab.class) or "") or
		                not current_tab and i == 1 and "selected" .. (tab.class and (" " .. tab.class) or "") or
		                "" .. (tab.class and (" " .. tab.class) or "")
		              )
		            },
		            module  = request.get_module(),
		            view    = request.get_view(),
		            id      = param.get_id_cgi(),
		            content = tab.label,
		            params  = params
		          }
		          slot.put(" ")
		        end
		      end
		    }
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
              end
			}
			              end
			}
			              end
			}
      for i, tab in ipairs(tabs) do
        if tab.name == current_tab and i > 1 then
                                              app.html_title.prefix = tab.label
              end
        if tab.name == current_tab or not current_tab and i == 1 then
          ui.container{
            attr = { class = "table table-stripped" },
            content = function()
              if tab.content then
                tab.content()
              else
                execute.view{
                  module = tab.module,
                  view   = tab.view,
                  id     = tab.id,
                  params = tab.params,
                }
              end
            end
          }
        end
      end
    end
  }
end
