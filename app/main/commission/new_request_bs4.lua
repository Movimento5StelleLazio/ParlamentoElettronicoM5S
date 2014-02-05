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
        ui.image{ static = "svg/commission_box_step4.svg" }
          end }
        end }
    
       ui.container{attr={class="row-fluid  depression_box spaceline2 wood"},content=function()
        ui.container{attr={class="row-fluid"},content=function()
         ui.container{attr={class="span6 offset3 text-left spaceline4"},content=function()
         ui.tag{tag="h2",content=  "Commissione N° C999999 "} 
         ui.tag{tag="h2",content=  "Istituita il 00/00/0000"} 
         ui.tag{tag="h2",content=  "DATA LIMITE CONSEGNA: 00/00/0000"} 
           end }
          end }

        ui.container{attr={class="row-fluid"},content=function()
         ui.container{attr={class="span6 offset3 text-center spaceline3 depression_box bkgn"},content=function()
          ui.tag{tag="h3",content=  "La proposta è all' esame della commissione"}   
             end }
            end }
        ui.container{attr={class="row-fluid"},content=function()
         ui.container{attr={class="span10 offset1 text-center spaceline3"},content=function()
          ui.tag{tag="em",content=  "(La commissione composta da 12 esponenti esperti studierà la proposta e fornirà un parere entro 7 giorni dalla istituzione della commissione, durante i quali il testo verrà congelato)"}   
             end }
            end }

        ui.container{attr={class="row-fluid text-center"},content=function()
         ui.container{attr={class="span6 offset4 spaceline3"},content=function()
         ui.link{attr={class="btn btn-primary btn-large table-cell fixclick"},content=function()
         ui.image{ static = "svg/sola_lettura.svg" }
             end }
            end }

        ui.container{attr={class="row-fluid"},content=function()
         ui.container{attr={class="span10 offset1 text-left spaceline3"},content=function()
          ui.tag{tag="h3",content=  "AREA DI COMPETENZA"}   
             end }
            end }

	ui.container{attr={class="row-fluid"},content=function() 
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
 	 ui.container{attr={class="span10 offset1 text-left spaceline2"},content=function()
          ui.tag{tag="p",content=  "La commissione verrà istituita selezionando, con ordine casuale sempre diverso, docenti e ricercatori delle università pubbliche, scelti in base al ruollo e all' impact factor, a cui sarà inviata una mail di invito"}   
                  end }
                 end }

        ui.container{attr={class="row-fluid"},content=function()
         ui.container{attr={class="span10 offset1 text-left spaceline3"},content=function()
          ui.tag{tag="h3",content=  "MEMBRI DELLA COMMISSIONE"}   
             end }
            end }

        ui.container{attr={class="row-fluid"},content=function()
 	   ui.container{attr={class="span10 offset1 text-center depression_box "},content=function()
           ui.tag{tag="p",content=  "Area di competenza:"}   
                   end }                  

        ui.container{attr={class="row-fluid"},content=function() 
 	 ui.container{attr={class="span2 offset1 spaceline"},content=function()
         ui.link{attr={class="btn btn-primary btn-large table-cell fixclick"},content=function()
         ui.image{ static = "svg/pdf.svg" }
                  end }
                 end }

 	 ui.container{attr={class="span2 spaceline"},content=function()
         ui.link{attr={class="btn btn-primary btn-large table-cell fixclick"},content=function()
         ui.image{ static = "svg/odf.svg" }
                 end }                 
                end }

 	 ui.container{attr={class="span3 offset3 spaceline"},content=function()
         ui.link{attr={class="btn btn-primary btn-large table-cell fixclick"},content=function()
         ui.image{ static = "svg/find.svg" }
                 end }

         ui.container{attr={class="row-fluid spaceline4"},content=function()
                  end }
                 end }
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
