require 'rails_helper'
require 'open-uri'

describe Game, type: :model do

  describe ".getJSON" do

    xit "is a hash" do
      games = Game.getJSON
      expect(games).to be_instance_of(Hash)
    end

    xit "returns the right hash" do
      games = Game.getJSON
      game_platforms = [ "ps4", "xboxone", "ps3", "xbox360", "pc", "wii-u" ]
      headers =  {"X-Mashape-Key" => ENV["X_MASHAPE_KEY"]}
      base_url = "https://byroredux-metacritic.p.mashape.com/"
      games_hash = {}
      game_platforms.each do |platform|
        games_hash["#{platform}"] = JSON.load(open("#{base_url}game-list/#{platform}/new-releases", headers))
      end
      expect(games).to eq(games_hash)
    end
  end

  describe ".import" do

    xit "should be the same count as games added" do
      games_count = Game.count
      imported_games = Game.import
      expect(imported_games.count).to eq(Game.count - games_count)
    end

    xit "should add at least one game" do
      games_count = Game.count
      imported_games = Game.import
      expect(imported_games.count).to be > 0
    end

    xit "should be saved and set to pending" do
      games_count = Game.count
      imported_games = Game.import
      imported_games.each do |game|
        expect(game.status).to eq("Pending")
        expect(game).to eq(Game.find(game.id))
        expect(game).to be_instance_of(Game)
      end
    end
  end

  describe "#approve" do

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

  describe "#reject" do
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
  
  describe ".create" do
    
    context "Successful creation" do
      it "with a name" do
        Game.create(name: Faker::Name.name)
      end
    end
    
    context "Unsuccessful creation" do
      it "without a name" do
        Game.create(name: '')
      end
    end
  end

end
