require 'rails_helper'

describe MaxRank, type: :model do
  describe '.create' do
    context 'Successful creation' do
      it 'with a source' do
        expect{MaxRank.create(source: Faker::Internet.url)}.to change{MaxRank.count}.by(1)
      end
    end
    
    context 'Unsuccessful creation' do
      it 'without a source' do
        expect{MaxRank.create(source: '')}.to_not change{MaxRank.count}
      end
    end
  end

end