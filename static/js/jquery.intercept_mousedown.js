$('.btn').mousedown( function(e){
   e.preventDefault();
   window.location.href = $(this).attr('href');
});
