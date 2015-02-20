class SearchController < ApplicationController
  def search

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
