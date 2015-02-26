require 'rails_helper'

describe MaxRank, type: :model do
  describe '.create' do
    context 'Successful creation' do
      it 'with a source' do
        expect{MaxRank.create(source: Faker::Internet.url, user_id: FactoryGirl.create(:user).id)}.to change{MaxRank.count}.by(1)
      end
    end
    
    context 'Unsuccessful creation' do
      it 'without a source' do
        expect{MaxRank.create(source: '', user_id: FactoryGirl.create(:user).id)}.to_not change{MaxRank.count}
      end
    end
  end
  
  describe '#upvotes' do
    it 'has the correct number of upvotes' do
      rank_type = FactoryGirl.create(:rank_type)
      user = FactoryGirl.create(:user)
      max_rank = MaxRank.create(rank_type_id: rank_type.id, value: rand(1..100), user_id: user.id, game_id: 34, source: Faker::Internet.url)
      10.times do 
        Vote.create(max_rank_id: max_rank.id, user_id: FactoryGirl.create(:user).id, vote: 1) 
      end
      
      expect(max_rank.upvotes).to eq(10)
    end
    
    it 'has 0 upvotes' do
      rank_type = FactoryGirl.create(:rank_type)
      user = FactoryGirl.create(:user)
      max_rank = MaxRank.create(rank_type_id: rank_type.id, value: rand(1..100), user_id: user.id, game_id: 34, source: Faker::Internet.url)
      expect(max_rank.upvotes).to eq(0)
    end
  end
  
  describe '#downvotes' do
    it 'has 0 downvotes' do
      rank_type = FactoryGirl.create(:rank_type)
      user = FactoryGirl.create(:user)
      max_rank = MaxRank.create(rank_type_id: rank_type.id, value: rand(1..100), user_id: user.id, game_id: 34, source: Faker::Internet.url)
      expect(max_rank.downvotes).to eq(0)
    end
  end
end