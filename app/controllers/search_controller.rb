class SearchController < ApplicationController
  
  def search
    if params[:query]
      search = params[:query].downcase.delete(' ')
      game = Game.where("LOWER(REPLACE(name, ' ', '')) LIKE ? AND status = 'Approved'", "#{search}%").order(:name).first
      if game
        redirect_to game_url(game.slug)
      else
        begin
          @google_request = JSON.load(open(ENV['SEARCH_URL'] + params[:query]));
          @total_results = @google_request['items'].present? ? @google_request['items'].size : 0
          render 'search'
        rescue
          redirect_to "https://www.google.com/?#q=site:lvlcap.kyledornblaser.com+#{params[:query]}"
        end
      end
    else
      redirect_to root_url
    end
  end

  def autocomplete
    respond_to do |format|
      format.json { render json: search_array(params[:query]) }
    end
  end

  private

  def search_array(query)
    search_array = []

    name = query.downcase.delete(' ').delete('/')
    games = Game.where("LOWER(REPLACE(name, ' ', '')) LIKE ? AND status = 'Approved'", "%#{name}%").order(:name).take(10)
    games.each do |game|
      search_array.push(game.name)
    end

    search_array
  end
end
