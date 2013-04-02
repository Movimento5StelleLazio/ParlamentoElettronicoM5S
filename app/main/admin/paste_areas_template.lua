

local _template = Template:get_all_templates()

 
local _listTemplate={
{ id = 0, name = _"< select template >" }
}
 

for i, template in ipairs(_template) do
  _listTemplate[#_listTemplate+1] = { id = template.id, name = template.name , description=template.description}
end


local _areasTemplate={}
local _listAreas=db:query( "SELECT * FROM template_area" )

for i, listAreas in ipairs(_listAreas) do
  _areasTemplate[#_areasTemplate+1] = { id = listAreas.id, template_id=listAreas.template_id , name = listAreas.name , description=listAreas.description}
end

   
ui.title(_("Unit '#{name}'", { name = param.get("unit_name") }))

 



ui.form{
  attr = { class = "vertical" },
  module = 'admin',
  action = 'paste_template',
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
        attr = { id = "template_field_paste", onchange="namePasteTemplateChange(event)" },
        label =  _'Template Name to paste',
        name = 'templateTypePaste',
        foreign_records = _listTemplate,
        foreign_id = "id",
        foreign_name = "name",
        value =  ""
      }
  
    ui.field.text{
      attr = { id = "template_name_paste", readonly="true" },
      label     = _'Template Name',
      html_name = 'templateNamePaste',
      value     = ''
    }
    
    ui.field.text{
      attr= { id = "template_description_paste", readonly="true"},
      label     = _'Template Description',
      html_name = 'templateDescriptionPaste',
      multiline = true, 
      value     =""
    }
    
    
     ui.field.text{
      attr= { id = "template_areas_paste", style="height:300px",readonly="true" },
      label     = _'Template Areas',
      html_name = 'templateAreasPaste',
      multiline = true, 
      value     =""
    } 
   
    
    slot.put('<br>')    
    slot.put('<br>')  
    
    ui.field.boolean{ label_attr ={style='width:30%'},    label = _"Areas Not active before paste",     name = "deactive" }
      
    slot.put('<br>')    
    slot.put('<br>')    
        
    slot.put('<input type="hidden"  name="unit_id" value="'..param.get("unit_id")..'">')        
    slot.put('<input type="hidden"  name="areas" value="'..param.get("areas")..'">')    
    
    ui.submit{ text = _"Paste Template" }
     
    slot.put('<br>')    
    slot.put('<br>')    
     
  end
}

   

    
-- javascript context

slot.put("<script>")

slot.put("var _arrayNameTemplate=new Array();")
for i, template in ipairs(_listTemplate) do
  slot.put("_arrayNameTemplate.push("..encode.json(_listTemplate[i])..");")
end

slot.put("var _arrayAreas=new Array();")

if _areasTemplate then
    for t, area in ipairs(_areasTemplate) do
      slot.put("_arrayAreas['"..(t-1).."']="..encode.json(_areasTemplate[t])..";")
    end
end


slot.put("</script>")

ui.script{ static = "js/custom.js" }







