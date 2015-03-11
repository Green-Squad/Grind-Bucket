class GamesController < ApplicationController
  before_action :authenticate_admin_user!, only: [:approve, :reject, :update]
  before_action :set_game, only: [:show, :update]
  before_action :validate_recaptcha, only: :create

  def index
    @games = Rails.cache.fetch("#{cache_key_all_games(params[:page])}", expires_in: 1.day) do
      Kaminari.paginate_array(Game.where(status: 'Approved').order(:name).to_a).page(params[:page]).per(25)
    end
  end

  def show
    @unverified_max_ranks_array = Rails.cache.fetch("#{cache_key_unverified_max_ranks}", expires_in: 1.day) do
      unverified_max_ranks = MaxRank.where(game_id: @game.id, verified: false)
      unverified_max_ranks_array = unverified_max_ranks.map do |max_rank|
        rank_info = {
            max_rank: max_rank,
            upvotes: max_rank.upvotes,
            downvotes: max_rank.downvotes
        }
      end
      MaxRank.sort(unverified_max_ranks_array)
    end

    @verified_max_ranks_array = Rails.cache.fetch("#{cache_key_verified_max_ranks}", expires_in: 1.day) do
      verified_max_ranks = MaxRank.where(game_id: @game.id, verified: true)
      verified_max_ranks_array = verified_max_ranks.map do |max_rank|
        rank_info = {
            max_rank: max_rank,
            upvotes: max_rank.upvotes,
            downvotes: max_rank.downvotes
        }
      end
      MaxRank.sort(verified_max_ranks_array)
    end

    @votes_hash = Rails.cache.fetch("#{cache_key_user_votes}", expires_in: 1.day) do
      votes =Vote.joins(:max_rank).where('votes.user_id = ? AND max_ranks.game_id = ?', current_user.id, @game.id)
      votes_hash = {}
      votes.each do |vote|
        votes_hash[vote.max_rank_id] = vote.vote
      end
      votes_hash
    end
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      flash[:success] = "Successfully created #{@game.name}."
    else
      flash[:error] = 'Error creating a game.'
    end
    redirect_to session[:previous_url] || root_url
  end

  def update
    if @game.update_attributes(game_params)
      flash[:success] = "Successfully updated #{@game.name}."
    else
      flash[:error] = "Error updating #{@game.name}."
    end
    redirect_back
  end

  def approve
    game = Game.find_by_id(params[:id])
    if game
      game.approve
      flash[:success] = "Successfully approved #{game.name}."
    else
      flash[:error] = "Could not find a game with id #{params[:id]}."
    end
    redirect_to admin_approve_games_url
  end

  def reject
    game = Game.find_by_id(params[:id])
    if game
      game.reject
      flash[:success] = "Successfully rejected #{game.name}."
    else
      flash[:error] = "Could not find a game with id #{params[:id]}."
    end
    redirect_to admin_approve_games_url
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def game_params
    params.require(:game).permit(:name, :theme_id, :image)
  end

  def cache_key_all_games(page)
    max_updated_at = Game.where(status: 'Approved').maximum(:updated_at).try(:utc).try(:to_s, :number)
    "games/all-#{page}-#{max_updated_at}"
  end

  def cache_key_unverified_max_ranks
    max_updated_at = MaxRank.where(game_id: @game.id).maximum(:updated_at).try(:utc).try(:to_s, :number)
    "max_ranks/unverified/#{@game.id}-#{@game.name}-#{max_updated_at}"
  end

  def cache_key_verified_max_ranks
    max_updated_at = MaxRank.where(game_id: @game.id).maximum(:updated_at).try(:utc).try(:to_s, :number)
    "max_ranks/verified/#{@game.id}-#{@game.name}-#{max_updated_at}"
  end

  def cache_key_user_votes
    max_updated_at = Vote.joins(:max_rank).where('votes.user_id = ? AND max_ranks.game_id = ?', current_user.id, @game.id)
                         .maximum(:updated_at).try(:utc).try(:to_s, :number)
    "votes/#{current_user.id}-#{@game.id}-#{max_updated_at}"
  end
end