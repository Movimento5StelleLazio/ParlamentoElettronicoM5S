local welcomeText=_"Homepage welcome text"
welcomeText=welcomeText.._"Homepage welcome text2"



ui.container{

        attr={id="menuDiv", class="menuDiv"},
        
        
        content=function()
        
               ui.tag{
                   tag = "pre",
                   attr={class="welcomeText", readonly="true"},
                   content        = _"Homepage welcome".." "..app.session.member.name..",\n"..welcomeText,  
                   multiline=true
                   }
                   
                   
               slot.put("<br />")   
                 
               ui.tag{
                   tag = "pre",
                   attr={class="sceltaText", readonly="true"},
                   content        = _"Homepage what to do?".."\n".._"Homepage Choose action:",  
                   multiline=true
                   }  
                
                 
            ui.container
            {  
                attr={id="pulsantiMenuHomepageDiv", class="pulsantiMenuHomepageDiv"},
               content=function()   
               
               --pulsante 1
               ui.link{
                    attr={class="button orange menuButton"},
                    module="unit",
                    view="show_ext",
                    id=config.gui_preset.M5S.units["cittadini"].unit_id,
                    content=function()
                    
                        ui.tag{
                           tag = "pre",
                            attr={class="text-align: center; ", readonly="true"},
                           content        =_"Homepage read new issues",  
                           multiline=true
                        }  
                    end-- fine tag.content
                } 
                
               --pulsante 2
               ui.link{
                    
                    attr={class="button orange menuButton"},
                    module = "initiative",
                    view = "wizard_new",
                    params = { 
                                      unit={name="LazionM5S"},
                                      area = {name="testAreaName"} 
                                    },
                    content=function()
                    
                        ui.tag{
                           tag = "pre",
                           attr={class="text-align: center;", readonly="true"},
                           content        =_"Homepage write new issue",  
                           multiline=true,
                          
                        }  
                        
                    end-- fine tag.content
                } 
                
               --pulsante 3
               ui.link{
                    attr={class="button orange menuButton"},
                    module="unit",
                    view="show_ext",
                    id=config.gui_preset.M5S.units["eletti"].unit_id,
                    content=function()
                    
                        ui.tag{
                           tag = "pre",
                           attr={class="text-align: center;", readonly="true"},
                           content        =_"Homepage read m5s issues",  
                           multiline=true
                        }  
                    end-- fine tag.content
                } 
                
                
               --pulsante 4
               ui.link{
                    attr={class="button orange menuButton"},
                    module="unit",
                    view="show_ext",
                    id=config.gui_preset.M5S.units["altri_gruppi"].unit_id,
                    content=function()
                    
                        ui.tag{
                           tag = "pre",
                           attr={class="text-align: center;", readonly="true"},
                           content        =_"Homepage read other issues",  
                           multiline=true
                        }  
                    end-- fine tag.content
                }  
                
              end -- fine container.content
            }
            
        end
}
