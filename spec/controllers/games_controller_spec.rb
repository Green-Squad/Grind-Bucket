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

    it "loads all of the posts into @games" do
      game1, game2 = Game.create!, Game.create!
      get :index

      expect(assigns(:games)).to match_array([game1, game2])
    end
  end
end
