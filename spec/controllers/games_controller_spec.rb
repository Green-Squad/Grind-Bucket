require 'rails_helper'

RSpec.describe GamesController, type: :controller do
describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
    
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "loads the first 50 games into @games" do
      games_array = []
      51.times do
        games_array << Game.create!
      end
      get :index
      
      expect(assigns(:games).count).to be <=  50
    end
  end
end
