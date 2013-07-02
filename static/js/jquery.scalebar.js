(function( $ ){

  $.fn.scalebar = function( ) {

    return this.each(function(){

      var $this = $(this);
      var phases_bar_margin_bottom=$this.margin().bottom;
      var phases_bar_margin_left=$this.margin().left;


      var resizer = function () {
        var parent_width = $this.closest('.span12').width()
        var phases_bar_width = $this.width()
        var phases_bar_height = $this.height()

        // Calculate the resize ratio based on parent div
        var ratio=parent_width/phases_bar_width
      
        // Calculate margin offset
        var mb = phases_bar_margin_bottom + phases_bar_height / 2 * ratio;
        
        
        ratioX = ratio;
        ratioY = ratio;

        $this.css('transform', 'scale('+ratioX +', '+ratioY+')');  
        $this.css('-webkit-transform', 'scale('+ratioX +', '+ratioY+')');  
        $this.css('-ms-transform', 'scale('+ratioX +', '+ratioY+')');  
//        $this.margin({bottom: mb});
      };

      resizer();

      $(window).on('resize.scalebar orientationchange.scalebar', resizer);

    });

  };

})( jQuery );

