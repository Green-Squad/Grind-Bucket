$(function () {
    $('#theme-select2').on('change', function () {
        var themeText = $('#theme-select2 option:selected').text();
        $('body').removeClass();
        $('body').addClass(themeText);
    });

    function changeImage(input) {
        $('.game-header').removeClass('default-image').addClass('game-image');
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $('.game-header').css('background-image', 'url(' + e.target.result + ')');
            }
            reader.readAsDataURL(input.files[0]);
        }
    }

    $('#game_image').change(function () {
        changeImage(this);
    });

    $('.admin-toggle').click(function() {
        $('.admin-menu').toggleClass('admin-menu-closed');
        $('.admin-toggle').toggleClass('admin-toggle-closed');
    });
});