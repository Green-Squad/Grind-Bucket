require 'rails_helper'

RSpec.describe MaxRanksController, type: :controller do
  before(:each) do
    request.env['HTTP_REFERER'] = root_url
  end
  describe 'POST #create' do
    context 'successful max rank creation' do

      subject { post :create, {
                                max_rank: {
                                    rank_type_id: FactoryGirl.create(:rank_type).id,
                                    value: Faker::Number.number(10), source: Faker::Internet.url,
                                    game_id: FactoryGirl.create(:game).id
                                }
                            },
                     {
                         fingerprint: '123456'
                     }
      }

      it 'should create a max rank' do
        allow(controller).to receive(:validate_recaptcha)
        expect { post :create, {max_rank: {rank_type_id: FactoryGirl.create(:rank_type).id, value: Faker::Number.number(10), source: Faker::Internet.url, game_id: FactoryGirl.create(:game).id}}, {fingerprint: '123456'} }.to change { MaxRank.count }.by(1)
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

      it 'should upvote created max rank' do
        allow(controller).to receive(:validate_recaptcha)
        user = FactoryGirl.create(:user)
        sign_in user
        subject
        vote = Vote.where(max_rank_id: MaxRank.last.id, user_id: user.id, vote: 1).first
        expect(vote).to_not be(nil)
      end
    end
    context 'unsuccessful max rank creation' do

      subject { post :create, {max_rank: {rank_type_id: '', value: '', source: '', game_id: ''}}, {fingerprint: '123456'} }

      it 'should not create a blank max rank' do
        allow(controller).to receive(:validate_recaptcha)
        expect { post :create, {max_rank: {rank_type_id: '', value: '', source: '', game_id: ''}}, {fingerprint: '123456'} }.to_not change { MaxRank.count }
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
      it 'should not create a max rank without a user' do
        allow(controller).to receive(:validate_recaptcha)
        User.delete_all
        expect { post :create, {max_rank:
                                    {rank_type_id: FactoryGirl.create(:rank_type).id, value: Faker::Number.number(10), source: Faker::Internet.url, game_id: FactoryGirl.create(:game).id}
                             } }.to_not change { MaxRank.count }
      end
    end
  end

  describe 'GET #verify' do
    subject { get :verify, {id: MaxRank.first.id}, {fingerprint: '123456'} }

    before(:each) do
      MaxRank.delete_all
      FactoryGirl.create(:max_rank)
    end

    context 'when admin logged in' do
      admin = FactoryGirl.create(:admin_user)

      it 'should redirect back to game' do
        sign_in admin
        expect(subject).to redirect_to(root_url)
      end

      it 'should flash success' do
        sign_in admin
        game = FactoryGirl.create(:game, status: 'Approved')
        max_rank = FactoryGirl.create(:max_rank, game_id: game.id)
        get :verify, {id: max_rank.id}, {fingerprint: '123456'}

        expect(flash[:success]).to be_present
      end

      it 'should flash error' do
        sign_in admin
        game = FactoryGirl.create(:game, status: 'Approved')
        max_rank = FactoryGirl.create(:max_rank, game_id: game.id)
        id = max_rank.id
        max_rank.destroy
        get :verify, {id: id}, {fingerprint: '123456'}
        expect(flash[:error]).to be_present
      end
    end

    context 'when admin not logged in' do
      it 'should redirect home' do
        expect(subject).to redirect_to(new_admin_user_session_url)
      end
    end
  end

  describe 'GET #unverify' do
    subject { get :unverify, {id: MaxRank.first.id}, {fingerprint: '123456'} }

    before(:each) do
      MaxRank.delete_all
      FactoryGirl.create(:max_rank)
    end

    context 'when admin logged in' do

      admin = FactoryGirl.create(:admin_user)

      it 'should redirect back to approve games page' do
        sign_in admin
        expect(subject).to redirect_to(root_url)
      end

      it 'should flash success' do
        sign_in admin
        game = FactoryGirl.create(:game, status: 'Approved')
        max_rank = FactoryGirl.create(:max_rank, game_id: game.id, verified: true)
        get :unverify, {id: max_rank.id}, {fingerprint: '123456'}
        expect(flash[:success]).to be_present
      end

      it 'should flash error' do
        sign_in admin
        game = FactoryGirl.create(:game, status: 'Approved')
        max_rank = FactoryGirl.create(:max_rank, game_id: game.id, verified: true)
        id = max_rank.id
        max_rank.destroy
        get :unverify, {id: id}, {fingerprint: '123456'}
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
