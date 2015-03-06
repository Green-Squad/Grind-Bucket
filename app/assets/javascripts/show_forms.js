$(function() {
  $('#add-game-button').click(function() {
    $('#add-game-button').addClass('hidden');
    $('#cancel-add-game-button').removeClass('hidden');
    $('#add-game-box').removeClass('hidden');
    grecaptcha.render('recaptcha-game', {
      'sitekey' : '6LejWAETAAAAAJiT5Y2l1h9NLIRmwLjMd2ThoJzt',
      'theme' : 'light'
    });
  });

  $('#cancel-add-game-button').click(function() {
    $('#cancel-add-game-button').addClass('hidden');
    $('#add-game-button').removeClass('hidden');
    $('#add-game-box').addClass('hidden');
  });

  $('#add-max-rank-button').click(function() {
    $('#add-max-rank-button').addClass('hidden');
    $('#cancel-add-max-rank-button').removeClass('hidden');
    $('#add-max-rank-box').removeClass('hidden');
    grecaptcha.render('recaptcha-max-rank', {
      'sitekey' : '6LejWAETAAAAAJiT5Y2l1h9NLIRmwLjMd2ThoJzt',
      'theme' : 'light'
    });
  });

  $('#cancel-add-max-rank-button').click(function() {
    $('#cancel-add-max-rank-button').addClass('hidden');
    $('#add-max-rank-button').removeClass('hidden');
    $('#add-max-rank-box').addClass('hidden');
  });
});
