/**
 * CSS3 link bugfix: gestiamo da codice javascript la propietà href, legandola al mousedown anziche' 
 * al mouseup come di default.
 * Da questa gestione escludiamo quei tag <a> con attributi datatoggle=='dropdown', 
 * utilizzata dai menu dropdown presenti nell'applicazione.
 *  
 */
$('.fixclick').mousedown( function(event)
{
   if ( event.which != 1 ) { return; }
   
   if ( $(this).attr( 'datatoggle') && $(this).attr( 'datatoggle')=="dropdown" )
   {
	   //console.log("menu dropdown clicked");
	   return;
   }
   
   window.location.href = $(this).attr('href');
});
