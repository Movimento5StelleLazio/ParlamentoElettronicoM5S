
local level=param.get("level",atom.integer)
local category=param.get("category", atom.integer)
local module=param.get("module")
local routing_page=param.get("routing_page")

--containerFiltri 
ui.container{

        attr={id="containerFiltriDiv", class="containerFiltriDiv" },
        
        content=function()
        
         
               --pulsante APPLICA FILTRI
               ui.tag{
                    tag = "a", 
                    attr={
                        id="pulsanteApplicaFiltri",
                        class="pulsanteFiltri button orange", 
                        onclick="document.getElementById('pulsanteApplicaFiltri').style.display='none';"
                              .."document.getElementById('containerPulsantiFiltri').style.display='block';"
                             
                        },
                    content=function()
                    
                        ui.tag{
                           tag = "span",
                           attr={class="applicaFiltri", readonly="true"},
                           content        =_"Do filters",  
                           multiline=true
                        }  
                    end-- fine tag.content
                }  
                
               
               --contenitore di tutti Pulsanti Filtri
               ui.container{
             
                      attr={id="containerPulsantiFiltri",class="containerPulsantiFiltri"},
                      content=function()
                     
                     if level==2 or level==5 then
                     -- pulsanti fase
                      ui.container{
                      
                              attr={id="pulsantiFase" ,class="pulsantiFase"},
                              content= function()
                              ui.tag{
                                         tag = "p",
                                         attr={class="phaseText", readonly="true"},
                                         content        = _"Filter Phase",  
                                         multiline=true
                                      }
                              
                              if level==2 then   
                              
                                
                                  --pulsante 1
                                    ui.link{
                                        module = module,
                                        view = routing_page,
                                        attr = {
                                                id="btnAllPhase",
                                                class = "button orange filterButton" ,
                                                onclick="document.getElementById('btnAllPhase').setAttribute('class','filterButton button green');"
                                                 },
                                        params  = { issue_state ="All",filter_state=true },
                                        content        =_"All phases"  
                                      }
                                      
                                    
                               
                              --pulsante 2
                                   ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnOpenPhase",
                                            class = "button orange filterButton",
                                            
                                            onclick="document.getElementById('btnOpenPhase').setAttribute('class','filterButton button green');"
                                           },
                                    params  = { issue_state ="Open", filter_state=true },
                                    content        =  _"Open phase" 
                                         
                                    }
                                   
                               
                                                           
                              --pulsante 3
                              
                                ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnNewPhase",
                                            class = " button orange filterButton",
                                           
                                            onclick="document.getElementById('btnNewPhase').setAttribute('class','filterButton button green');"
                                             },
                                    params  = { issue_state ="New", filter_state=true },
                                    content        = _"New phase" 
                                        
                                    
                                    }
                                    
                                    
                               end
                                
                                
                               if level==2 or (level==5 and category==2) then
                                
                                
                                                         
                                --pulsante 4
                                  ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnDiscussionPhase",
                                            class = " button orange filterButton",
                                           
                                            onclick="document.getElementById('btnDiscussionPhase').setAttribute('class','filterButton button green');"
                                             },
                                    params  = { issue_state ="Discussion",filter_state=true },
                                    content        =  _"Discussion phase"
                                        
                                    
                                    }
                                    
                               
                                  --pulsante 5
                                  
                                                                     
                                    ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnFrozenPhase", 
                                            class = " button orange filterButton", 
                                            
                                            onclick="document.getElementById('btnFrozenPhase').setAttribute('class','filterButton button green');"
                                           },
                                    params  = { issue_state ="Frozen",filter_state=true },
                                     content        =  _"Frozen phase" 
                                    }
                                    
                               
                                  --pulsante 6
                                                                
                                
                                   ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnVotationPhase", 
                                            class = "button orange filterButton", 
                                            
                                            onclick="document.getElementById('btnVotationPhase').setAttribute('class','filterButton button green');"
                                            },
                                    params  = { issue_state ="Votation",filter_state=true },
                                   content        = _"Voting phase" 
                                    
                                    }
                                
                               
                                
                                
                                                             
                                 --pulsante 7
                                
                                  ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnCommissionPhase",
                                            class = "button orange filterButton", 
                                         
                                            onclick="document.getElementById('btnCommissionPhase').setAttribute('class','filterButton button green');"
                                           },
                                    params  = { issue_state ="Commission",filter_state=true },
                                    content        =  _"Commission phase"
                                        
                                    
                                    }
                                   
                                  
                                end 
                                
                                if level==2 then
                                --pulsante 8
                               
                                  ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnClosedPhase",
                                            class = "button orange filterButton", 
                                           
                                            onclick="document.getElementById('btnClosedPhase').setAttribute('class','filterButton button green');"
                                           },
                                    params  = { issue_state ="Closed",filter_state=true },
                                      content        =  _"Closed phase"
                                    
                                    }
                                   
                                  --pulsante 9
                                  
                                   ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnCanceledPhase",
                                            class = "button orange filterButton",
                                            
                                            onclick="document.getElementById('btnCanceledPhase').setAttribute('class','filterButton button green');"
                                           },
                                    params  = { issue_state ="Canceled",filter_state=true },
                                   content        =  _"Canceled phase"
                                    
                                    
                                    }-- fine pulsante 9
                                   
                                    
                                    end
                                      
                               ui.container{
                                    attr={id="lineDiv" ,class="lineDiv"},
                                    content=""
                                  }  
                                   
                              end 
                      } -- fine pulsanti Fase
              
                  
                      
                      end 
                      
                      
                      if level ~= 2 then
                       -- pulsanti categoria
                      ui.container{
                      
                              attr={id="pulsantiCategoria" ,class="pulsantiCategoria"},
                              content= function()
                               
                                         ui.tag{
                                                   tag = "p",
                                                   attr={class="categoryText", readonly="true"},
                                                   content        = _"Filter Category",  
                                                   multiline=true
                                                   }
                                                   
                              --pulsanti
                                ui.container{
                      
                                      attr={id="pulsantiCategoriaDiv" ,class="pulsantiCategoriaDiv"},
                                      content= function()
                                      
                                      
                                      
                              
                               --pulsante 1
                                  
                                   ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnInterestedPhase",
                                            class = "button orange filterButton",
                                           
                                            onclick="document.getElementById('btnInterestedPhase').setAttribute('class','filterButton button green');"
                                           },
                                    params  = { issue_state ="Interested",filter_state=true },
                                    content        =  _"Interested"
                                    
                                    }
                                    
                                    
                               --pulsante 2
                                  
                                   ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnInitiatedPhase",
                                            class = "button orange filterButton",
                                          
                                            onclick="document.getElementById('btnInitiatedPhase').setAttribute('class','filterButton button green');"
                                           },
                                    params  = { issue_state ="Initiated",filter_state=true },
                                   content        =  _"Initiated"
                                    
                                    
                                    }
                              
                              
                               --pulsante 3
                                  
                                   ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnSupportedPhase",
                                            class = "button orange filterButton",
                                             
                                            onclick="document.getElementById('btnSupportedPhase').setAttribute('class','filterButton button green');"
                                           },
                                    params  = { issue_state ="Supported",filter_state=true },
                                  content        =  _"Supported"
                                    
                                    
                                    }
                              
                              
                                 --pulsante 4
                                  
                                   ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnPotentiallyPhase",
                                            class = " button orange filterButton",
                                            
                                            onclick="document.getElementById('btnPotentiallyPhase').setAttribute('class','filterButton button green');"
                                           },
                                    params  = { issue_state ="Potentially",filter_state=true },
                                    content        =  _"Potentially supported"
                                    }
                              
                                 --pulsante 5
                                  
                                   ui.link{
                                    module = module,
                                    view = routing_page,
                                    attr = {
                                            id="btnVotedPhase",
                                            class = " button orange filterButton",
                                            
                                            onclick="document.getElementById('btnVotedPhase').setAttribute('class','filterButton button green');"
                                           },
                                    params  = { issue_state ="Voted",filter_state=true },
                                     content        =  _"Voted"
                                        
                                    
                                    }
                              
                              
                              end
                              }
                               --linea di separazione
                             ui.container{
                                    attr={id="lineDiv2" ,class="lineDiv" },
                                    content=""
                                  }
                              
                              end
                      }   --fine pulsanti categoria     
               
                
                
                
                    end
                    
                    
                    if level == 2 then
                   -- pulsanti unità
                      ui.container{
                      
                              attr={id="pulsantiUnita" ,class="pulsantiUnita"},
                              content= function()
                              
                               ui.tag{
                                                   tag = "p",
                                                   attr={class="unitText", readonly="true"},
                                                   content        = _"Filter Unit",  
                                                   multiline=true
                                                   }
                              
                              
                              --pulsanti
                                ui.container{
                      
                                      attr={id="pulsantiUnitaDiv" ,class="pulsantiUnitaDiv"},
                                      content= function()
                              
                                  --pulsante 1
                                     ui.link{
                                      module = module,
                                      view = routing_page,
                                      attr = {
                                                id="btnAllUnitsPhase",
                                                class = "button orange filterButton",
                                               
                                                onclick="document.getElementById('btnAllUnitsPhase').setAttribute('class','filterButton button green');"
                                               },
                                      params  = { issue_state ="AllUnits",filter_state=true },
                                        content        =  _"All units"
                                        } --pulsante 1
                                        
                                        
                                    
                                   --pulsante 2
                                     ui.link{
                                      module = module,
                                      view = routing_page,
                                      attr = {
                                                id="btnMyUnitsPhase",
                                                class = " button orange filterButton",
                                                
                                                onclick="document.getElementById('btnMyUnitsPhase').setAttribute('class','filterButton button green');"
                                               },
                                      params  = { issue_state ="MyUnits", filter_state=true },
                                      content        =  _"My units"
                                        } --pulsante 2
                                          
                
                
                                    
                                     --pulsante 3
                                     ui.link{
                                      module = module,
                                      view = routing_page,
                                      attr = {
                                                id="btnPublicCitiziensUnitsPhase",
                                                class = "button orange filterButton",
                                               
                                                onclick="document.getElementById('btnPublicCitiziensUnitsPhase').setAttribute('class','filterButton button green');"
                                               },
                                      params  = { issue_state ="PublicCitiziensUnits", filter_state=true },
                                       content        =  _"Public Citiziens units"
                                        } --pulsante 3
                                          
                
                
                 
                                     --pulsante 4
                                     ui.link{
                                      module = module,
                                      view = routing_page,
                                      attr = {
                                                id="btnPublicElectedUnitsPhase",
                                                class = "button orange filterButton",
                                                
                                                onclick="document.getElementById('btnPublicElectedUnitsPhase').setAttribute('class','filterButton button green');"
                                               
                                              },
                                      params  = { issue_state ="PublicElectedUnits", filter_state=true },
                                       content        =  _"Public Elected units"
                                        } --pulsante 4
                                          
                
                                    --pulsante 5
                                     ui.link{
                                      module = module,
                                      view = routing_page,
                                      attr = {
                                                id="btnPublicOtherGroupsUnitsPhase",
                                                class = "button orange filterButton",
                                              
                                                onclick="document.getElementById('btnPublicOtherGroupsUnitsPhase').setAttribute('class','filterButton button green');"
                                               },
                                      params  = { issue_state ="PublicOtherGroupsUnits", filter_state=true },
                                       content        =  _"Public other groups units"
                                        } --pulsante 5
                                          
                
                
                                       
                
                                     --pulsante 6
                                     ui.link{
                                      module = module,
                                      view = routing_page,
                                      attr = {
                                                id="btnMyAreasPhase",
                                                class = "button orange filterButton",
                                               
                                                onclick="document.getElementById('btnMyAreasPhase').setAttribute('class','filterButton button green');"
                                               },
                                      params  = { issue_state ="MyAreas",filter_state=true },
                                      content        =  _"My areas"
                                        } --pulsante 6
                
                
                
                                     --pulsante 7
                                     ui.link{
                                      module = module,
                                      view = routing_page,
                                      attr = {
                                                id="btnNotMyAreasPhase",
                                                class = "button orange filterButton",
                                              
                                                onclick="document.getElementById('btnNotMyAreasPhase').setAttribute('class','filterButton button green');"
                                               },
                                      params  = { issue_state ="NotMyAreas",filter_state=true },
                                      content        =  _"Not My areas"
                                        } --pulsante 7
                 
                                 end
                                 }-- contenitore pulsanti unità
                            
                               ui.container{
                                    attr={id="lineDiv" ,class="lineDiv"},
                                    content=""
                                  }  
                            
                     end
                     }       
                    
                 end --fine end pulsanti unità
             
             
             
             
               end -- contenitore Pulsanti Filtri
             
               }   
                
                 
                
        end --fine containerFiltriDiv
}
