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
local btnBackView = "wizard_new_initiative"

if not page  or page <= 1 then
    page=1
    btnBackModule ="wizard"
    btnBackView = "show_ext"
end

local previus_page=page-1
local next_page=page+1


ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
    ui.heading{level=3,content= _"FASE "..page }
    ui.heading{level=4,content= _"How much time does your proposal need to be examined?" }
  end }
end }
ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()

                    ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page,style="height:80%"},
                        module = 'wizard',
                        view = 'wizard_new_initiative',
                        params={

                                area_id=area_id,
                                unit_id=unit_id,
                                page=page+1
                        },
                        routing = {
                            ok = {
                              mode   = 'redirect',
                              module = 'wizard',
                              view = 'wizard_new_initiative',
                              params = {

                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page+1
                                          },
                            },
                            error = {
                              mode   = '',
                              module = 'wizard',
                              view = 'wizard_new_initiative',
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
                                name = 'policyChooser',
                                foreign_records = dataSource,
                                foreign_id = "id",
                                foreign_name = "name",
                                value =  ""
                              }
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


local view_params={}
view_params[#view_params+1]=  {}

ui.container{attr={class="row-fluid"},content=function()
  ui.container{attr={class="span12 text-center"},content=function()
    execute.view{
      module="wizard",
      view="_pulsanti_bs",
      params={
        btnBackModule = "wizard",
        btnBackView = "wizard_new_initiative",
        page=page
      }
    }
  end }
end }

--[[
 ui.container
            {
                    attr={id="wizard_page_"..page, class="basicWizardPage"},
                    content=function()
                    ui.container
                        {
                                attr={id="wizardTitoloArea",class="titoloWizardHead", style="text-align: center; width: 100%;"},
                                content=function()
                                  ui.tag{
                                        tag="p",
                                        attr={},
                                        content=  "FASE "..page
                                      }
                                      
                                  ui.tag{
                                        tag="p",
                                        attr={style="font-size:28px;"},
                                        content=  _"How much time does your proposal need to be examined?"
                                      }
                                end
                         }
                         
                     
                   
                    ui.form
                    {
                        method = "post",
                        attr={id="wizardForm"..page,style="height:80%"},
                        module = 'wizard',
                        view = 'wizard_new_initiative',
                        params={
                                
                                area_id=area_id,
                                unit_id=unit_id,
                                page=page+1
                        },
                        routing = {
                            ok = {
                              mode   = 'redirect',
                              module = 'wizard',
                              view = 'wizard_new_initiative',
                              params = {
                                           
                                           area_id=area_id,
                                           unit_id=unit_id,
                                           page=page+1
                                          },
                            },
                            error = {
                              mode   = '',
                              module = 'wizard',
                              view = 'wizard_new_initiative',
                            }
                          }, 
                       content=function()
                    
                       ui.container
                        {
                          attr={class="formSelect"},
                          content=function() 
                          
                           ui.field.select{
                                attr = { id = "policyChooser", style="width:70%;height:30px;left: 20ex;position:relative;"},
                                label =  "",
                                name = 'policyChooser',
                                foreign_records = dataSource,
                                foreign_id = "id",
                                foreign_name = "name",
                                value =  ""
                              }
                          
                          
                          
                             
                          ui.tag{
                                tag = "div",
                                attr={style="position:relative;"},
                                content = function()
                                  ui.tag{
                                    tag = "label",
                                    attr = { class = "ui_field_label",style="margin-left:28em;" },
                                    content = function() slot.put("&nbsp;") end,
                                  }
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
                         
                         end
                         }--fine div formSelect
                     
                        
                        
                     end
                     
                     }--fine form
                     
             
             local view_params={}
             view_params[#view_params+1]=  {}
             
             
             --pulsanti
            execute.view{
                            module="wizard",
                            view="_pulsanti",
                            params={
                                    
                                     btnBackModule = "wizard",
                                     btnBackView = "wizard_new_initiative",
                                     page=page
                                    }
                         }
                          
             
         
     end
 }
]]--