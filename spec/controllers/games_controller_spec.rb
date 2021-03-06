require 'rails_helper'

describe GamesController, type: :controller do

  describe 'GET #index' do

    it 'responds successfully with an HTTP 200 status code' do
      get :index, nil, {fingerprint: '123456'}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the index template' do
      get :index, nil, {fingerprint: '123456'}
      expect(response).to render_template('index')
    end

    it 'should only display approved games' do
      Game.delete_all
      10.times do
        Game.create(name: Faker::Name.name, status: 'Pending')
      end
      10.times do
        Game.create(name: Faker::Name.name, status: 'Approved')
      end
      10.times do
        Game.create(name: Faker::Name.name, status: 'Rejected')
      end
      get :index, nil, {fingerprint: '123456'}

      expect(assigns(:games).count).to eq(Game.where(status: 'Approved').count)

    end

    it 'loads the first 50 games into @games' do
      games_array = []
      51.times do
        games_array << Game.create(status: 'Approved')
      end
      get :index, nil, {fingerprint: '123456'}

      expect(assigns(:games).count).to be <= 25
    end
  end

  describe 'GET #show' do

    before(:each) do
      @game = FactoryGirl.create(:game, status: 'Approved')
    end

    it 'responds successfully with an HTTP 200 status code' do
      get :show, {id: @game.id}, {fingerprint: '123456'}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'renders the show template' do
      get :show, {id: @game.id}, {fingerprint: '123456'}
      expect(response).to render_template('show')
    end

    it 'has all of its unverified max ranks' do
      10.times do
        FactoryGirl.create(:max_rank, game_id: @game.id)
      end

      10.times do
        FactoryGirl.create(:max_rank, game_id: @game.id, verified: true)
      end

      10.times do
        FactoryGirl.create(:max_rank)
      end

      get :show, {id: @game.id}, {fingerprint: '123456'}
      expect(assigns(:unverified_max_ranks_array).count).to eq(MaxRank.where(game_id: @game.id, verified: false).count)
    end

    it 'has all of its verified max ranks' do
      10.times do
        FactoryGirl.create(:max_rank, game_id: @game.id)
      end

      10.times do
        FactoryGirl.create(:max_rank, game_id: @game.id, verified: true)
      end

      10.times do
        FactoryGirl.create(:max_rank)
      end

      get :show, {id: @game.id}, {fingerprint: '123456'}
      expect(assigns(:verified_max_ranks_array).count).to eq(MaxRank.where(game_id: @game.id, verified: true).count)
    end

    it 'does not show a pending game' do
      @game = FactoryGirl.create(:game, status: 'Pending')
      expect { get :show, {id: @game.id}, {fingerprint: '123456'} }.to raise_error(ActionController::RoutingError)
    end
  end


  describe 'POST #create' do
    context 'successful game creation' do

      subject { post :create, {game: {name: 'Game Name'}}, {fingerprint: '123456'} }

      it 'should create a game' do
        allow(controller).to receive(:validate_recaptcha)
        expect { post :create, {game: {name: 'Game Name'}}, {fingerprint: '123456'} }.to change { Game.count }.by(1)
      end

      it 'should redirect back' do
        allow(controller).to receive(:validate_recaptcha)
        expect(subject).to redirect_to(root_url)
      end

      it 'should flash success' do
        allow(controller).to receive(:validate_recaptcha)
        subject
        expect(flash[:success]).to be_present
      end
    end
    context 'unsuccessful game creation' do

      subject { post :create, {game: {name: ''}}, {fingerprint: '123456'} }

      it 'should not create a blank game' do
        allow(controller).to receive(:validate_recaptcha)
        expect { post :create, game: {name: ''} }.to_not change { Game.count }
      end
      it 'should redirect back' do
        allow(controller).to receive(:validate_recaptcha)
        expect(subject).to redirect_to(root_url)
      end
      it 'should flash error' do
        allow(controller).to receive(:validate_recaptcha)
        subject
        expect(flash[:error]).to be_present
      end
    end
  end

  describe 'PATCH #update' do
    before(:all) do
      @game = FactoryGirl.create(:game)
      @theme = FactoryGirl.create(:theme)
    end

    subject { patch :update, {id: @game.id, game: {theme_id: @theme.id}}, {fingerprint: '123456'} }
    context 'when admin logged in' do
      before(:all) do
        @admin = FactoryGirl.create(:admin_user)
      end

      it 'updates successfully' do
        sign_in @admin
        subject
        expect(Game.find(@game.id).theme_id).to eq(@theme.id)
      end
    end

    context 'when admin not logged in' do
      it 'does not update' do
        subject
        expect(Game.find(@game.id).theme_id).to_not eq(@theme.id)
      end
    end
  end

  describe 'GET #approve' do
    subject { get :approve, {id: 1}, {fingerprint: '123456'} }

    context 'when admin logged in' do
      admin = FactoryGirl.create(:admin_user)

      it 'should redirect back to approve games page' do
        sign_in admin
        expect(subject).to redirect_to(admin_approve_games_url)
      end

      it 'should flash success' do
        sign_in admin
        game = FactoryGirl.create(:game)
        get :approve, {id: game.id}, {fingerprint: '123456'}
        expect(flash[:success]).to be_present
      end

      it 'should flash error' do
        sign_in admin
        game = FactoryGirl.create(:game)
        id = game.id
        game.destroy
        get :approve, {id: id}, {fingerprint: '123456'}
        expect(flash[:error]).to be_present
      end
    end

    context 'when admin not logged in' do
      it 'should redirect home' do
        expect(subject).to redirect_to(new_admin_user_session_url)
      end
    end
  end

  describe 'GET #reject' do
    subject { get :reject, {id: 1}, {fingerprint: '123456'} }

    context 'when admin logged in' do

      admin = FactoryGirl.create(:admin_user)

      it 'should redirect back to approve games page' do
        sign_in admin
        expect(subject).to redirect_to(admin_approve_games_url)
      end

      it 'should flash success' do
        sign_in admin
        game = FactoryGirl.create(:game)
        get :reject, {id: game.id}, {fingerprint: '123456'}
        expect(flash[:success]).to be_present
      end

      it 'should flash error' do
        sign_in admin
        game = FactoryGirl.create(:game)
        id = game.id
        game.destroy
        get :reject, {id: id}, {fingerprint: '123456'}
        expect(flash[:error]).to be_present
      end
    end

    context 'when admin not logged in' do
      it 'should redirect home' do
        expect(subject).to redirect_to(new_admin_user_session_url)
      end
    end
  end

end
