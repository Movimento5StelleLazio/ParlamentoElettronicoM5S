slot.set_layout("m5s_bs")
local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1] or 'default'

local issues_selector =Issue:new_selector()
  
local issues=issues_selector
  :add_where("issue.closed ISNULL")
  :add_order_by("coalesce(issue.fully_frozen + issue.voting_time, issue.half_frozen + issue.verification_time, issue.accepted + issue.discussion_time, issue.created + issue.admission_time) - now()")
  --:exec()

local issue_state=param.get("issue_state")
local filter_state=param.get("filter_state",atom.boolean)

if not issue_state then
    issue_state="open"
end

trace.debug("filter: issue_state="..issue_state)
 
local welcomeText=_"Homepage welcome text"
welcomeText=welcomeText.._"Homepage welcome text2"

ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 well text-center"},content=function()
    ui.heading{level=4, content=_("Welcome #{realname}.", {realname = app.session.member.realname})}
    ui.heading{level=4, content=_"You are now inside the Digital Assembly of M5S Lazio's Public Affairs."}
    ui.heading{level=4, content=_"Here laws and measures for Region and his citizens are being discussed."}
    ui.heading{level=3, content=_"What you want to do?"}
    ui.heading{level=3, content=_"Choose by pressing one of the following buttons:"}

    ui.container{attr={class="row-fluid"},content=function()
    
      ui.container{attr={class="span3"},content=function()
        ui.link{attr={class="btn btn-primary btn-large"},
          module="unit", view="show_ext_bs",
          id=config.gui_preset[gui_preset].units["cittadini"].unit_id,
          content=function()
            ui.heading{level=4, content=_"Homepage read new issues"}
          end }
      end }
    
      ui.container{attr={class="span3"},content=function()
        ui.link{attr={class="btn btn-primary btn-large"},
          module = "wizard", view = "show_ext",
          id=config.gui_preset[gui_preset].units["eletti"].unit_id,
          content=function()
            ui.heading{level=4, content=_"Homepage write new issue"}
          end }
      end }
    
      ui.container{attr={class="span3"},content=function()
        ui.link{attr={class="btn btn-primary btn-large"},
          module="unit", view="show_ext_bs",
          id=config.gui_preset[gui_preset].units["eletti"].unit_id,
          content=function()
            ui.heading{level=4, content=_"Homepage read m5s issues"}
          end }
      end }
       
      ui.container{attr={class="span3"},content=function()
        ui.link{attr={class="btn btn-primary btn-large"},
          module="unit", view="show_ext_bs",
          id=config.gui_preset[gui_preset].units["altri_gruppi"].unit_id,
          content=function()
            ui.heading{level=4, content=_"Homepage read other issues"}
          end }
      end }

    end }
  end }
end }


--containerFiltri 
execute.view{
        module="index" ,
        view="_filters_ext" , 
        params={ 
                level=2 ,
                module="index", 
                routing_page="homepage" 
                }
        }
 




       ----------spazio div         
 ui.container{
                  attr={class="spazioIssue", style="height:100px;width:100%;"},
                  content=function()
                  end
            } 
            
            
            
---container leggi
ui.container{

        attr={id="parlamentoDiv", class="parlamentoDiv"},
        
        
        content=function()

                   
-------le tue votazioni
        ui.container{
            
               attr={id="votazioniDiv", class="votazioniDiv"},
                    
                    
               content=function()
                  
--------immagine parlamento
                 ui.image{
                        attr = { class = "parlamentoImg" },
                        static = "parlamento_icon_small.png"
                      }
                    
      ----------spazio div         
                  ui.container
                  {
                  attr={class="spazioIssue"},
                  content=function()
                  end
                  } 
                  
------titolo "le Tue Votazioni"
               ui.tag{
                       tag="span",
                       attr={class="titolo"},
                       content= _"Your Voting"
                       }
             
             
----------spazio div         
               ui.container
                  {
                  attr={class="spazioIssue"},
                  content=function()
                  end
                  }
                     
           
               
---------------Paginazione
                execute.view{
                      module = "issue",
                      view   = "_votazioni_ext",
                      id     = "idLista",
                      params = {
                                for_state = issue_state,
                                issues_selector = issues_selector, 
                                view="votazioni"
                                },
                    }
                    end
                }
                    
                  
                   
                     
---------Le Tue Proposte
             ui.container{
            
                    attr={id="proposteDiv", class="proposteDiv"},
                    
                    content=function()
                  
             --------immagine parlamento
                 ui.image{
                        attr = { class = "parlamentoImg" },
                        static = "parlamento_icon_small.png"
                      }             
                  
             ----------spazio div         
                  ui.container
                  {
                  attr={class="spazioIssue"},
                  content=function()
                  end
                  } 
                    
                  ui.tag{
                       tag="span",
                       attr={class="titolo"},
                       content=_"Your Proposals"
                  }
             
             ----------spazio div         
                  ui.container
                  {
                      attr={class="spazioIssue"},
                      content=function()
                      end
                  }
                     
             ----issue render
                  execute.view{
                      module = "issue",
                      view   = "_proposte_ext",
                      id     = "idLista",
                      params = {
                                  for_state = issue_state,
                                  issues_selector = issues_selector,
                                  view="proposte"
                                },
                  }
             
                    
                    
                  end
               }
                    
        slot.put("<br /><br />")
        end
}


if filter_state then
 ui.script{
         script="document.getElementById('pulsanteApplicaFiltri').style.display='none';"
           .."document.getElementById('containerPulsantiFiltri').style.display='block';"
 }
  ui.script{
        -- script="document.getElementById('btn"..issue_state.."Phase').setAttribute('class','btn"..issue_state.."Phase button green');"
        script="document.getElementById('btn"..issue_state.."Phase').setAttribute('class','filterButton button green');"
             
 }
 
end


