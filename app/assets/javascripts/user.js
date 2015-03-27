$(function () {
    var fingerprint = new Fingerprint().get();
    if (!$('.user-name').data('user')) {
        $('.user-name').text('Loading...');
        $.post('/user.json?fingerprint=' + fingerprint)
            .done(function (data) {
                $('#user-color-icon').css('border-color', data.color).css('background', data.color);
                $('.user-name').text(data.username);
            });
    } else if($.cookie('new_session') == 'true'){
        $.post('/identifier.json?fingerprint=' + fingerprint);
    }
});