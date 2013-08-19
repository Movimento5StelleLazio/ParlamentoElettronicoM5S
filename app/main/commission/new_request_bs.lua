slot.set_layout("custom")
local gui_preset=db:query('SELECT gui_preset FROM system_setting')[1][1] or 'default'

local area_id=param.get("area_id" )
local unit_id=param.get("unit_id" )

local area_policies=AllowedPolicy:get_policy_by_area_id(area_id)

local dataSource
dataSource = { 
               { id = 0, name = _"Please choose a policy" }
        }

if #area_policies>0 then
                       
         for i, allowed_policy in ipairs(area_policies) do
            dataSource[#dataSource+1] = {id=allowed_policy.policy_id }
         end   
 
 trace.debug("dataSource lenght="..#dataSource)                         
 else
                         
end


local page=param.get("page",atom.integer)


local btnBackModule = "commission"
local btnBackView = "new_request_bs"

if not page  or page <= 1 then
    page=1
    btnBackModule ="commission"
    btnBackView = "new_request_bs"
end

local previus_page=page-1
local next_page=page+1

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
        ui.image{ static = "svg/commission_box_step0.svg" }
      end }
     end }

     ui.container{attr={class="row-fluid  depression_box spaceline2 wood"},content=function()
      ui.container{attr={class="span5 offset1 text-justify spaceline4"},content=function()
       ui.tag{tag="p",content=  "Se ritieni che per giudicare la validità di quest proposta sia necessario richiedere il parere di una commissione tecnica di esperti nel campo sepcifico premi questo Bottone:"}     
       end }

     ui.container{attr={class="span2 text-center spaceline4"},content=function()
      ui.image{ static = "svg/arrow-right.svg" }
       end }

     ui.container{attr={class="span3 text-center spaceline2"},content=function()
      ui.link{attr={class="btn btn-primary btn-large large_btn table-cell fixclick"},content=function()
       ui.image{ static = "svg/richiedi_commissione.svg" }
      end }
     end }

     ui.container{attr={class="row-fluid"},content=function()
      ui.container{attr={class="span5 offset1 text-justify spaceline4"},content=function()
       ui.tag{tag="p",content=  "La commissione verrà istituita selezionando, con ordine casuale sempre diverso, docenti e ricercatori delle universita pubbliche, scelti in base al ruolo e all' impact factor, a cui sarà inviata una mail di invito, per conoscere i dettagli dell alogritmo, premere questo bottone:"}     
          end }

     ui.container{attr={class="span3 offset2 text-center spaceline4"},content=function()
      ui.link{attr={class="btn btn-primary btn-large large_btn table-cell fixclick"},content=function()
       ui.image{ static = "svg/leggi_come_funziona.svg" }
          end }
       
     ui.container{attr={class="row-fluid spaceline4"},content=function()
         end }
        end }
       end }
      end } 
    
      ui.container{ attr = { class = "row-fluid depression_box spaceline2 wood" }, content = function()
       ui.container{ attr = { class = "span3 offset1 spaceline4" }, content = function()
        ui.container{ attr = { class = "progress progress-striped active" }, content=function()
         ui.container{ attr = {class = "progress_bar_txt"}, content=function()
          ui.container{ attr = {class = "text-center"}, content="70%" }
         end }      
        end }
       end }      
      ui.container{attr={class="span6 offset1 text-justify spaceline2"},content=function()
       ui.tag{tag="h3",content=  "99999 Persone hanno fatto richiesta di una commissione tecnica"}  
       ui.tag{tag="h3",content=  "99999 Richieste per raggiungere il quorum"} 
       ui.tag{tag="p",content=  "Anche se si raggiunge il quorum, la commissione verrà istituita solo se almeno una proposta supererà la prima votazione"}   
         end }
ui.container{attr={class="row-fluid spaceline4"},content=function()
         
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
