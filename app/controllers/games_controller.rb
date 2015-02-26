class GamesController < ApplicationController
  before_action :authenticate_admin_user!, only: [:approve, :reject]
  before_action :set_game, only: :show
  before_action :validate_recaptcha, only: :create

  def index
    @games = Game.where(status: "Approved").order(:name).page params[:page]
  end

  
  def show
    max_ranks = MaxRank.where(game_id: @game.id)
    @max_ranks_array = max_ranks.map do |max_rank|
      rank_info = {
        max_rank: max_rank,
        upvotes: max_rank.upvotes,
        downvotes: max_rank.downvotes
      }
    end
    @max_ranks_array = MaxRank.sort(@max_ranks_array)
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
    params.require(:game).permit(:name)
  end
end