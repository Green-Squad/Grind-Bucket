class HomeController < ApplicationController
  skip_before_action :validate_user, only: :loading

  def index
    @recently_added = Game.where(status: 'Approved').order(created_at: :desc).take(5)
    @recent_activity = Game.joins('INNER JOIN max_ranks ON max_ranks.game_id = games.id INNER JOIN votes ON votes.max_rank_id = max_ranks.id')
                           .where("games.status = 'Approved'").order('votes.created_at DESC').take(5)
  end

  def loading

  end
end