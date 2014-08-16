if (document.getElementById("template_name_field_save")) {
    document.getElementById("template_name_field_save").value = "";
}


if (document.getElementById("template_name_paste")) {
    document.getElementById("template_name_paste").value = "";
}


function nameSaveTemplateChange(event) {


    for (var t = 0; t < _arrayNameTemplate.length; t++) {


        if (event.target.value == _arrayNameTemplate[t].id) {
            document.getElementById("template_name_field_save").value = _arrayNameTemplate[t].name;
            document.getElementById("template_description_field_save").value = _arrayNameTemplate[t].description;
        }

        if (event.target.value == 0) {

            document.getElementById("template_name_field_save").value = "";
            document.getElementById("template_description_field_save").value = "";
        }
    }
}


function namePasteTemplateChange(event) {

    document.getElementById("template_areas_paste").value = "";

    for (var t = 0; t < _arrayNameTemplate.length; t++) {


        if (event.target.value == _arrayNameTemplate[t].id) {
            document.getElementById("template_name_paste").value = _arrayNameTemplate[t].name;
            document.getElementById("template_description_paste").value = _arrayNameTemplate[t].description;


            for (var i = 0; i < _arrayAreas.length; i++) {
                if (_arrayNameTemplate[t].id == _arrayAreas[i].template_id) {

                    document.getElementById("template_areas_paste").value += _arrayAreas[i].name + "\n";
                }
            }


        }

        if (event.target.value == 0) {
            document.getElementById("template_name_paste").value = "";
            document.getElementById("template_description_paste").value = "";
            document.getElementById("template_areas_paste").value = "";
        }
    }
}






 