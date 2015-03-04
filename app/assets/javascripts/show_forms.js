$(function() {
  $('#add-game-button').click(function() {
    $('#add-game-button').hide();
    $('#cancel-add-game-button').show();
    $('#add-game-box').show();
    grecaptcha.render('recaptcha-game', {
      'sitekey' : '6LejWAETAAAAAJiT5Y2l1h9NLIRmwLjMd2ThoJzt',
      'theme' : 'light'
    });
  });

  $('#cancel-add-game-button').click(function() {
    $('#cancel-add-game-button').hide();
    $('#add-game-button').show();
    $('#add-game-box').hide();
  });
});
