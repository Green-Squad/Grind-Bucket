$(function() {

  if (window.location.pathname == '/loading') {

    if (navigator.cookieEnabled) {
      var fingerprint = new Fingerprint().get();

      $.ajax({
        type : 'POST',
        url : '/fingerprint/new',
        data : {
          fingerprint : fingerprint
        }
      }).done(function(msg) {
        redirect();
      });
    } else {
      redirect(false);
    }
  }

  function redirect(cookies) {
    cookies = cookies || true;
    var intended_url = $('#redirect_url').attr('href');
    if (window.location.pathname == '/loading') {
      if (!cookies) {
        intended_url += '?cookies=false';
      }
      Turbolinks.visit(intended_url);
    }
  }

});
