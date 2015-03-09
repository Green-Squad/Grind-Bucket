$(function () {
    $('#theme-select2').on('change', function () {
        var themeText = $('#theme-select2 option:selected').text();
        $('body').removeClass();
        $('body').addClass(themeText);
    });
});