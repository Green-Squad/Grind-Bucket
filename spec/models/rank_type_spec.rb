require 'rails_helper'

describe RankType, type: :model do

  describe '.select_list' do
    before(:each) do
      5.times do 
        FactoryGirl.create(:rank_type)
      end
    end
    it 'returns array' do
      expect(RankType.select_list).to be_instance_of(Array)
    end
    
    it 'has the same count as RankType.count' do
      # Adding one to RankType.count for the empty element we add for a placeholder
      expect(RankType.select_list.count).to eq(RankType.count + 1)
    end
    
    it 'has the correct id for each name' do
      select_list = RankType.select_list
      # Remove first empty element
      select_list.shift
      select_list.each do |name, id|
        rank_type = RankType.find(id)
        expect(rank_type.name).to eq(name)
      end
    end
    
    it 'includes every rank type' do
      select_list = RankType.select_list
      RankType.all.each do |rank_type|
        array = [rank_type.name, rank_type.id]
        expect(select_list).to include(array)
      end
    end
    
    it 'is greater than 0' do
      expect(RankType.select_list.count).to be > 0
    end
    
    it 'is sorted' do
      list = RankType.select_list
      # Remove first empty element
      list.shift
      select_list = list.sort do |a, b|
        a[0] <=> b[0]
      end
      expect(list).to eq(select_list)
    end
  end

end
