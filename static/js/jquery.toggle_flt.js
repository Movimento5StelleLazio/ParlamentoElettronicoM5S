(function($) {
    $.fn.goTo = function() {
        $('html, body').animate({
            scrollTop: $(this).offset().top + 'px'
        }, 'fast');
        return this; // for chaining...
    }
})(jQuery);

(function($) {
    if (!$.exist) {
        $.extend({
            exist: function(elm) {
                if (typeof elm == null) return false;
                if (typeof elm != "object") elm = $(elm);
                return elm.length ? true : false;
            }
        });
        $.fn.extend({
            exist: function() {
                return $.exist($(this));
            }
        });
    }
})(jQuery);

var toggle_flt = function(){
  if ( event.which != 1 ) { return; }
  if ($('#btn_apply_row').exist()) { document.getElementById('btn_apply_row').style.display = 'none'; }
  if ($('#btn_delete_row').exist()) { document.getElementById('btn_delete_row').style.display = 'block'; }
  if ($('#flt_box').exist()) { $('#flt_box').toggle('slide', {direction: 'up'}); }
};

