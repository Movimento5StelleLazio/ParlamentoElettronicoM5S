$(document).ready(function(){
  var highestBox = 0;
  $('.sameheight', this).each(function(){
    if($(this).height() > highestBox) 
      highestBox = $(this).height(); 
    });  
  $('.sameheight',this).height(highestBox);
});
