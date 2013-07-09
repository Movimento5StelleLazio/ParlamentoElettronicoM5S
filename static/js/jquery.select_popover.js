$(window).load(function () {
  
  $('#select_btn').popover({
      trigger: 'manual',
      animation: 'true',
      placement: 'top',
      content: 'Premi CTRL + C per copiare il testo selezionato'
  }).click(function(e) {
      e.stopPropagation();
      $(this).popover('show');
      $("#issue_url_box").select();
  });


  $("#issue_url_box").bind("copy", function() {$("#select_btn").popover("hide"); });

  $('html').click(function() {
      $('#select_btn').popover('hide');
  });

});
