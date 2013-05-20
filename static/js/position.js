function set_login_position(service_url) {
  $(window).load(function(){
//    alert("trace: set_login_position(): url="+service_url);
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        function success(position) {
          $.ajax({
          type: "POST",
          url: service_url,
          data: { 
            lat: position.coords.latitude, 
            lng: position.coords.longitude 
          }
         });
        },
        function error(msg) {},
        {timeout:5000}
      );
    } 
  });
}


function codelatlng(lat,lng,id,str) {
  $(window).load(function(){
//    alert("trace: codeLatLng(): lat:"+lat+" lng:"+lng+" Element id:"+id+" String: \""+str+"\"");
    $.ajax({
    type: "GET",
    url: "http://maps.googleapis.com/maps/api/geocode/json",
    data: { latlng: lat+","+lng, sensor: "false" }
    }).done(function( response ) { 
      var ele = document.getElementById(id)
      if (str && ele && response && response.results && response.results[3] && response.results[3].address_components[1]) {
        ele.innerHTML=str+"<strong>"+response.results[3].address_components[1].long_name+", "+response.results[3].address_components[2].long_name+"."+"</strong>";
      } else {
 //       alert("trace: codeLatLng(): Error retrieving response");
        ele.innerHTML="";
      }
    });
  });
}
