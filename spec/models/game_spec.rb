require 'rails_helper'
require 'open-uri'

describe Game, type: :model do

  describe '.getJSON' do

    xit 'is a hash' do
      games = Game.getJSON
      expect(games).to be_instance_of(Hash)
    end

    xit 'returns the right hash' do
      games = Game.getJSON
      game_platforms = [ 'ps4', 'xboxone', 'ps3', 'xbox360', 'pc', 'wii-u' ]
      headers =  {'X-Mashape-Key' => ENV['X_MASHAPE_KEY']}
      base_url = 'https://byroredux-metacritic.p.mashape.com/'
      games_hash = {}
      game_platforms.each do |platform|
        games_hash["#{platform}"] = JSON.load(open("#{base_url}game-list/#{platform}/new-releases", headers))
      end
      expect(games).to eq(games_hash)
    end
  end

  describe '.import' do

    xit 'should be the same count as games added' do
      games_count = Game.count
      imported_games = Game.import
      expect(imported_games.count).to eq(Game.count - games_count)
    end

    xit 'should add at least one game' do
      games_count = Game.count
      imported_games = Game.import
      expect(imported_games.count).to be > 0
    end

    xit 'should be saved and set to pending' do
      games_count = Game.count
      imported_games = Game.import
      imported_games.each do |game|
        expect(game.status).to eq('Pending')
        expect(game).to eq(Game.find(game.id))
        expect(game).to be_instance_of(Game)
      end
    end
  end

  describe '#approve' do

    it 'Should be pending' do
      game = FactoryGirl.create(:game)
      expect(game.status).to eq('Pending')
    end

    it 'Should be approved' do
      game = FactoryGirl.create(:game)
      game.approve
      expect(game.status).to eq('Approved')
    end
  end

  describe '#reject' do
    it 'Should be pending' do
      game = FactoryGirl.create(:game)
      expect(game.status).to eq('Pending')
    end

    it 'Should be approved' do
      game = FactoryGirl.create(:game)
      game.reject
      expect(game.status).to eq('Rejected')
    end
  end
  
  describe '.create' do
    
    context 'Successful creation' do
      it 'with a name' do
        expect{Game.create(name: Faker::Name.name)}.to change{Game.count}.by(1)
      end
    end
    
    context 'Unsuccessful creation' do
      it 'without a name' do
        expect{Game.create(name: '')}.to_not change{Game.count}
      end
    end
  end
  
  describe '.select_list' do
    before(:each) do
      5.times do 
        FactoryGirl.create(:game)
      end
      5.times do
        FactoryGirl.create(:game, status: 'Approved')
      end
    end
    it 'returns array' do
      expect(Game.select_list).to be_instance_of(Array)
    end
    
    it 'has the same count as approved games count' do
      expect(Game.select_list.count).to eq(Game.where(status: 'Approved').count + 1)
    end
    
    it 'has the correct id for each name' do
      select_list = Game.select_list
      # Remove first empty element
      select_list.shift
      select_list.each do |name, id|
        game = Game.find(id)
        expect(game.name).to eq(name)
      end
    end
    
    it 'includes every approved game' do
      select_list = Game.select_list
      # Remove first empty element
      select_list.shift
      Game.where(status: 'Approved').each do |game|
        array = [game.name, game.id]
        expect(select_list).to include(array)
      end
    end
    
    it 'is greater than 0' do
      expect(Game.select_list.count).to be > 0
    end
    
    xit 'is sorted' do
      list = Game.select_list
      # Remove first empty element
      list.shift
      select_list = list.sort do |a, b|
        a[0] <=> b[0]
      end
      expect(Game.select_list).to eq(select_list)
    end
    
    it 'has only approved games' do
      select_list = Game.select_list
      # Remove first empty element
      select_list.shift
      select_list.each do |name, id|
        game = Game.find(id)
        expect(game.status).to eq('Approved')
      end
    end
  end
  
  describe '.fix_slug' do
    it 'creates unique slug' do
      game = FactoryGirl.create(:game)
      game2 = FactoryGirl.create(:game, name: game.name)
      
      expect(game.slug).to_not eq(game2.slug)
    end
  end

  describe '.set_theme' do
    before(:all) do
      FactoryGirl.create(:theme, name: 'default')
    end

    it 'sets a default theme if no theme is defined' do
      game = Game.create(name: 'failure game')
      expect(game.theme.name).to_not be(nil)
    end

    it 'does not set a default theme if one is already defined' do
      theme = FactoryGirl.create(:theme)
      game = Game.create(name: 'failure game', theme_id: theme.id)
      expect(game.theme.name).to_not eq('default')
    end
  end

end
