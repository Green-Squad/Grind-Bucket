$(function() {
    function switchVote(_this, maxRankId) {
        var count = $('.count', _this);
        var newCount = count.text() * 1 + 1;
        count.text(newCount);
        if (_this.attr('class') == 'downvote') {
            var opposite = 'upvote';
        } else {
            var opposite = 'downvote';
        }
        var oppositeCount = $('.count', '#' + maxRankId + ' .' + opposite);
        var newOppositeCount = oppositeCount.text() * 1 - 1;
        oppositeCount.text(newOppositeCount);
    }

    function incrementVote(_this) {
       changeVote(_this, 1)
    }

    function decrementVote(_this) {
        changeVote(_this, -1)
    }
    
    function errorVote(_this) {
      _this.addClass('error')
    }
    
    function changeVote(_this, vote) {
       var count = $('.count', _this);
       var newCount = count.text() * 1 + vote;
       count.text(newCount);
    }
    
    function vote(_this, vote) {
      var maxRankId = _this.data('max-rank-id')
        $.ajax({
            type: 'POST',
            url: '/votes/new',
            data: {
                vote: {
                    max_rank_id: maxRankId,
                    vote: vote
                }
            },
            complete: function(e) {
              switch (e.status) {
                case 200:
                    switchVote(_this, maxRankId);
                    break;
                case 201:
                    incrementVote(_this);
                    break;
                case 204: 
                    decrementVote(_this);
                    break;
                default:
                    errorVote(_this);
                    break
              }
            }
        });
    }

    $('.upvote').click(function() {
      vote($(this), 1)
    });
    $('.downvote').click(function() {
      vote($(this), -1)
    });
});