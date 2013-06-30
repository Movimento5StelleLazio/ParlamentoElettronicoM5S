slot.set_layout("m5s_bs")

local area_id=param.get("area_id" )
local unit_id=param.get("unit_id" )

local area_policies=AllowedPolicy:get_policy_by_area_id(area_id)

local dataSource
dataSource = { 
               { id = 0, name = _"Please choose a policy" }
        }

if #area_policies>0 then
                       
         for i, allowed_policy in ipairs(area_policies) do
            dataSource[#dataSource+1] = {id=allowed_policy.id, name=allowed_policy.name  }
         end   
                          
 else
                         
end


local page=param.get("page",atom.integer)


local btnBackModule = "wizard"
local btnBackView = "wizard_new_initiative_bs"

if not page  or page <= 1 then
    page=1
    btnBackModule ="wizard"
    btnBackView = "show_ext_bs"
end

local previus_page=page-1
local next_page=page+1


ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
    ui.heading{level=3,content= _"FASE "..page.." di 11" }
    ui.heading{level=4,content= _"How much time does your proposal need to be examined?" }
  end }
end }
ui.container{attr={class="row-fluid",style="padding-top: 2em;"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()

                    ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page,style="height:80%"},
                        module = 'wizard',
                        view = 'wizard_new_initiative_bs',
                        params={

                                area_id=area_id,
                                unit_id=unit_id,
                                page=page
                        },
                        routing = {
                            ok = {
                              mode   = 'redirect',
                              module = 'wizard',
                              view = 'wizard_new_initiative_bs',
                              params = {

                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page
                                          },
                            },
                            error = {
                              mode   = '',
                              module = 'wizard',
                              view = 'wizard_new_initiative_bs',
                            }
                          },
                       content=function()
                         ui.container
                        {
                          attr={class="formSelect"},
                          content=function()

                           ui.field.select{
                                attr = { id = "policyChooser", style="width:70%;height:38px;position:relative;"},
                                label =  "",
                                name = "policyChooser",
                                foreign_records = dataSource,
                                foreign_id = "id",
                                foreign_name = "name",
                                value =  ""
                              }
                              
                             --parametri in uscita 
                            ui.hidden_field{name="indietro" ,value=false}
                              
                           ui.tag{
                                tag = "div",
                                attr={style="position:relative;"},
                                content = function()
                                 
                                  ui.tag{
                                    content = function()
                                      ui.link{
                                        text = _"Information about the available policies",
                                        module = "policy",
                                        view = "list"
                                      }
                                      slot.put(" ")
                                      ui.link{
                                        attr = { target = "_blank" },
                                        text = _"(new window)",
                                        module = "policy",
                                        view = "list"
                                      }
                                    end
                                  }--fine tag
                                end
                              } --fine tag

                         end }
                         end }




  end }
end }


 

ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
    execute.view{
      module="wizard",
      view="_pulsanti_bs",
      params={
        btnBackModule = "wizard",
        btnBackView = "wizard_new_initiative_bs",
        page=page
       }
    }
  end }
end }
