(function ($) {

    $.fn.scalebar = function () {

        return this.each(function () {

            var $this = $(this);
            var phases_bar_width = $this.width()
            var phases_bar_height = $this.height()


            var resizer = function () {
                var parent_width = $this.closest('.col-md-9').width()

                // Calculate the resize ratio based on parent div
                var ratio = parent_width / phases_bar_width

                // Calculate margin offset
                var left = phases_bar_width / 2 * (ratio - 1);
                var top = -( ( phases_bar_height / 2 - 26  ) * (ratio - 1));


                ratioX = ratio;
                ratioY = ratio;

                $this.css('transform', 'scale(' + ratioX + ', ' + ratioY + ')');
                $this.css('-webkit-transform', 'scale(' + ratioX + ', ' + ratioY + ')');
                $this.css('-ms-transform', 'scale(' + ratioX + ', ' + ratioY + ')');
                $this.css('left', left);
                $this.css('top', top);
                $this.closest('.row-fluid').margin({top: phases_bar_height * (ratio - 1)  })

            };

            resizer();

            $(window).on('resize.scalebar orientationchange.scalebar', resizer);

        });

    };

})(jQuery);

