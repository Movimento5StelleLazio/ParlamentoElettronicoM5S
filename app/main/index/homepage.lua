local issues_selector =Issue:new_selector()
 
  
local issues=issues_selector
  :add_where("issue.closed ISNULL")
  :add_order_by("coalesce(issue.fully_frozen + issue.voting_time, issue.half_frozen + issue.verification_time, issue.accepted + issue.discussion_time, issue.created + issue.admission_time) - now()")
  :exec()
  
--local issues_selector = param.get("issues_selector", "table")
 
 
local welcomeText="TI TROVI NELL'ASSEMBLEA ELETTRONICA DEL M5S LAZIO DEDICATA ALLA COSA PUBBLICA.\n"
welcomeText=welcomeText.."QUI SI DISCUTONO LEGGI E PROVVEDIMENTI CHE RIGUARDANO LA REGIONE E I SUOI CITTADINI."



--ui.title(_"Home")
slot.put("<br />")

--menu parlamento

ui.container{

        attr={id="menuDiv", class="menuDiv"},
        
        
        content=function()
        
               ui.tag{
                   tag = "pre",
                   attr={class="welcomeText", readonly="true"},
                   content        = "BENVENUTO "..app.session.member.name..",\n"..welcomeText,  
                   multiline=true
                   }
                   
                   
               slot.put("<br />")   
                 
               ui.tag{
                   tag = "pre",
                   attr={class="sceltaText", readonly="true"},
                   content        = "COSA VUOI FARE?".."\n".."SCEGLI PREMENDO UNO DI QUESTI BOTTONI:",  
                   multiline=true
                   }  
                
                
            --slot.put("<a   class='button green'><pre style='text-align: center;'>LEGGI LE NUOVE <br>PROPOSTE<br>DEI CITTADINI</pre></a> ")
                
            ui.container
            {  
                attr={id="pulsantiMenuHomepageDiv", class="pulsantiMenuHomepageDiv"},
               content=function()   
               
               --pulsante 1
               ui.tag{
                    tag = "a", 
                    attr={class="button green menuButton", onclick="alert('molla il mouse!')"},
                    content=function()
                    
                        ui.tag{
                           tag = "pre",
                            attr={class="text-align: center; ", readonly="true"},
                           content        ="LEGGI LE NUOVE\nPROPOSTE\nDEI CITTADINI",  
                           multiline=true
                        }  
                    end-- fine tag.content
                } 
                
               --pulsante 2
               ui.tag{
                    tag = "a", 
                    attr={class="button green menuButton", onclick="alert('molla il mouse!')"},
                    content=function()
                    
                        ui.tag{
                           tag = "pre",
                           attr={class="text-align: center;", readonly="true"},
                           content        ="SCRIVI UNA TUA\nPROPOSTA DI\nLEGGE",  
                           multiline=true
                        }  
                    end-- fine tag.content
                } 
                
               --pulsante 3
               ui.tag{
                    tag = "a", 
                    attr={class="button green menuButton" , onclick="alert('molla il mouse!')"},
                    content=function()
                    
                        ui.tag{
                           tag = "pre",
                           attr={class="text-align: center;", readonly="true"},
                           content        ="LEGGI E VOTA LE\nPROPOSTE DEI\nPORTAVOCE M5S",  
                           multiline=true
                        }  
                    end-- fine tag.content
                } 
                
                
               --pulsante 4
               ui.tag{
                    tag = "a", 
                    attr={class="button green menuButton" , onclick="alert('molla il mouse!')"},
                    content=function()
                    
                        ui.tag{
                           tag = "pre",
                           attr={class="text-align: center;", readonly="true"},
                           content        ="LEGGI E VOTA LE\nPROPOSTE DEI\nGRUPPI POLITICI",  
                           multiline=true
                        }  
                    end-- fine tag.content
                }  
                
                
                
                
                    
               end -- fine container.content
            }
            
        end
}


slot.put("<br /><br />")

--pulsanti filtro
ui.container{

        attr={id="pulsanteFiltriDiv", class="pulsanteFiltriDiv" , onclick="alert('molla il mouse!')"},
        
        content=function()
        
         
               --pulsante FILTRI
               ui.tag{
                    tag = "a", 
                    attr={class="pulsanteFiltri button green"},
                    content=function()
                    
                        ui.tag{
                           tag = "pre",
                           attr={class="text-align: center;", readonly="true"},
                           content        ="APPLICA FILTRI",  
                           multiline=true
                        }  
                    end-- fine tag.content
                }  
                
        end
}

 

 ----------spazio div         
                  ui.container
                  {
                  attr={class="spazioIssue", style="height:130px"},
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
                       content="Le Tue Votazioni"
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
                                 
                                for_state = "open",
                                issues_selector = issues_selector, 
                                for_area = true,
                                view="votazioni"
                                },
                    }
                    end
                    }
                    
                  
----------spazio tra i div Votazioni e Proposte
                ui.container{
            
                     attr={id="spazioDiv", class="spazioDiv"},
                     
                     content=function()
                     
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
                       content="Le Tue Proposte"
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
                                 
                                    for_state = "open",
                                    issues_selector = issues_selector,
                                    for_area = true,
                                    view="proposte"
                                },
                  }
             
                    
                    
                  end
               }
                    
        slot.put("<br /><br />")
        end
}



slot.put("<br /><br />")
