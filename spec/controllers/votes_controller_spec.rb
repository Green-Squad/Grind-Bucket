require 'rails_helper'

describe VotesController, type: :controller do

  describe 'POST #create' do
    context 'successful creation' do
      context 'upvote' do
        it 'should change count by 1' do
          expect{post :create, { vote: { vote: '1', max_rank_id: FactoryGirl.create(:max_rank).id }, format: :json }, { fingerprint: '123456' }}.to change{Vote.count}.by(1)
        end

        it 'should have required attributes' do
          max_rank = FactoryGirl.create(:max_rank)
          post :create, { vote: { vote: '1', max_rank_id: max_rank.id }, format: :json }, { fingerprint: '123456'}
          expect(Vote.last.max_rank_id).to eq(max_rank.id)
          expect(Vote.last.vote).to eq(1)
        end

        it 'should render json' do
          post :create, { vote: { vote: '1', max_rank_id: FactoryGirl.create(:max_rank).id }, format: :json }, { fingerprint: '123456'}
          expect(response['Content-Type']).to include('application/json')
        end
      end

      context 'downvote' do
        it 'should change count by 1' do
          expect{post :create, { vote: { vote: '-1', max_rank_id: FactoryGirl.create(:max_rank).id }, format: :json }, { fingerprint: '123456' }}.to change{Vote.count}.by(1)
        end

        it 'should have required attributes' do
          max_rank = FactoryGirl.create(:max_rank)
          post :create, { vote: { vote: '-1', max_rank_id: max_rank.id }, format: :json }, { fingerprint: '123456'}
          expect(Vote.last.max_rank_id).to eq(max_rank.id)
          expect(Vote.last.vote).to eq(-1)
        end
      end
    end
    context 'unsucessful creation' do
      it 'with no user' do
        User.delete_all
        expect{post :create, { vote: { vote: '-1', max_rank_id: FactoryGirl.create(:max_rank).id}, format: :json }}.to_not change{Vote.count}
      end

      it 'with invalid vote' do
        expect{post :create, { vote: { vote: '2', max_rank_id: FactoryGirl.create(:max_rank).id}, format: :json }, { fingerprint: '123456' }}.to_not change{Vote.count}
      end

      it 'with no vote' do
        expect{post :create, { vote: { vote: '', max_rank_id: FactoryGirl.create(:max_rank).id}, format: :json }, { fingerprint: '123456' }}.to_not change{Vote.count}
      end

      it 'with no max_rank' do
        expect{post :create, { vote: { vote: '1', max_rank_id: '' }, format: :json }, { fingerprint: '123456' }}.to_not change{Vote.count}
      end
    end

    context 'same user with multiple max rank votes' do
      it 'deletes with all same attributes' do
        max_rank = FactoryGirl.create(:max_rank)
        post :create, { vote: { vote: '1', max_rank_id: max_rank.id }, format: :json }, { fingerprint: '123456'}
        expect { post :create, { vote: { vote: '1', max_rank_id: max_rank.id }, format: :json }, { fingerprint: '123456'} }.to change{Vote.count}.by(-1)
      end
      it 'changes vote with different vote' do
         max_rank = FactoryGirl.create(:max_rank)
        post :create, { vote: { vote: '1', max_rank_id: max_rank.id }, format: :json }, { fingerprint: '123456'}
        expect { post :create, { vote: { vote: '-1', max_rank_id: max_rank.id }, format: :json }, { fingerprint: '123456'} }.to_not change{Vote.count}
        expect(Vote.last.vote).to eq(-1)
      end

    end
  end
end
