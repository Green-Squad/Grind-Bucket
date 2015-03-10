class HomeController < ApplicationController
  skip_before_action :validate_user, only: :loading

  def index
    @recently_added = Game.where(status: 'Approved').order(created_at: :desc).take(5)
    @recent_activity = Game.joins(:max_rank, :vote).group('games.id').where("games.status = 'Approved'")
                           .order('MAX(votes.created_at) DESC').select('games.*, MAX(votes.created_at)').take(5)
  end

  def loading

  end
end