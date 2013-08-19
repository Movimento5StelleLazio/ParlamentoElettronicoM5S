slot.set_layout("custom")
local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1] or 'default'



local area_policies=AllowedPolicy:get_policy_by_area_id(area_id)



if #area_policies>0 then
                       
         for i, allowed_policy in ipairs(area_policies) do
            dataSource[#dataSource+1] = {id=allowed_policy.policy_id }
         end   
 
 trace.debug("dataSource lenght="..#dataSource)                         
 else
                         
end

if not page  or page <= 1 then
    page=1
    btnBackModule ="commission"
    btnBackView = "new_request_bs"
end

    ui.container{attr={class="row-fluid"},content=function()
     ui.container{attr={class="span12 well"},content=function()


      ui.container{attr={class="row-fluid"},content=function()
       ui.container{attr={class="span2 offset1 text-center"},content=function()
        ui.image{ static = "svg/committee.svg" }
      end }
    

     ui.container{attr={class="span8 spaceline2"},content=function()
      ui.heading{level=1,attr={class="uppercase"}, content=  "Rapporto commissione tecnica" }
        ui.heading{level=2,attr={class=""}, content=  "Nessuna commissione istituita" }
      end }
     end } 
     ui.container{attr={class="row-fluid spaceline"},content=function()
      ui.container{attr={class="span12 text-center"},content=function()
        ui.image{ static = "svg/commission_box_step1.svg" }
      
      end }
     end }
    
       ui.container{attr={class="row-fluid  depression_box spaceline2 wood"},content=function()


        ui.container{attr={class="row-fluid"},content=function()
         ui.container{attr={class="span10 offset1 text-center spaceline3"},content=function()
          ui.tag{tag="h3",content=  "Hai deciso di richiedere una commissione tecnica. Devi decidere quali campi di competenza proporre come requisiti dei commissari. Scegli se lasciare le aree di competenza suggerite dall'a autore della questione, o se rimuoverle e metterne altre:"}   
           ui.heading{level=2,attr={class="spaceline2"}, content=  "Competenze richieste (non più di 4)" } 
                   end }
                end }

	ui.container{attr={class="row-fluid spaceline2"},content=function() 
 	 ui.container{attr={class="span10 offset1 text-center depression_box ", style="height:150px;"},content=function()
           ui.tag { 
           tag = "h4", 
           attr = { class  = "span2 offset2 text-center btn btn-info btn-small filter_btn nowrap spaceline4"  }, 
           content = "Biologia" 
           }
           ui.tag { 
           tag = "h4", 
           attr = { class  = "span2 text-center btn btn-info btn-small filter_btn nowrap spaceline4"  }, 
           content = "Cimica" 
           }
           ui.tag { 
           tag = "h4", 
           attr = { class  = "span2 text-center btn btn-info btn-small filter_btn nowrap spaceline4"  }, 
           content = "Ambiente" 
           }
           ui.tag { 
           tag = "h4", 
           attr = { class  = "span2 text-center btn btn-info btn-small filter_btn nowrap spaceline4"  }, 
           content = "Salute" 
           }


               end }
              end }
            

        ui.container{attr={class="row-fluid", style="height:150px;"},content=function() 
 	 ui.container{attr={class="span10 offset1 text-center spaceline2"},content=function()
          ui.tag{tag="h4",content=  "PER RIMUOVERE UN' AREA PREMI IL BOTTONE CORRISPONDENTE QUI SOPRA."}  
           ui.tag{tag="h4",content=  "PER AGGIUNGERLA, SELEZIONARLA DALLA LISTA QUI SOTTO POI PREMI AGGIUNGI"}  
                  end }
                 end }

            ui.container{attr={class="row-fluid"},content=function() 	  
             ui.container{attr={class="span3 offset2"},content=function() 
              ui.image{ static = "select.png" }
 	       end } 

         ui.container{attr={class="span3 offset1 text-center" },content=function()
                 ui.tag{
                 tag="a",
                 attr={
                 id="select_btn",
                 href="#",
                 class="btn btn-primary btn-large table-cell fixclick"
                 }, content=function()
                    ui.image{ attr = { class="text-center"}, static = "svg/aggiungi.svg"}
                  end } 
                 end }
                end }

          ui.container{attr={class="row-fluid spaceline4"},content=function()
            ui.container{attr={class="span3 offset1 spaceline4"},content=function()
             ui.tag{
                 tag="a",
                 attr={
                 id="select_btn",
                 href="#",
                 class="btn btn-primary btn-large table-cell fixclick"
                 }, content=function()
            
                  ui.image{ attr = { class="text-center"}, static = "svg/cancella_richiesta.svg"} 

                    end }                 
                   end }
            ui.container{attr={class="span3 offset4 spaceline4"},content=function()
             ui.tag{
                 tag="a",
                 attr={
                 id="select_btn",
                 href="#",
                 class="btn btn-primary btn-large table-cell fixclick"
                 }, content=function()
            
                  ui.image{ attr = { class="text-center"}, static = "svg/invia_richiesta.svg"} 


 
                   end }
ui.container{attr={class="row-fluid spaceline4"},content=function()
                   end }
                  end }
                 end }
                end }
               end }
              end }


ui.script{static = "js/jquery.fittext.js"}
ui.script{script = "jQuery('.fittext_back_btn').fitText(1.1, {minFontSize: '17px', maxFontSize: '32px'}); " }                  
ui.script{static = "js/jquery.equalheight.js"}
ui.script{script = '$(document).ready(function() { equalHeight($(".issue_brief_span")); $(window).resize(function() { equalHeight($(".issue_brief_span")); }); }); ' }

ui.script{script = '$(document).ready(function() { equalHeight($(".issue_keywords")); $(window).resize(function() { equalHeight($(".issue_keywords")); }); }); ' }
ui.script{script = '$(document).ready(function() { equalHeight($(".issue_desc")); $(window).resize(function() { equalHeight($(".issue_desc")); }); }); ' }
ui.script{script = '$(document).ready(function() { equalHeight($(".aim_desc")); $(window).resize(function() { equalHeight($(".aim_desc")); }); }); ' }
ui.script{script = '$(document).ready(function() { equalHeight($(".init_brief")); $(window).resize(function() { equalHeight($(".init_brief")); }); }); ' }
ui.script{script = '$(document).ready(function() { equalHeight($(".draft")); $(window).resize(function() { equalHeight($(".draft")); }); }); ' }

ui.script{static="js/jquery.tagsinput.js"}
ui.script{script="$('#issue_keywords').tagsInput({'height':'96%','width':'96%','defaultText':'".._"Add a keyword".."','maxChars' : 20});"}


 
 

