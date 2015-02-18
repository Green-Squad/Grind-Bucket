class GamesController < ApplicationController
  before_action :authenticate_admin_user!, only: [:approve, :reject]
  
  def index
    @games = Game.where(status: "Approved").order(:name).page params[:page]
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
end