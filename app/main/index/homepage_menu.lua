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
               ui.tag{
                    tag = "a", 
                    attr={class="button orange menuButton", onclick="alert('molla il mouse!')"},
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
               ui.tag{
                    tag = "a", 
                    attr={class="button orange menuButton", onclick="alert('molla il mouse!')"},
                    content=function()
                    
                        ui.tag{
                           tag = "pre",
                           attr={class="text-align: center;", readonly="true"},
                           content        =_"Homepage write new issue",  
                           multiline=true
                        }  
                    end-- fine tag.content
                } 
                
               --pulsante 3
               ui.tag{
                    tag = "a", 
                    attr={class="button orange menuButton" , onclick="alert('molla il mouse!')"},
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
               ui.tag{
                    tag = "a", 
                    attr={class="button orange menuButton" , onclick="alert('molla il mouse!')"},
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
