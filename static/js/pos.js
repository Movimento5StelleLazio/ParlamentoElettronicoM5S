function initialize() {
  geocoder = new google.maps.Geocoder();
        var mapOptions = {
          center: new google.maps.LatLng(-34.397, 150.644),
          zoom: 8,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var map = new google.maps.Map(document.getElementById("map"), mapOptions);
      }

google.maps.event.addDomListener(window, 'load', initialize);

function success(position) {
  var s = document.querySelector('#status');


  $.ajax({
  type: "POST",
  url: "/lf/member/test.html",
  data: { lat: position.coords.latitude, lon: position.coords.longitude }
  }).done(function( msg ) { });

    s.innerHTML='Latitude: ' + position.coords.latitude + ' Longitude: ' + position.coords.longitude;
}

function error(msg) {
  var s = document.querySelector('#status');
  s.innerHTML = typeof msg == 'string' ? msg : "failed";
  s.className = 'fail';
}

if (navigator.geolocation) {
  navigator.geolocation.getCurrentPosition(success, error);
} else {
  window.alert('not supported');
}
