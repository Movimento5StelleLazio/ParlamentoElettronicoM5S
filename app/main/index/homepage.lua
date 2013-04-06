local issues_selector =Issue:new_selector()
 
  
local issues=issues_selector
  :add_where("issue.closed ISNULL")
  :add_order_by("coalesce(issue.fully_frozen + issue.voting_time, issue.half_frozen + issue.verification_time, issue.accepted + issue.discussion_time, issue.created + issue.admission_time) - now()")
  :exec()
  
--local issues_selector = param.get("issues_selector", "table")
 
 




ui.title(_"Home")
slot.put("<br />")

--menu parlamento

ui.container{

        attr={id="menuDiv", class="menuDiv"},
        
        
        content=function()
        
        ui.field.text{
           label          = "test menuDiv",   
           }

        end
}


slot.put("<br /><br />")

---pulsanti filtro
ui.container{

        attr={id="pulsanteFiltriDiv", class="pulsanteFiltriDiv"},
        
        content=function()
        
        ui.field.text{
           label          = "Applica Filtri",   
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
                      view   = "_list_ext",
                      id     = "idLista",
                      params = {
                                 
                                for_state = "open",
                                issues_selector = issues_selector, for_area = true   
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
                     
             
                     execute.view{
                      module = "issue",
                      view   = "_list_ext",
                      id     = "idLista",
                      params = {
                                 
                                for_state = "open",
                                issues_selector = issues_selector, for_area = true   
                                },
                    }
             
                    
                    
                    end
                    }
                    
        slot.put("<br /><br />")
        end
}



slot.put("<br /><br />")
