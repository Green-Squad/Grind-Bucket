class HomeController < ApplicationController
  skip_before_action :validate_user, only: :loading

  def index
    @recently_added = Rails.cache.fetch('home/recently-added', expires_in: 1.day) do
      Game.where(status: 'Approved').order(created_at: :desc).take(5)
    end

    @recent_activity = Rails.cache.fetch('home/recent-activity', expires_in: 1.day) do
      Game.joins(:max_rank, :vote).group('games.id').where("games.status = 'Approved'")
          .order('MAX(votes.created_at) DESC').select('games.*, MAX(votes.created_at)').take(5)
    end
  end

  def loading

  end
end