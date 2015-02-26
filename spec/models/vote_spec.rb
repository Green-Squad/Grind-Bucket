require 'rails_helper'

describe Vote, type: :model do

  describe '.create' do 
    context 'successful creation' do
      
    end
    
    context 'unsuccessful creation' do
      it 'with a duplicate vote by same user' do
        user = FactoryGirl.create(:user)
        max_rank = FactoryGirl.create(:max_rank)
        
        expect{Vote.create(vote: 1, max_rank_id: max_rank.id, user_id: user.id)}.to change{Vote.count}.by(1)
        expect{Vote.create(vote: 1, max_rank_id: max_rank.id, user_id: user.id)}.to_not change{Vote.count}
      end
      
      it 'with different vote by same user' do
        user = FactoryGirl.create(:user)
        max_rank = FactoryGirl.create(:max_rank)
        
        expect{Vote.create(vote: 1, max_rank_id: max_rank.id, user_id: user.id)}.to change{Vote.count}.by(1)
        expect{Vote.create(vote: -1, max_rank_id: max_rank.id, user_id: user.id)}.to_not change{Vote.count}
      end
    end
  end
end
