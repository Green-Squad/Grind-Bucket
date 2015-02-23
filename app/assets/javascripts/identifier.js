$(function() {
  var fingerprint = new Fingerprint().get();
  document.cookie="fingerprint=" + fingerprint;
});
