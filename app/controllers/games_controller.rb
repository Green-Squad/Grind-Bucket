class GamesController < ApplicationController
  def index
    @games = Game.all.page params[:page]
  end
end