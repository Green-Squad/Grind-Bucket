require 'rails_helper'

describe GamesController, type: :controller do
  
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
        games_array << Game.create(status: "Approved")
      end
      get :index
      
      expect(assigns(:games).count).to be <=  50
    end
    
    it "should only display approved games" do
      Game.delete_all
      10.times do
        Game.create(status: "Pending")
      end
      10.times do
        Game.create(status: "Approved")
      end
      10.times do
        Game.create(status: "Rejected")
      end
      get :index
      expect(assigns(:games).count).to eq(10)
    end
  end
  
  describe "GET #approve" do
    subject { get :approve, id: 1 }
    
    context "when admin logged in" do
      admin = FactoryGirl.create(:admin_user)
      
      it "should redirect back to approve games page" do
        sign_in admin
        expect(subject).to redirect_to(admin_approve_games_url)
      end
      
      it "should flash success" do
        sign_in admin
        game = FactoryGirl.create(:game)
        get :approve, id: game.id
        expect(flash[:success]).to be_present
      end
      
      it "should flash error" do
        sign_in admin
        game = FactoryGirl.create(:game)
        id = game.id
        game.destroy
        get :approve, id: id
        expect(flash[:error]).to be_present
      end
    end
    
    context "when admin not logged in" do
      it "should redirect home" do
        expect(subject).to redirect_to(new_admin_user_session_url)
      end
    end
  end
  
  describe "GET #reject" do
    subject { get :reject, id: 1 }
        
    context "when admin logged in" do
      
      admin = FactoryGirl.create(:admin_user)
      
      it "should redirect back to approve games page" do
        sign_in admin
        expect(subject).to redirect_to(admin_approve_games_url)
      end
      
      it "should flash success" do
        sign_in admin
        game = FactoryGirl.create(:game)
        get :reject, id: game.id
        expect(flash[:success]).to be_present
      end
      
      it "should flash error" do
        sign_in admin
        game = FactoryGirl.create(:game)
        id = game.id
        game.destroy
        get :reject, id: id
        expect(flash[:error]).to be_present
      end
    end
    
    context "when admin not logged in" do
      it "should redirect home" do
        expect(subject).to redirect_to(new_admin_user_session_url)
      end
    end
  end
  
end
