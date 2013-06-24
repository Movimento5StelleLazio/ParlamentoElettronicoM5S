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
  if ($('#btn_apply_row').exist()) { document.getElementById('btn_apply_row').style.display = 'none'; }
  if ($('#btn_delete_row').exist()) { document.getElementById('btn_delete_row').style.display = 'block'; }
  if ($('#state_flt').exist()) { document.getElementById('state_flt').style.display = 'block'; }
  if ($('#interest_flt').exist()) { document.getElementById('interest_flt').style.display = 'block'; }
  if ($('#scope_flt').exist()) { document.getElementById('scope_flt').style.display = 'block'; }
  $('#btn_delete_row').goTo();
};

