$(function() {
    function switchVote(_this, maxRankId) {
        var count = $('.vote', _this);
        var newCount = count.attr('data-original-title') * 1 + 1;
        count.attr('data-original-title', newCount);
        if (_this.attr('class') == 'downvote') {
            var opposite = 'upvote';
            $('.vote', '#' + maxRankId + ' .' + opposite).removeClass('upvoted')
            $('.vote', _this).addClass('downvoted')
        } else {
            var opposite = 'downvote';
            $('.vote', '#' + maxRankId + ' .' + opposite).removeClass('downvoted')
            $('.vote', _this).addClass('upvoted')
        }
        var oppositeCount = $('.vote', '#' + maxRankId + ' .' + opposite);
        var newOppositeCount = oppositeCount.attr('data-original-title') * 1 - 1;
        oppositeCount.attr('data-original-title', newOppositeCount);
    }

    function incrementVote(_this) {
       changeVote(_this, 1)
       if (_this.attr('class') == 'downvote') {
          $('.vote', _this).addClass('downvoted')
       } else {
          $('.vote', _this).addClass('upvoted')
       }
    }

    function decrementVote(_this) {
        changeVote(_this, -1)
        if (_this.attr('class') == 'downvote') {
            $('.vote', _this).removeClass('downvoted')
        } else {
            $('.vote', _this).removeClass('upvoted')
        }
    }
    
    function errorVote(_this) {
      _this.addClass('error')
    }
    
    function changeVote(_this, vote) {
       var count = $('.vote', _this);
       var newCount = count.attr('data-original-title') * 1 + vote;
       count.attr('data-original-title', newCount);
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

