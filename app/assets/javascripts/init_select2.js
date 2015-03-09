$(function () {
    $('#rank-type-select2').select2({
        placeholder: {
            id: "-1",
            text: "Rank Type"
        }
    });

    $('#game-select2').select2({
        placeholder: {
            id: "-1",
            text: "Game"
        }
    });

    $('#theme-select2').select2({
        templateResult: formatTheme
    });

    function formatTheme(theme) {
        if (!theme.id) { return theme.text; }
        var option = $('#theme-select2 option[value="' + theme.id + '"]')
        var formattedTheme =
            '<span>' +
                '<span style="background-color: ' + option.data("primary-color") + '" class="theme-preview"></span>' +
                '<span style="background-color: ' + option.data("secondary-color") + '" class="theme-preview"></span>' +
                theme.text +
            '</span>';
        return formattedTheme;
    };
})