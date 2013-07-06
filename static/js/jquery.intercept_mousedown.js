$('.fixclick').mousedown( function(e){
   if ( event.which != 1 ) { return; }
   window.location.href = $(this).attr('href');
});
