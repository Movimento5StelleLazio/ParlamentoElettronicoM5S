function set_login_position(service_url) {
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
      function error(msg) { 
      },
      {timeout:5000}
    );
  } 
}


function codeLatLng(lat,lng,id,str) {
  $.ajax({
  type: "GET",
  url: "http://maps.googleapis.com/maps/api/geocode/json",
  data: { latlng: lat+","+lng, sensor: "false" }
  }).done(function( response ) { 
    var ele = document.getElementById(id)
    if (str && ele && response && response.results[3] && response.results[3].address_components[1]) {
      ele.innerHTML=str+response.results[3].address_components[1].long_name+","+response.results[3].address_components[2].long_name;
    }
  });
}
