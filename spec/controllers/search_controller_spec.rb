require 'rails_helper'

describe SearchController, type: :controller do

  describe 'GET #search' do
    
    before(:each) do
      Game.delete_all
      100.times do
        FactoryGirl.create(:game, status: 'Approved')
      end
      100.times do
        FactoryGirl.create(:game)
      end
    end
    
    it 'redirects to game page' do
      game = FactoryGirl.create(:game, name: 'Halo 4', status: 'Approved')
      get :search, query: 'Halo 4'
      expect(response).to redirect_to(game_url(game.id))
    end
    
    it 'redirects to game page with whitespaces' do
      game = FactoryGirl.create(:game, name: 'Halo 4', status: 'Approved')
      get :search, query: 'H a l o   4    ' 
      expect(response).to redirect_to(game_url(game.id))
    end
    
    it 'redirects to game page with no whitespace' do
      game = FactoryGirl.create(:game, name: 'Halo 4', status: 'Approved')
      get :search, query: 'Halo4'
      expect(response).to redirect_to(game_url(game.id))
    end
    
    it 'redirects to game page with incomplete title' do
      game = FactoryGirl.create(:game, name: 'Halo 4', status: 'Approved')
      get :search, query: 'Halo'
      expect(response).to redirect_to(game_url(game.id))
    end
    
    it 'redirects to game page with different case' do
      game = FactoryGirl.create(:game, name: 'Halo 4', status: 'Approved')
      get :search, query: 'hALO 4'
      expect(response).to redirect_to(game_url(game.id))
    end
    
    it 'does not redirect to game page if it is pending' do
      game = FactoryGirl.create(:game, name: 'Halo 4', status: 'Pending')
       get :search, query: 'Halo 4'
      expect(response).to_not redirect_to(game_url(game.id))
    end
    
    it 'redirects to search results page if no match is found' do
      get :search, query: 'Halo 4 ADSFSDFSDFSDJFKLSDJFLKSDJFL'
      expect(response).to render_template('search/search')
    end
    
    it 'redirects to home page if no query' do
      get :search
      expect(response).to redirect_to(root_url)
    end
    
    context 'render views' do
      render_views
      
      it 'has search query in response' do
        query = 'Halo 4 ADSFSDFSDFSDJFKLSDJFLKSDJFL'
        get :search, query: query
        expect(response.body).to match(/Halo 4 ADSFSDFSDFSDJFKLSDJFLKSDJFL/)
      end
    end
    
  end
  
  describe 'POST #autocomplete' do

    it 'returns a JSON' do
      post :autocomplete, query: 'a', format: :json
      expect(response['Content-Type']).to include("application/json")
    end

  end
  
  describe '#search_array' do
    
    before(:each) do
      Game.delete_all
      100.times do
        FactoryGirl.create(:game, status: 'Approved')
      end
      100.times do
        FactoryGirl.create(:game)
      end
    end
    
    it 'is an array' do
      query = 'a'
      games_array = SearchController.new.send(:search_array, query)
      expect(games_array).to be_instance_of(Array)
    end

    it 'should be case insensitive' do
      query = 'a'
      run1 = SearchController.new.send(:search_array, query)
      
      query = 'A'
      run2 = SearchController.new.send(:search_array, query)
      
      expect(run1.count).to be > 0
      expect(run1).to eq(run2)
    end
    
    it 'should not be nil' do
      query = 'a'
      games_array = SearchController.new.send(:search_array, query)
      
      expect(games_array).to_not be nil
    end
    
    it 'should only contain approved games' do
      query = 'a'
      games_array = SearchController.new.send(:search_array, query)
      expect(games_array.count).to be > 0
      games_array.each do |game|
        expect(Game.find_by_name(game).status).to eq('Approved')
      end
    end
    
    it 'should have more than 0' do
      query = 'a'
      games_array = SearchController.new.send(:search_array, query)
      
      expect(games_array.count).to be > 0
    end
    
    it 'should have no more than 10' do
      query = 'a'
      games_array = SearchController.new.send(:search_array, query)
      
      expect(games_array.count).to be <= 10
    end
    
    it 'contains search term a' do
      query = 'a'
      games_array = SearchController.new.send(:search_array, query)
      expect(games_array.count).to be > 0
      games_array.each do |game|
        expect(game.downcase.delete(' ').delete('/')).to include(query.downcase.delete(' ').delete('/'))
      end
    end
    
    it 'contains search term Halo' do
      5.times do |count|
        FactoryGirl.create(:game, name: "#{count} Halo #{count}", status: 'Approved')
      end
      query = 'Halo'
      games_array = SearchController.new.send(:search_array, query)
      expect(games_array.count).to be > 0
      games_array.each do |game|
        expect(game.downcase.delete(' ').delete('/')).to include(query.downcase.delete(' ').delete('/'))
      end
    end
  end

end
