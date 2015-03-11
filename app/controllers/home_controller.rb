class HomeController < ApplicationController
  skip_before_action :validate_user, only: :loading

  def index
    @recently_added = Rails.cache.fetch("#{cache_key_recently_added_games}", expires_in: 1.day) do
      logger.debug('recently added games cache')
      Game.where(status: 'Approved').order(created_at: :desc).take(5)
    end

    @recent_activity = Rails.cache.fetch("#{cache_key_recent_activity}", expires_in: 1.day) do
      logger.debug('recent activity cache')
      Game.joins(:max_rank, :vote).group('games.id').where("games.status = 'Approved'")
          .order('MAX(votes.created_at) DESC').select('games.*, MAX(votes.created_at)').take(5)
    end
  end

  def loading

  end

  private

  def cache_key_recently_added_games
    max_updated_at = Game.where(status: 'Approved').maximum(:updated_at).try(:utc).try(:to_s, :number)
    "home/recently-added-#{max_updated_at}"
  end

  def cache_key_recent_activity
    max_updated_at = MaxRank.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "home/recent-activity-#{max_updated_at}"
  end
end