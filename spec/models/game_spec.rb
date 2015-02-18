require 'rails_helper'
require 'open-uri'

describe Game, type: :model do
  describe '.getJSON' do
    games = Game.getJSON
    
    it "is a hash" do
      expect(games).to be_instance_of(Hash)
    end
    
    game_platforms = [ "ps4", "xboxone", "ps3", "xbox360", "pc", "wii-u" ]
    headers =  {"X-Mashape-Key" => ENV["X_MASHAPE_KEY"]}
    base_url = "https://byroredux-metacritic.p.mashape.com/"
    games_hash = {}
    game_platforms.each do |platform|
      games_hash["#{platform}"] = JSON.load(open("#{base_url}game-list/#{platform}/new-releases", headers))
    end
    
    it "returns the right hash" do
      expect(games).to eq(games_hash)
    end
  end
  
  describe '.import' do
    games_count = Game.count
    imported_games = Game.import
    
    it "should be the same count as games added" do
      expect(imported_games.count).to eq(Game.count - games_count)
    end
    
    it "should add at least one game" do
      expect(imported_games.count).to be > 0
    end
    
    it "should be saved and set to pending" do
      imported_games.each do |game|
        expect(game.status).to eq("Pending")
        expect(game).to eq(Game.find(game.id))
        expect(game).to be_instance_of(Game)
      end
    end
  end
end
