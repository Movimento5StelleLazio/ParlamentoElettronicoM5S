(function ($) {
    $.fn.quorum_bar = function () {
        return this.each(function () {
            var $this = $(this);
            var resizer = function () {
                $this.height($('.initiative_list_box').height() * 0.90);
            };
            resizer();
            $(window).on('resize.quorum_bar orientationchange.quorum_bar', resizer);
        });
    };
})(jQuery);
