require 'rails_helper'

describe MaxRank, type: :model do
  describe '.create' do
    context 'Successful creation' do
      it 'with a source' do
        expect{MaxRank.create(source: Faker::Internet.url, user_id: FactoryGirl.create(:user).id)}.to change{MaxRank.count}.by(1)
      end
      
      it 'with default verified false' do
        max_rank = MaxRank.create(source: Faker::Internet.url, user_id: FactoryGirl.create(:user).id)
        expect(max_rank.verified).to eq(false)
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
      game = FactoryGirl.create(:game)
      max_rank = MaxRank.create(rank_type_id: rank_type.id, value: rand(1..100), user_id: user.id, game_id: game.id, source: Faker::Internet.url)
      10.times do 
        Vote.create(max_rank_id: max_rank.id, user_id: FactoryGirl.create(:user).id, vote: 1) 
      end
      
      expect(max_rank.upvotes).to eq(10)
    end
    
    it 'has 0 upvotes' do
      rank_type = FactoryGirl.create(:rank_type)
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game)
      max_rank = MaxRank.create(rank_type_id: rank_type.id, value: rand(1..100), user_id: user.id, game_id: game.id, source: Faker::Internet.url)
      expect(max_rank.upvotes).to eq(0)
    end
  end
  
  describe '#downvotes' do
    it 'has 0 downvotes' do
      game = FactoryGirl.create(:game)
      rank_type = FactoryGirl.create(:rank_type)
      user = FactoryGirl.create(:user)
      max_rank = MaxRank.create(rank_type_id: rank_type.id, value: rand(1..100), user_id: user.id, game_id: game.id, source: Faker::Internet.url)
      expect(max_rank.downvotes).to eq(0)
    end
  end
  
  describe '#verify' do
    it 'changes from verified false to true' do
      max_rank = FactoryGirl.create(:max_rank)
      expect(max_rank.verified).to eq(false)
      max_rank.verify
      expect(max_rank.verified).to eq(true)
    end
    
    it 'stays verified true' do
      max_rank = FactoryGirl.create(:max_rank, verified: true)
      expect(max_rank.verified).to eq(true)
      max_rank.verify
      expect(max_rank.verified).to eq(true)
    end
  end
  
  describe '#unverify' do
    it 'changes from verified true to false' do
      max_rank = FactoryGirl.create(:max_rank, verified: true)
      expect(max_rank.verified).to eq(true)
      max_rank.unverify
      expect(max_rank.verified).to eq(false)
    end
    
    it 'stays verified true' do
      max_rank = FactoryGirl.create(:max_rank)
      expect(max_rank.verified).to eq(false)
      max_rank.unverify
      expect(max_rank.verified).to eq(false)
    end
  end
  
  describe '.sort' do
    it 'returns the sorted array' do
      Vote.delete_all
      MaxRank.delete_all
      rank_type = FactoryGirl.create(:rank_type)
      user = FactoryGirl.create(:user)
      game = FactoryGirl.create(:game)
      10.times do
        max_rank = MaxRank.create!(rank_type_id: rank_type.id, value: rand(1..100), user_id: user.id, game_id: game.id, source: Faker::Internet.url)
        rand(1..10).times do 
          Vote.create!(max_rank_id: max_rank.id, user_id: FactoryGirl.create(:user).id, vote: [-1, 1, -1].sample) 
        end
      end
      
      max_ranks = MaxRank.where(game_id: game.id)
      max_ranks_array = max_ranks.map do |max_rank|
        rank_info = {
          max_rank: max_rank,
          upvotes: max_rank.upvotes,
          downvotes: max_rank.downvotes
        }
      end
      max_ranks_array = MaxRank.sort(max_ranks_array)
      
      sorted_array = MaxRank.sort(max_ranks_array)
      
      sorted_array.each_with_index do |max_rank, i|
        if sorted_array[i+1]
          expect(max_rank[:upvotes] - max_rank[:downvotes]).to be >= (sorted_array[i+1][:upvotes] - sorted_array[i+1][:downvotes])
          if max_rank[:upvotes] - max_rank[:downvotes] == sorted_array[i+1][:upvotes] - sorted_array[i+1][:downvotes]
            expect(max_rank[:upvotes] + max_rank[:downvotes]).to be >= (sorted_array[i+1][:upvotes] + sorted_array[i+1][:downvotes])
          end
        end
      end
      
    end
  end
end