function equalHeight(group) {
   tallest = 0;
   group.each(function() {
      $(this).height('auto');
      thisHeight = $(this).height();
      if(thisHeight > tallest) {
         tallest = thisHeight;
      }
   });
   group.height(tallest);
}
