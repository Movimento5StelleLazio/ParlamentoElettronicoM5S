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
                              .."document.getElementById('containerFiltriDiv').style.height='280px';"
                        },
                    content=function()
                    
                        ui.tag{
                           tag = "pre",
                           attr={class="text-align: center;", readonly="true"},
                           content        =_"Do filters",  
                           multiline=true
                        }  
                    end-- fine tag.content
                }  
                
               
               --contenitore di tutti Pulsanti Filtri
               ui.container{
             
                      attr={id="containerPulsantiFiltri",class="containerPulsantiFiltri"},
                      content=function()
                     
                      -- pulsanti fase
                      ui.container{
                      
                              attr={id="pulsantiFase" ,class="pulsantiFase"},
                              content= function()
                              
                              
                                           ui.tag{
                                                   tag = "pre",
                                                   attr={class="phaseText", readonly="true"},
                                                   content        = "FILTRA LE PROPOSTE MOSTRANDO SOLO QUELLE NELLA FASE:",  
                                                   multiline=true
                                                   }
                              
                              --pulsante 1
                                ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnAllPhase",
                                            class = "btnAllPhase  button orange " ,
                                            style="width: 85px; height:20px;",
                                            onclick="document.getElementById('btnAllPhase').setAttribute('class','btnAllPhase button green');"
                                             },
                                    params  = { issue_state ="All",filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={class="testoPulsanteFiltri", readonly="true"},
                                               content        =_"All phases"  
                                               
                                            }  
                                    end
                                  }
                             
                              --pulsante 2
                                   ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnOpenPhase",
                                            class = "btnOpenPhase button orange ",
                                            style="width: 85px;height:20px;",
                                            onclick="document.getElementById('btnOpenPhase').setAttribute('class','btnOpenPhase button green');"
                                           },
                                    params  = { issue_state ="Open", filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={class="testoPulsanteFiltri", readonly="true"},
                                               content        =_"Open phase" 
                                               
                                          }  
                                    end
                                     
                                    }
                               
                              --pulsante 3
                              
                                ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnNewPhase",
                                            class = "btnNewPhase button orange ",
                                            style="width: 85px;height:20px;",
                                            onclick="document.getElementById('btnNewPhase').setAttribute('class','btnNewPhase button green');"
                                             },
                                    params  = { issue_state ="New", filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={class="testoPulsanteFiltri", readonly="true"},
                                               content        = _"New phase" 
                                               
                                            }  
                                    end
                                    
                                    
                                    }
                               
                                
                                --pulsante 4
                                
                                
                                  ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnDiscussionPhase",
                                            class = "btnDiscussionPhase button orange ",
                                            style="width: 85px;height:20px;",
                                            onclick="document.getElementById('btnDiscussionPhase').setAttribute('class','btnDiscussionPhase button green');"
                                             },
                                    params  = { issue_state ="Discussion",filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={class="testoPulsanteFiltri", readonly="true"},
                                               content        =  _"Discussion phase"
                                               
                                            }  
                                    end
                                    
                                    
                                    }
                               
                                  --pulsante 5
                                  
                                  
                                    ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnFrozenPhase", 
                                            class = "btnFrozenPhase button orange ", 
                                            style="width: 85px;height:20px;",
                                            onclick="document.getElementById('btnFrozenPhase').setAttribute('class','btnFrozenPhase button green');"
                                           },
                                    params  = { issue_state ="Frozen",filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={class="testoPulsanteFiltri", readonly="true"},
                                               content        =  _"Frozen phase" 
                                               
                                            }  
                                    end
                                    
                                    
                                    }
                                
                               
                                  --pulsante 6
                                
                                
                                   ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnVotationPhase", 
                                            class = "btnVotationPhase button orange ", 
                                            style="width: 85px;height:20px;",
                                            onclick="document.getElementById('btnVotationPhase').setAttribute('class','btnVotationPhase button green');"
                                            },
                                    params  = { issue_state ="Votation",filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={class="testoPulsanteFiltri", readonly="true"},
                                               content        = _"Voting phase" 
                                               
                                            }  
                                    end
                                    
                                    
                                    }
                                 
                                --pulsante 7
                                
                                  ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnClosedPhase",
                                            class = "btnClosedPhase button orange ", 
                                            style="width: 85px;height:20px;",
                                            onclick="document.getElementById('btnClosedPhase').setAttribute('class','btnClosedPhase button green');"
                                           },
                                    params  = { issue_state ="Closed",filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={class="testoPulsanteFiltri", readonly="true"},
                                               content        =  _"Closed phase"
                                               
                                            }  
                                    end
                                    
                                    
                                    }
                                   
                                  --pulsante 8
                                  
                                    ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnCanceledPhase",
                                            class = "btnCanceledPhase button orange",
                                            style="width: 85px;height:20px;",
                                            onclick="document.getElementById('btnCanceledPhase').setAttribute('class','btnCanceledPhase button green');"
                                           },
                                    params  = { issue_state ="Canceled",filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={class="testoPulsanteFiltri", readonly="true"},
                                               content        =  _"Canceled phase"
                                               
                                            }  
                                    end
                                    
                                    
                                    }
                                   
                              end 
                      } -- fine pulsanti Fase
              
              
              
                      ui.container{
                                    attr={id="lineDiv" ,class="lineDiv"},
                                    content=""
                                  }
                      
                       -- pulsanti categoria
                      ui.container{
                      
                              attr={id="pulsantiCategoria" ,class="pulsantiCategoria"},
                              content= function()
                               
                                         ui.tag{
                                                   tag = "pre",
                                                   attr={class="categoryText", readonly="true"},
                                                   content        = "FILTRA LE PROPOSTE A CUI PARTECIPO MOSTRANDO SOLO QUELLE NELLA CATEGORIA:",  
                                                   multiline=true
                                                   }
                                                   
                              --pulsanti
                                ui.container{
                      
                                      attr={id="pulsantiCategoriaDiv" ,class="pulsantiCategoriaDiv"},
                                      content= function()
                                      
                                      
                                      
                              
                               --pulsante 1
                                  
                                    ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnInterestedPhase",
                                            class = "btnInterestedPhase button orange",
                                            style="width: 95px;height:20px;",
                                            onclick="document.getElementById('btnInterestedPhase').setAttribute('class','btnInterestedPhase button green');"
                                           },
                                    params  = { issue_state ="Interested",filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={class="testoPulsanteFiltri", readonly="true"},
                                               content        =  _"Interested"
                                               
                                            }  
                                    end
                                    
                                    
                                    }
                                    
                                    
                               --pulsante 2
                                  
                                    ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnInitiatedPhase",
                                            class = "btnInitiatedPhase button orange",
                                            style="width: 85px;height:20px;",
                                            onclick="document.getElementById('btnInitiatedPhase').setAttribute('class','btnInitiatedPhase button green');"
                                           },
                                    params  = { issue_state ="Initiated",filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={class="testoPulsanteFiltri", readonly="true"},
                                               content        =  _"Initiated"
                                               
                                            }  
                                    end
                                    
                                    
                                    }
                              
                              
                               --pulsante 3
                                  
                                    ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnSupportedPhase",
                                            class = "btnSupportedPhase button orange",
                                            style="width: 85px;height:20px;",
                                            onclick="document.getElementById('btnSupportedPhase').setAttribute('class','btnSupportedPhase button green');"
                                           },
                                    params  = { issue_state ="Supported",filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={class="testoPulsanteFiltri", readonly="true"},
                                               content        =  _"Supported"
                                               
                                            }  
                                    end
                                    
                                    
                                    }
                              
                              
                                 --pulsante 4
                                  
                                    ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnPotentiallyPhase",
                                            class = "btnPotentiallyPhase button orange",
                                            style="width: 100px;height:20px;",
                                            onclick="document.getElementById('btnPotentiallyPhase').setAttribute('class','btnPotentiallyPhase button green');"
                                           },
                                    params  = { issue_state ="Potentially",filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={ class="testoPulsanteFiltri testoPotenzialmenteSostenuto", style="line",readonly="true"},
                                               content        =  _"Potentially supported"
                                               
                                            }  
                                    end
                                    
                                    
                                    }
                              
                                 --pulsante 5
                                  
                                    ui.link{
                                    module = "index",
                                    view = "homepage",
                                    attr = {
                                            id="btnVotedPhase",
                                            class = "btnVotedPhase button orange",
                                            style="width: 85px;height:20px;",
                                            onclick="document.getElementById('btnVotedPhase').setAttribute('class','btnVotedPhase button green');"
                                           },
                                    params  = { issue_state ="Voted",filter_state=true },
                                    content=function()
                                    ui.tag{
                                               tag = "span",
                                               attr={class="testoPulsanteFiltri", readonly="true"},
                                               content        =  _"Voted"
                                               
                                            }  
                                    end
                                    
                                    
                                    }
                              
                              
                              end
                              }
                              
                              
                              end
                      }   --fine pulsanti categoria     
               
                
                 --linea di separazione
                      ui.container{
                                    attr={id="lineDiv2" ,class="lineDiv",style="margin-top:284px;"},
                                    content=""
                                  }
                
                --[[
                   -- pulsanti unità
                      ui.container{
                      
                              attr={id="pulsantiUnita" ,class="pulsantiUnita"},
                              content= function()
                              
                              --pulsanti
                                ui.container{
                      
                                      attr={id="pulsantiUnitaDiv" ,class="pulsantiUnitaDiv"},
                                      content= function()
                              
                                  --pulsante 1
                                      ui.link{
                                      module = "index",
                                      view = "homepage",
                                      attr = {
                                                id="btnAllUnitsPhase",
                                                class = "btnAllUnitsPhase button orange",
                                                style="width: 95px;height:20px;",
                                                onclick="document.getElementById('btnAllUnitsPhase').setAttribute('class','btnAllUnitsPhase button green');"
                                               },
                                      params  = { issue_state ="AllUnits",filter_state=true },
                                      content=function()
                                      ui.tag{
                                                   tag = "span",
                                                   attr={class="testoPulsanteFiltri", readonly="true"},
                                                   content        =  _"All units"
                                                   
                                                }  
                                        end
                                        } --pulsante 1
                                        
                                        
                                    
                                       --pulsante 2
                                      ui.link{
                                      module = "index",
                                      view = "homepage",
                                      attr = {
                                                id="btnMyUnitsPhase",
                                                class = "btnMyUnitsPhase button orange",
                                                style="width: 95px;height:20px;",
                                                onclick="document.getElementById('btnMyUnitsPhase').setAttribute('class','btnMyUnitsPhase button green');"
                                               },
                                      params  = { issue_state ="MyUnits",filter_state=true },
                                      content=function()
                                      ui.tag{
                                                   tag = "span",
                                                   attr={class="testoPulsanteFiltri testoMyUnits", readonly="true"},
                                                   content        =  _"My units"
                                                   
                                                }  
                                        end
                                        } --pulsante 2
                                          
                
                
                
                                       --pulsante 3
                                      ui.link{
                                      module = "index",
                                      view = "homepage",
                                      attr = {
                                                id="btnMyAreasPhase",
                                                class = "btnMyAreasPhase button orange",
                                                style="width: 95px;height:20px;",
                                                onclick="document.getElementById('btnMyAreasPhase').setAttribute('class','btnMyAreasPhase button green');"
                                               },
                                      params  = { issue_state ="MyAreas",filter_state=true },
                                      content=function()
                                      ui.tag{
                                                   tag = "span",
                                                   attr={class="testoPulsanteFiltri", readonly="true"},
                                                   content        =  _"My areas"
                                                   
                                                }  
                                        end
                                        } --pulsante 3
                
                
                                 end
                                 }-- contenitore pulsanti unità
                        
                       
                     end
                     }       
                     ]]--
                
             
               end -- contenitore Pulsanti Filtri
             
               }   
                
                 
                
        end --fine containerFiltriDiv
}
