$(function () {
    if (!$('.user-name').data('user')) {
        var fingerprint = new Fingerprint().get();
        $('.user-name').text('Loading...');
        $.get('/user.json?fingerprint=' + fingerprint, function () {
        }).done(function (data) {
            $('#user-color-icon').css('border-color', data.color).css('background', data.color);
            $('.user-name').text(data.username);
        });
    }
});