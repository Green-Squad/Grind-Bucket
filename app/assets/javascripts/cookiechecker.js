$(function() {
  cookiesEnabled = navigator.cookieEnabled;
  if (!cookiesEnabled) {
    $.each($('a'), function() {
      href = $(this).attr('href');
      if (href.indexOf('?') >= 0) {
        href += '&';
      } else {
        href += '?';
      }
      href += 'cookies=false'
      $(this).attr('href', href);
    });
  }
});
