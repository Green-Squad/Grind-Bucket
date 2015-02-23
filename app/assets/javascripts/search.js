$(function() {
  
  $.ui.autocomplete.prototype._renderItem = function(ul, item) {
    var re = new RegExp(this.term, "ig");
    var t = item.label.replace(re, "<strong>$&</strong>");
    return $("<li></li>").data("item.autocomplete", item).append("<a>" + t + "</a>").appendTo(ul);
  };
  
  $("#search-box").autocomplete({
    source : function(request, response) {
      $.ajax({
        url : '/search-items/?query=' + $('#search-box').val(),
        dataType : "json",
        data : {
          q : request.term
        },
        success : function(data) {
          response(data);
        }
      });
    },
    select : function(event, ui) {
      if (ui.item) {
        $('#search-box').val(ui.item.value);
      }
      $('#search-form').submit();
    }
  });

  // FUCK YOU CHROME AND YOUR AUTOCOMPLETE BULLSHIT
  $('input').on('focus', function() {
    $(this).attr('autocomplete', 'off');
  });
  
  // Forms use Turbolinks
  $("#search-form").submit(function() {
    event.preventDefault()
    Turbolinks.visit(this.action+(this.action.indexOf('?') == -1 ? '?' : '&')+$(this).serialize());
    return false;
  });
});
