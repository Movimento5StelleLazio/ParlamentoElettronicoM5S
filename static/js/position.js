function getLocation(id, message) {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function (position) {
            var geocoder = new google.maps.Geocoder();
            var latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
            geocoder.geocode({'latLng': latlng}, function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    if (results[1]) {
                        document.getElementById(id).innerHTML = message + " <strong>" + results[1].address_components[1].long_name + "</strong> (<strong>" + results[1].address_components[3].short_name + "</strong>).";
                        container = null;
                    }
                    else
                        alert("other error");
                } else {
                    alert("Geocoder failed due to: " + status);
                }
            });
        });
    } else {
        alert("Geolocation is not supported by this browser.");
    }
}

function getLastLocation(latitude, longitude, id, message) {
    var geocoder = new google.maps.Geocoder();
    var latlng = new google.maps.LatLng(latitude, longitude);
    geocoder.geocode({'latLng': latlng}, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            if (results[1]) {
                document.getElementById(id).innerHTML = message + " <strong>" + results[1].address_components[1].long_name + "</strong> (<strong>" + results[1].address_components[3].short_name + "</strong>).";
                container = null;
            }
            else
                alert("other error");
        } else {
            alert("Geocoder failed due to: " + status);
        }
    });
}
