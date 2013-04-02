local _template = Template:get_all_templates()

local _listTemplate={
{ id = 0, name = _"< new >" }
}

for i, template in ipairs(_template) do
  _listTemplate[#_listTemplate+1] = { id = template.id, name = template.name , description=template.description}
end


ui.title(_("Unit '#{name}'", { name = param.get("unit_name") }))

ui.form{
  attr = { class = "vertical" },
  module = 'admin',
  action = 'save_template',
  routing = {
    ok = {
      mode   = 'redirect',
      module = 'admin',
      view   = 'area_list',
      id = param.get("unit_id"),
      params = {  unit_name = param.get("name"), unit_id = param.get("unit_id") }
    },
    error = {
      mode   = '',
      module = 'admin',
      view   = 'area_list',
    }
  }, 
  
  content = function()
  
 
   ui.field.select{
        attr = { id = "template_type_field_save", onchange="nameSaveTemplateChange(event)" },
        label =  _'Template Type',
        name = 'templateTypeSave',
        foreign_records = _listTemplate,
        foreign_id = "id",
        foreign_name = "name",
        value =  ""
      }
  
    ui.field.text{
      attr = { id = "template_name_field_save" },
      label     = _'Template Name',
      html_name = 'templateNameSave',
      value     = ''
    }
    
    ui.field.text{
      attr= { id = "template_description_field_save",style='height:300px;' },
      label     = _'Template Description',
      html_name = 'templateDescriptionSave',
      multiline = true, 
      value     =""
    }
    
     slot.put('<input type="hidden"  name="unit_id" value="'..param.get("unit_id")..'">')        
     slot.put('<input type="hidden"  name="areas" value="'..param.get("areas")..'">')    
    
     ui.submit{ text = _"Save" }
      
  end
}

-- javascript context

slot.put("<script>")

slot.put("var _arrayNameTemplate=new Array();")
for i, template in ipairs(_listTemplate) do
  slot.put("_arrayNameTemplate.push("..encode.json(_listTemplate[i])..");")
end

slot.put("</script>")

ui.script{ static = "js/custom.js" }


