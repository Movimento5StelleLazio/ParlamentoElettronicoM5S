function checkOtpToken() {
	var $ = jQuery.noConflict();
	$(document).ready( function() {
		var user = $("#username_field").val();
		var otp = String($("#otp_field").val());
		if(otp.length != 6 || isNaN(Number(otp))) {
			alert("Attento/a: l'OTP è formato da 6 numeri. Ricontrolla di averlo inserito correttamente.");
			return;
		}
		$.ajax({
			type: "GET",
			url: "https://autenticazione.parelon.com/validate/check",
			data: {"user": user, "pass": otp},
			dataType: "json",
			xhrFields: {
    				withCredentials: 'true'
   			},
			success: function (data, status, jqXHR) {
				if( data.result.status && data.result.value ) {
					$("#login_div").submit();
				} else {
					$("#layout_error").text = "L'OTP inserito non è valido: riprova subito o aspetta che venga generato il prossimo.";
					alert("L'OTP inserito non è valido: riprova subito o aspetta che venga generato il prossimo.");
				}
			},
			error: function (jqXHR, textStatus, errorThrown) {
				$("#layout_error").text = "Generic error: " + errorThrown + ". Please try again.";
				alert("Generic error: " + errorThrown + ". Please try again.");
			}
		});	
	});
}
